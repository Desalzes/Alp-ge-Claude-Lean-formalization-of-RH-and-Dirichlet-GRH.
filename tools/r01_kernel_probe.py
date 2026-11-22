#!/usr/bin/env python3
"""Pin and query a published *kernel-term* declaration dependency cone.

This does not prove a mathematical theorem, nor establish proof correctness.
It answers whether an exact declaration occurs in a particular exported kernel
closure and, optionally, prints a shortest witness chain from that release.
"""

from __future__ import annotations

import argparse
import csv
import gzip
import hashlib
import sys
import urllib.error
import urllib.request
from pathlib import Path

RELEASE = "v0.2.1"
BASE_URL = ("https://github.com/james-shore/rh-proof-dependencies/releases/"
            f"download/{RELEASE}")
ASSETS = {
    "cone-decls.txt.gz": "b0c968a99cd89ab1aa8db9d4af2f69722810903181d6f6094553e3420b02f297",
    "why-parents.csv.gz": "30fb816eb8f095cb280a525a470e477fa6b99e4aea6c6413dc44c7b80d79b41b",
}
TARGETS = (
    "Formalism.ThetaLiftIndependence.ChainScalar",
    "Formalism.ThetaLiftIndependence.ChainScalarLemmas.mem",
    "GlobalTheory.SqStep.theta_tower_norm_step_small_rank",
    "GlobalTheory.T.witt_tower_norm_step_of_small_rank",
    "GlobalTheory.Square.StepRatio",
    "GlobalTheory.SqStepArith.stepFac_ratio_core",
    "GlobalTheory.ConstRatio.Factor",
    "GlobalTheory.ConstRatio.Factor.isConst",
    "GlobalTheory.BotTransfer.bottom_constant_transfer_along_tower",
)


def checked_asset(cache: Path, filename: str, *, download: bool) -> Path:
    """Verify compressed bytes against the release asset's published SHA256."""
    path = cache / filename
    cache.mkdir(parents=True, exist_ok=True)
    if not path.is_file() and download:
        url = f"{BASE_URL}/{filename}"
        with urllib.request.urlopen(url, timeout=120) as response, path.open("wb") as out:
            while chunk := response.read(1024 * 1024):
                out.write(chunk)
    if not path.is_file():
        raise FileNotFoundError(f"{path} (use --download to retrieve the release asset)")
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(1024 * 1024):
            digest.update(chunk)
    if digest.hexdigest() != ASSETS[filename]:
        raise ValueError(f"SHA256 mismatch for {filename}; do not use this dataset")
    return path


def probe_cone(path: Path, targets: tuple[str, ...]) -> tuple[set[str], dict[str, list[str]]]:
    """Exact-match search; near matches are diagnostic only, not positive hits."""
    requested = set(targets)
    found: set[str] = set()
    suggestions: dict[str, list[str]] = {t: [] for t in targets}
    with gzip.open(path, "rt", encoding="utf-8", newline="") as stream:
        for line in stream:
            name = line.rstrip("\r\n")
            if name in requested:
                found.add(name)
            # A name may match one target exactly, while merely resembling
            # another target. Keep exact membership independent of suggestions.
            for t in targets:
                if name != t and name.endswith("." + t.split(".")[-1]) and len(suggestions[t]) < 4:
                    suggestions[t].append(name)
    return found, suggestions


def parent_paths(path: Path, targets: set[str]) -> dict[str, list[list[tuple[str, str]]]]:
    """Trace the published shortest-parent table, NOT every dependency path."""
    rows: dict[str, tuple[str, str, str]] = {}
    hits: dict[str, list[str]] = {t: [] for t in targets}
    with gzip.open(path, "rt", encoding="utf-8", newline="") as stream:
        reader = csv.DictReader(stream)
        expected = {"node", "decl_or_const", "origin", "parent", "witness"}
        if not expected.issubset(reader.fieldnames or []):
            raise ValueError(f"Unexpected parent table columns: {reader.fieldnames}")
        for row in reader:
            node = row["node"]
            if not node:
                continue
            rows[node] = (row["parent"], row["witness"], row["decl_or_const"])
            if row["decl_or_const"] in targets:
                hits[row["decl_or_const"]].append(node)
    result: dict[str, list[list[tuple[str, str]]]] = {}
    for target, nodes in hits.items():
        paths: list[list[tuple[str, str]]] = []
        for node in nodes:
            visited: set[str] = set()
            chain: list[tuple[str, str]] = []
            current = node
            while current:
                if current in visited:
                    raise ValueError(f"Cycle in BFS parent table: {current}")
                visited.add(current)
                if current not in rows:
                    raise ValueError(f"Parent not in v0.2.1 parent table: {current}")
                parent, witness, _ = rows[current]
                chain.append((current, witness))
                current = parent
            paths.append(list(reversed(chain)))
        result[target] = paths
    return result


def report(found: set[str], suggestions: dict[str, list[str]],
           paths: dict[str, list[list[tuple[str, str]]]] | None,
           targets: tuple[str, ...]) -> None:
    print(f"Dataset: james-shore/rh-proof-dependencies {RELEASE}")
    print("Scope: transitive kernel-term references from the published five RH/Dirichlet GRH theorems")
    for target in targets:
        print(f"\n{target}")
        if target not in found:
            print("  NOT IN THE PUBLISHED KERNEL DECLARATION CONE (exact name)")
            if suggestions[target]:
                print("  Possible name variants (NOT verified as the target): " + ", ".join(suggestions[target]))
            continue
        print("  IN THE PUBLISHED KERNEL DECLARATION CONE (exact name)")
        if paths is None:
            print("  Path: not requested")
        elif not paths.get(target):
            print("  Path: no match in parent table (dataset inconsistency or naming issue)")
        else:
            for n, chain in enumerate(paths[target], 1):
                print(f"  Shortest witness chain {n}: {len(chain) - 1} edges")
                for node, witness in chain:
                    print(f"    {node}" + (f"  [via {witness}]" if witness else ""))
    print(f"\nExact cone membership: {len(found)}/{len(targets)} queried names")
    print("IMPORTANT: Nonmembership does not imply elaboration, tactics or imports can be removed.")


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--cache", type=Path, default=Path("/tmp/rh-deps-v0.2.1"))
    ap.add_argument("--download", action="store_true", help="Download and SHA-verify missing assets")
    ap.add_argument("--parents", action="store_true", help="Also download and query shortest witness paths")
    ap.add_argument("--targets", nargs="+", help="Override the nine named research targets")
    args = ap.parse_args(argv)
    targets = tuple(args.targets or TARGETS)
    cone_file = checked_asset(args.cache, "cone-decls.txt.gz", download=args.download)
    found, suggestions = probe_cone(cone_file, targets)
    paths = None
    if args.parents:
        parent_file = checked_asset(args.cache, "why-parents.csv.gz", download=args.download)
        paths = parent_paths(parent_file, found)
    report(found, suggestions, paths, targets)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (ValueError, OSError, urllib.error.URLError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        sys.exit(2)
