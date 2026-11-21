# T02 verification record — 2026-11-21

## Reproducible environment

- Standalone Lean v4.33.1, `lean-toolchain` pinned exactly.
- Pinned Mathlib Git SHA: `0df444a360eaa60ab8c11dca51a86af692955474`, with full `lake-manifest.json`.
- Build target list: `ThetaChain`, `ThetaTowerNonzero`, `ThetaStepRatioCore`, `ThetaFactorGap`.
- Each file is an independent algebraic construction and does not import the RH release's gigantic local modules.

## CI proofs and exact kernel-axiom reports

| Source | Theorem | Source axiom output | Verified successful CI |
|---|---|---|---|
| `ThetaTowerNonzero.lean` | `step_nonzero`, `stage_nonzero`, `special_values_nonzero` | `[propext]` | [44939121369](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./actions/runs/44939121369) |
| `ThetaTowerNonzero.lean` | `special_zero_iff_lower_zero` | No axioms | same |
| `ThetaStepRatioCore.lean` | `multiplier_nonzero`, `step_ratio_nonzero_iff` | `[propext, Classical.choice, Quot.sound]` | [44939572875](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./actions/runs/44939572875) |
| `ThetaFactorGap.lean` | `testVector_same_nonzero_value`, `no_common_injective_factor` | `[propext, Classical.choice, Quot.sound]` | [44939885630](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./actions/runs/44939885630) |

Proof of `ThetaFactorGap.no_common_injective_factor` has no `sorryAx`; build of all four Lean targets completed successfully, 8713 jobs. GitHub Actions tested this on a branch commit that included all four source modules. The workflow subsequently was extended to run `lake env lean ThetaFactorGap.lean` explicitly; earlier green `lake build` already checked the declaration.

GitHub Actions source check scanned for `sorry`, `admit`, and custom `axiom`; source files passed. One failed intermediate attempt at the StepRatio lemma used `map_ne_zero` as a function, but pinned Mathlib's version gives an equivalence. Fix: `(map_ne_zero σ).2 (...) `, then green CI as above. The intermediate failed diagnostic had `sorryAx`; **successful declarations do not**.

## Executable test results

`python3 scripts/test_tower_nonzero.py`:

```text
PASS: 392 satisfying integer tuples checked with no violations
PASS: missing normalization, missing bottom, and Z/6 counterexamples
```

These are falsification searches and demonstrations of hypothesis necessity, not proofs of the general results; Lean supplied those proofs.

## Statement-fidelity status

**PROVED:** conditional algebraic stage nonvanishing, conditional StepRatio multiplier nonvanishing, and no-common-injective-factor counterexample for the two rational rows.

**DISPROVED:** unconditional nonvanishing of `StepRatio` from its definition without positivity, e.g. `Qn=1, qq(v)=0`, and the *abstract* implication that a shared test-vector identity automatically yields a common injective factorization.

**BLOCKED / UNVERIFIED:** a compatible sequence of actual theta triangles satisfying all `Factor` hypotheses at each step. The source `theta_tower_norm_step_small_rank` goes from input `Factor X` to output `IsConst Y`; no direct `Factor Y` follows from that statement alone. Finding a separate proof of the stronger property in the full original 175k-file closure remains a task. The statement of `StepRatio` alone permits zero denominators, but the real `stepFac_ratio_core` provides positive ideal norms and `Qn > 0`; **not an original proof contradiction**.

**NOT CLAIMED:** nonvanishing of general automorphic L-functions, equality of analytic zero multiplicities, proof of RH/GRH, or original proof invalidity.

**INDEPENDENT REVIEW:** Not yet performed; use `research/T02-independent-review.md` and `research/T02-Factor-versus-IsConst.md` for a reviewer unfamiliar with the discovery process.

## Main original source references

- `src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/WittTowerNormStepOfSmallRank.lean`.
- `src/Development/AbelianVarietyTheory/Proofs/TwistedOperators/RatInOfUnit.lean` (definition of `Factor` and proof of one-way `Factor.isConst`).
- `src/Development/AbelianVarietyTheory/BlockTheory/TwistedDiscreteSeries/UnitCharTriangle.lean` (`Tri.IsConst`).
- `src/Development/AbelianVarietyTheory/Definitions/Foundations/TupleConstantsNeZero.lean` (`StepRatio`, `IsAwayUnit`).
- `src/Development/AbelianVarietyTheory/Proofs/DivisorProofs/ThetaStepFactorRatioUnitGaussSumQuotient.lean` (positivity inside original application).

Commit identity of original source inspected: `8f558a8848a80dac6851a00a95ca477ff403e922`.
