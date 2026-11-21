# T02 independent-adversarial-review packet

**Review status: no separate agent/referee has performed this review.**
This document is a reproducible instruction packet, not a simulated second opinion.

## Reviewer inputs (read in this order without prior conclusions)

1. Exact original source at `leanprover-community/riemann-hypothesis` commit `8f558a8848a80dac6851a00a95ca477ff403e922`:
  - `src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/WittTowerNormStepOfSmallRank.lean`
  - `src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/BottomConstantRatioEqLocalFactorRatio.lean`
  - `src/Development/AbelianVarietyTheory/Definitions/Foundations/TupleConstantsNeZero.lean`
  - `src/Development/AbelianVarietyTheory/Proofs/DivisorProofs/ThetaStepFactorRatioUnitGaussSumQuotient.lean`
2. Isolated `ThetaTowerNonzero.lean` and `ThetaStepRatioCore.lean`, plus toolchain / Mathlib manifest. Do not assume any English summary faithfully describes these Lean propositions.
3. Recorded exact counterexamples in `research/T02-counterexamples.md`, then attempt to find smaller or contrary examples.

## Adversarial checks requested

- Determine whether `theta_tower_norm_step_small_rank` has an actual `s`-variable identity or only `Lf t ((e+1 : ℕ) : ℂ)`. Reject any argument transferring vanishing multiplicity from a fixed special value without a separate analytic-germ theorem.
- Check whether `e≥1` follows within the stated source proof, and whether the result uses the value in a regime where nonvanishing is standard from absolutely convergent Euler products.
- Reconstruct exact requirements for `IsStageC`, `Factor`, `Y.IsConst`, `NumbersIn`, `GBig`, `BotSmall`, `LNe`. Does a lower triangle from one existential stage step become an admissible input for the next? Is the scalar `c` exactly the next `lam`? If not, the extracted chain cannot be applied.
- Verify where `StepRatio` obtains nonzero `b`, `g`, and `g'`; identify uses of `Qn > 0` and `Ideal.absNorm` positivity, and check division-by-zero totalization.
- Check orientation: `StepRatio ... (stepFac μ₀) (stepFac t)` in `stepFac_ratio_core` versus `StepRatio ... (y t) (y μ₀)` in `theta_tower_norm_step_small_rank`. Inspect intermediate algebra; do NOT infer a bug from superficial reversal.
- Independently check the `NoZeroDivisors` usage in T02, the nonzero bottom hypothesis, and whether any stronger claims are buried in comments than in the Lean declaration.
- Run `lake build`, `lake env lean ThetaTowerNonzero.lean`, `lake env lean ThetaStepRatioCore.lean`, `#print axioms`, and the executable counterexample harness on the pinned Mathlib.
- Distinguish verification of arithmetic *bookkeeping* from verification of original automorphic, arithmetic and analytic estimates. Require a separate source-closure audit for any claimed RH implication.

## Deliverable format

For each claim, quote an exact source declaration or proof term (path + line), a mathematical translation, a counterexample search result, and a verdict: PROVED / DISPROVED / BLOCKED / CONJECTURAL.

The discovery model must not mark this review “performed” or “passed”; only an actual independently operating agent or mathematical reviewer can supply that evidence.
