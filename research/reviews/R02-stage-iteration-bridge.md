# R02 — Stage iteration does not require an `IsConst → Factor` converse

**2026-11-22. Source-level bridge LOCATED; no independent full formalization audit or new Lean theorem claimed.**

## Concrete finding

The T02 abstract counterexample is mathematically valid, but it does **not** by itself obstruct the theta-stage iteration used by the released source. That iteration calls a *separate factorization theorem* at every intermediate stage. It does not attempt to infer `Factor Y` from the weaker `Y.IsConst` returned by a small-rank step.

This resolves the **specific missing-converse concern**, without claiming anything about the correctness of the broader RH/GRH proof or the independent verification of its analytic inputs.

## Exact source mechanism

The inspected Lean files are from the public source mirror [CocoSgt/riemann-hypothesis-lean at `7cbf7a0`](https://github.com/CocoSgt/riemann-hypothesis-lean/tree/7cbf7a0c32fca1badf05931879a37c3f8a2b03b4). Two central source files were cross-compared against [jsmorph/rh at `ecd09ff`](https://github.com/jsmorph/rh/tree/ecd09ff9b4aaf6c08f2b5ef17dc49ca9648a77de/lean/src) and have **identical Git blob SHAs**. The previous T02 notes pinned a different source-mirror revision (`8f558a8848a80dac6851a00a95ca477ff403e922`); exact revision identity with that earlier citation has *not* been independently verified.

| Source declaration | File and role |
|---|---|
| `GlobalTheory.SqTower.FacIn` | [`Proofs/DivisorProofs/TowerOfThetaMatching.lean`](https://github.com/CocoSgt/riemann-hypothesis-lean/blob/7cbf7a0c32fca1badf05931879a37c3f8a2b03b4/src/Development/AbelianVarietyTheory/Proofs/DivisorProofs/TowerOfThetaMatching.lean): for **every** admissible stage `IsStageC W i j p q X`, supplies a `lam` with `Factor X W.ψ W.θ lam` |
| `GlobalTheory.SqTower.descent` | Same file (Git blob `bf5bba640305487f0d880e52b5fcc550938bb75e`): nested induction on `q` and `p`; gets a fresh `Factor` by `hF` before every small/large step and recurses on the lower stage's `IsStageC` and `IsConst` |
| `GlobalTheory.SqTower.tower_alt_bis` | [`LocalTypeDictionary/TowerOfThetaMatching.lean`](https://github.com/CocoSgt/riemann-hypothesis-lean/blob/7cbf7a0c32fca1badf05931879a37c3f8a2b03b4/src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/TowerOfThetaMatching.lean) (Git blob `b2f1d04b66255f5024c8336e13dd5b8de86eecdf`): bundles `exists_factor_of_isStageC`, `witt_tower_norm_step_of_small_rank`, large-rank step, top and bottom inputs; calls `descent` |
| `GlobalTheory.T.exists_factor_of_isStageC` | [`LocalTypeDictionary/ThetaTowerStageNormFactorization.lean`](https://github.com/CocoSgt/riemann-hypothesis-lean/blob/7cbf7a0c32fca1badf05931879a37c3f8a2b03b4/src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/ThetaTowerStageNormFactorization.lean): wrapper of `GlobalTheory.StageFactor.theta_tower_stage_norm_factorization`, furnishing the general `FacIn` input |
| `GlobalTheory.StageFactor.factor_of_parts` | [`Proofs/DivisorProofs/ExistsFactorOfStageTriangle.lean`](https://github.com/CocoSgt/riemann-hypothesis-lean/blob/7cbf7a0c32fca1badf05931879a37c3f8a2b03b4/src/Development/AbelianVarietyTheory/Proofs/DivisorProofs/ExistsFactorOfStageTriangle.lean): explicitly constructs the common-kernel quotient `K = ker(linI t₀)`, the surjective quotient `K.mkQ`, induced injective maps `K.liftQ`, and the second-side linear map from `s` |

### Inductive handoff, without the invalid converse

For the **small-rank successor** case `q+1` in `SqTower.descent`:

1. Input: the current triangle `X` satisfies `IsStageC ... p (q+1) X` and `X.IsConst ... c`.
2. Independently apply `hF` (`FacIn`) to *that stage* to obtain `Factor X ... lam`. Use `Factor.eq_mul` to align the stage scalar `c` with `lam` by a nonzero global multiplier.
3. Apply `hs` (`SmallIn`) to the newly obtained `Factor`; it produces `Y` at stage `p,q` with both `IsStageC ... p q Y` **and** `Y.IsConst ... cY'`.
4. Call induction hypothesis `ih` on `Y` with its stage and `IsConst` hypotheses. On entering that recursive call, **the same general `hF` is reapplied to the new current stage**. No `Y.IsConst → Factor Y` inference is needed.

The **large-rank** successor `p+1` at `q=0` has the same pattern, using `hb` (`BigIn`). The base case `p=q=0` carries the bottom-stage `IsConst` unchanged.

### Where the actual common-kernel proof is

`StageFactor.factor_of_parts` requires hypotheses much stronger than one selected test-vector identity:

- integrability of the first-side kernels for all parameters and polynomials;
- equality of **all** first-side kernels, encoded by `hker : ∀ t t' P, X.I ... t P = 0 → X.I ... t' P = 0`;
- a nonzero scalar family `lam`;
- a specified second-side linear transfer `s` and identity for every second-side input with integrability;
- a common nonvanishing second-side test polynomial.

In the nonempty-parameter case it fixes `t₀`, sets `K` to `ker(linI t₀)`, proves all stage kernels equal `K`, and uses the quotient `PolF / K` for the common `Factor`. Thus the **sufficient common-kernel construction contemplated as a future mathematical micro-target in T02 already exists in the original source**, with its additional second-side hypotheses made explicit. The empty-index-type case is handled separately in the source.

The wrapper `StageFactor.theta_tower_stage_norm_factorization` obtains `factor_of_parts` assumptions from `theta_integral_stage_convergent`, `theta_stage_kernel_characterization`, `theta_stage_liftable`, and `theta_small_rank_stage_holds`. These analytical/automorphic ingredients, rather than the elementary algebraic implication, are the substantive next audit targets.

## Connection to the kernel-cone evidence

[The R01 real-data run](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./actions/runs/45042432036) established the **actual** kernel path from the published theorem to `SqTower.tower_alt_bis`, then to the small-rank step. A further CI query has been added for `SqTower.descent`, `FacIn`, `T.exists_factor_of_isStageC`, `StageFactor.theta_tower_stage_norm_factorization`, and `StageFactor.factor_of_parts`. The result of that follow-up query must be collected from its successful workflow before making a claim about each exact declaration's kernel-cone membership.

## Revised classification and next task

- **LOCATED (source-level):** the concrete iteration bridge via `FacIn` and `descent`; the abstract `IsConst → Factor` converse is *not* required along this source route.
- **LOCATED (source-level):** the common-kernel quotient constructor `StageFactor.factor_of_parts`, including the necessary full-vector and second-side inputs.
- **STILL OPEN:** independent source-to-kernel revision comparison; proving or reviewing the `theta_stage_kernel_characterization` premises; broader mathematical validity of the entire announced RH/GRH proof.
- **Research priority:** investigate exactly how `theta_stage_kernel_characterization` establishes the all-parameter kernel equality `hker` and whether that theorem is in the published kernel cone. Do not build a duplicate common-kernel algebra lemma.

**No new Lean compilation was performed for R02.** This file reports exact source statements and a reproducible reading of the existing proof's control flow; see the R01 CI run for the separate kernel-dependency experiment.
