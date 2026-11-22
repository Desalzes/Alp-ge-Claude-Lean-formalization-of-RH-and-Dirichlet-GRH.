# R01 — Kernel-dependency probe for T01/T02 declarations

**Date:** 2026-11-22. **Status:** real v0.2.1 data queried and SHA256-verified; 7/9 exact declaration names present, 2/9 absent. No new RH/GRH theorem is asserted.

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

**Verification:** 3/3 local synthetic tests passed; real asset SHA256 checks, membership checks and shortest-path extraction succeeded in the cited GitHub Actions run.

## Actual kernel-cone results (2026-11-22)

**Execution:** [GitHub Actions run 45042432036](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./actions/runs/45042432036), job `query-kernel-cone`, completed **successfully**. The job downloaded both release v0.2.1 assets, passed both SHA256 checks, ran all 3 unit tests, queried nine exact names, and uploaded [the verbatim result artifact](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./actions/runs/45042432036/artifacts/14762455216).

| Exact source declaration | Kernel declaration closure | Shortest witness edges | Evidence / route |
|---|---|---:|---|
| `Formalism.ThetaLiftIndependence.ChainScalar` | **Absent** | — | No exact match in `cone-decls`; does not rule out related structural machinery |
| `Formalism.ThetaLiftIndependence.ChainScalarLemmas.mem` | **Absent** | — | No exact match; source-name fidelity for this fully qualified name needs checking |
| `GlobalTheory.SqStep.theta_tower_norm_step_small_rank` | **Present** | 11 | `GlobalTheory.SqTower.tower_alt_bis` → `GlobalTheory.T.witt_tower_norm_step_of_small_rank` → step lemma |
| `GlobalTheory.T.witt_tower_norm_step_of_small_rank` | **Present** | 10 | `GlobalTheory.SqTower.tower_alt_bis` → wrapper |
| `GlobalTheory.Square.StepRatio` | **Present** | 10 | `GlobalTheory.RowClaim.twisted_local_factor_ratio_holds` → definition |
| `GlobalTheory.SqStepArith.stepFac_ratio_core` | **Present** | 14 | theta step → `GlobalTheory.T.thetaStepFactor_ratio_unit_gaussSumQuotient` → `stepFac_ratio` → core |
| `GlobalTheory.ConstRatio.Factor` | **Present** | 10 | `GlobalTheory.RowClaim.twisted_local_factor_ratio_holds` → definition |
| `GlobalTheory.ConstRatio.Factor.isConst` | **Present** | 10 | `GlobalTheory.SqTop.triEx_holds_alt` → forward implication |
| `GlobalTheory.BotTransfer.bottom_constant_transfer_along_tower` | **Present** | 16 | `GlobalTheory.BotRatio.bottom_theta_constant_ratio_eq` → `GlobalTheory.T.witt_tower_bottom_constant_transfer` → bottom transfer |

**Shared verified upstream route (one shortest witness, not necessarily unique):** `LFunction_ne_zero_of_half_lt_re` → `allChi` → `UpperTheory.FinalTheorems.everyCharacter` → `everyCharacter_of_row` → `UpperTheory.LiteratureTheorems.every_character_of_literature_of_vWin` → `UpperTheory.Lit.every_character_of_theta_integrals_local_matching` → `UpperTheory.Lit.nonempty_hyps_definite_side_of_closed_bound`, then the theta-specific branches above.

**Research prioritization changed by this result:** T01's chosen original `ChainScalar` abstraction has no exact name in this published kernel cone; it remains a valid independent algebraic result, but further polishing it should rank below source-faithful analysis of the *actually referenced* `tower_alt_bis` / step / bottom transfer branches. This is **not** a claim of a flaw in the released Lean formalization. In particular, the presence of `Factor.isConst` does not supply an `IsConst → Factor` converse, nor prove how the actual tower iterates. The next task should inspect `GlobalTheory.SqTower.tower_alt_bis` for the concrete stage-construction mechanism.
