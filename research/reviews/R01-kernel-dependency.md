# R01 — Kernel-dependency probe for T01/T02 declarations

**Date:** 2026-11-22. **Status:** reproducible script added; real-data result must be read from GitHub Actions before any reachability claim. No new RH/GRH theorem is asserted.

## Question and scope

T01 (draft PR #1) and T02 (draft PR #2) verify isolated algebraic statements. They do not establish that their motivating original declarations are referenced by the five main RH/Dirichlet GRH proof terms. We check **exact named declaration membership in the exported kernel closure**, not mere source-text occurrences.

The dataset is [james-shore/rh-proof-dependencies v0.2.1](https://github.com/james-shore/rh-proof-dependencies/releases/tag/v0.2.1), source commit [70fbb2fc21fed8de3c02d9f6df0b6067bf22e879](https://github.com/james-shore/rh-proof-dependencies/commit/70fbb2fc21fed8de3c02d9f6df0b6067bf22e879). The [dataset documentation](https://github.com/james-shore/rh-proof-dependencies/blob/70fbb2fc21fed8de3c02d9f6df0b6067bf22e879/docs/dataset.md) defines kernel-term closure and BFS-parent witness chains. The T01/T02 source snapshot was reported as leanprover-community/riemann-hypothesis `8f558a8848a80dac6851a00a95ca477ff403e922`; different names can indicate revision drift rather than substantive absence.

## Reproduce the experiment

```sh
python3 -m unittest discover -s tests -p test_r01_kernel_probe.py -v
python3 tools/r01_kernel_probe.py --download --parents | tee r01-proof-cone-results.txt
```

The script retrieves the 5.8 MB declaration cone and 38.3 MB shortest-parent table as v0.2.1 release assets, validates the compressed SHA256 checksums, tests nine exact declaration names (including `ChainScalar`, `StepRatio`, `Factor`, `Factor.isConst`, tower-step and bottom-transfer declarations), and prints a shortest witness from the published proof terms for each match. No giant Lean build or nonstandard Python package is needed.

The CI workflow `.github/workflows/r01-kernel-probe.yml` runs three synthetic-data tests, then the real-data query, and posts the result to its job summary and a text artifact.

| Observation | What follows | What does **not** follow |
|---|---|---|
| Exact name in cone | Original named declaration is referenced in the released five-theorem kernel closure | The local algebraic abstraction was itself applied in the proof |
| Exact name absent | This exact named declaration does not occur in that version of the kernel declaration cone | Imports, elaboration, simp lemmas, or equivalent mathematics can be deleted |
| Shortest parent witness | One shortest route from a headline proof term to the named declaration | The only route, a dominator, or the proof's validity |
| A definition (`Factor` / `IsConst`) appears | Its name is used by a proof term | A converse implication or an iteration bridge was established |

**Next scientific step:** trace positives through the original source and locate the actual stage-iteration mechanism rather than speculate from the isolated abstract counterexample. Any findings should be committed separately with exact dataset-output lines.

**Verification status at authoring:** 3/3 synthetic unit tests passed locally. The *real* kernel-membership and path outputs are not asserted until the workflow runs successfully.
