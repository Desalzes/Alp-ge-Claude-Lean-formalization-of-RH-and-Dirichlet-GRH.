"""Small offline tests; CI separately queries the real release data."""
import csv
import gzip
import importlib.util
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).resolve().parents[1] / "tools" / "r01_kernel_probe.py"
spec = importlib.util.spec_from_file_location("probe", MODULE_PATH)
probe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(probe)


class KernelProbeTests(unittest.TestCase):
    def test_exact_membership_does_not_infer_from_suffix(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "cone.gz"
            with gzip.open(path, "wt", encoding="utf-8") as out:
                out.write("A.foo\nB.bar\n")
            found, suggestions = probe.probe_cone(path, ("A.foo", "C.foo"))
            self.assertEqual(found, {"A.foo"})
            self.assertEqual(suggestions["C.foo"], ["A.foo"])

    def test_shortest_parent_chain_is_preserved(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "parents.gz"
            with gzip.open(path, "wt", encoding="utf-8", newline="") as stream:
                writer = csv.DictWriter(stream, fieldnames=["node", "decl_or_const", "origin", "parent", "witness"])
                writer.writeheader()
                writer.writerow({"node": "Main@a", "decl_or_const": "Main", "origin": "project", "parent": "", "witness": ""})
                writer.writerow({"node": "A@b", "decl_or_const": "A", "origin": "project", "parent": "Main@a", "witness": "Main -> A [value]"})
                writer.writerow({"node": "B@c", "decl_or_const": "B", "origin": "project", "parent": "A@b", "witness": "A -> B [value]"})
            paths = probe.parent_paths(path, {"B"})
            self.assertEqual([node for node, _ in paths["B"][0]], ["Main@a", "A@b", "B@c"])

    def test_cycle_in_parent_data_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "parents.gz"
            with gzip.open(path, "wt", encoding="utf-8", newline="") as stream:
                writer = csv.DictWriter(stream, fieldnames=["node", "decl_or_const", "origin", "parent", "witness"])
                writer.writeheader()
                writer.writerow({"node": "A@a", "decl_or_const": "A", "parent": "B@b"})
                writer.writerow({"node": "B@b", "decl_or_const": "B", "parent": "A@a"})
            with self.assertRaisesRegex(ValueError, "Cycle"):
                probe.parent_paths(path, {"B"})


if __name__ == "__main__":
    unittest.main()
