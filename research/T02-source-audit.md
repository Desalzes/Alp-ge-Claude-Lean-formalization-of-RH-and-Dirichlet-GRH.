# T02 — Nonvanishing propagation through coherent theta-tower stage factors

Date: 2026-11-21. Original source snapshot: `leanprover-community/riemann-hypothesis` commit `8f558a8848a80dac6851a00a95ca477ff403e922`.

## Original assertions and exact source paths

1. `GlobalTheory.SqStep.theta_tower_norm_step_small_rank`:
   `src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/WittTowerNormStepOfSmallRank.lean`.
   Its `GlobalTheory.T.witt_tower_norm_step_of_small_rank` export wrapper is in the same file.
2. `GlobalTheory.BotRatio.bottom_theta_constant_ratio_eq`:
   `src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/BottomConstantRatioEqLocalFactorRatio.lean`.
   Its `GlobalTheory.T.bottom_constant_ratio_eq_local_factor_ratio` export wrapper is in the same file.
3. `GlobalTheory.BotTransfer.bottom_constant_transfer_along_tower`:
   `src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/BottomConstantTransferAlongTower.lean`.
4. The tower-step proof begins by applying `GlobalTheory.T.seesaw_first_reduction_level`, `GlobalTheory.T.thetaStepFactor_ratio_unit_gaussSumQuotient`, and `GlobalTheory.T.partialHeckeLFunction_square_eq_primitive`. These are its **direct term dependencies** in the inspected proof.
5. The bottom-constant-ratio proof explicitly calls `bottom_triple_integral_eq_const_mul_local`, `witt_tower_bottom_constant_transfer`, and `GlobalTheory.ConstRatio.RatIn.of_mul` with the unit-ratio argument.
6. The previous extract `Formalism.ThetaLiftIndependence.ChainScalar` is a related algebraic organization result, not a verified direct dependency of these later declarations. **No exact transitive `Main` proof chain claimed.**

## Original mathematics and important caveats

The tower-step conclusion asserts that from a stage-`q+1` triangle `X`, a factorization `Factor X ... lam`, rank condition `A.rank = A'.rank + 2*e`, fixed `IsHeckeL` data, `ThetaLocalInputs`, `ThetaIntegralsAgree`, `LocalMatching`, `NumbersIn`, the bounded family `GBig`, and other structural hypotheses, one can construct a stage-`q` triangle `Y` with `Y.IsConst ... c` and `y : T → ℂ` such that

`∀ t, y t ≠ 0 ∧ lam t * Lf t ((e + 1 : ℕ) : ℂ) = y t * c t`

plus a `Square.StepRatio` condition linking `y(t)` to `y(μ₀)`. This is **an equality at s = e+1**, not an identity in a free analytic argument `s`. The proof extracts `1 ≤ e` on its path, so that evaluation lies at a positive integer ≥ 2. It cannot by itself yield zero multiplicities near a critical-strip point.

The bottom theorem asserts under **additional conditions** `(∀ D, GlobalTheory.NormSum.Inp D)`, `GlobalTheory.SqTop.BotSmall`, `GlobalTheory.SqTop.LNe`, local theta hypotheses, `GBig`, `IsBottomTri`, and `X.IsConst ... c0` that

`c0 t ≠ 0 ∧ c0 μ₀ ≠ 0 ∧ ∃ γ : D.what₂.LL, D.what₂.embLL γ * c0 μ₀ = c0 t`.

The nonvanishing is *not unconditional* for arbitrary functions or theta kernels. It is specific to its admissible bottom triangles and full hypotheses.

## Precise extracted claim

In `ThetaTowerNonzero.lean`, for any commutative semiring R with no zero divisors, stage scalars `a_j`, special values `L_j`, and normalizations `y_j`, assume:

- Coherent linking identity **for every** j: `a_(j+1) L_j = y_j a_j`.
- `y_j ≠ 0` for all j.
- A nonzero bottom stage `a_0 ≠ 0`.

Then `a_j ≠ 0` and `L_j ≠ 0` for all j, by induction from `a_(j+1)L_j = y_j a_j ≠ 0`.

The generality `NoZeroDivisors` is genuinely needed; a nonzero factor need not prevent a zero product in rings with zero divisors. The source works in ℂ, a field. The result is standard algebra, not an original automorphic theorem.

### Fidelity firewall

**This source theorem does not itself give a single chosen coherent family** `(a_j,L_j,y_j)` with the exact same `a_j` occurring in consecutive identities. It constructs existential data from each admissible stage. Converting repeated existence to such a compatible family (including matching choices, stage invariants, normalizations, and eventual admissible bottom data) is an **additional mathematical task**. No tautological `sorry`-free algebraic lemma can discharge those arithmetic/analytic obligations.

No theorem here establishes new RH/GRH consequences, analyticity, or the equality of complex-zero multiplicities. A pointwise nonzero scalar at one spectral argument is not a nonvanishing analytic germ near every other argument.

## Literature / prior work

- Gan, Qiu, Takeda, *The regularized Siegel–Weil formula (the second term identity) and the Rallis inner product formula*, https://arxiv.org/abs/1207.4709: existing global inner-product and nonvanishing machinery for theta correspondences.
- Wee Teck Gan, *Automorphic forms and the theta correspondence*, lecture notes: https://swc-math.github.io/aws/2022/2022GanNotes.pdf (tower property and Rallis framework).
- Discussion of seesaw and nonvanishing of global theta lifts: https://arxiv.org/abs/0902.0419.

These support the classical context but do not validate the Alpöge–Claude proof; no novelty is claimed for the simple product-induction lemma.

## Next nontrivial obstruction

Extract and test `GlobalTheory.Square.StepRatio`, specifically its valuation, local-unit and normalization input across a changing family of places. Unlike this finite-domain induction, establishing `StepRatio` from data of actual theta lifts is a genuinely arithmetic condition. A mathematically precise application of T02 requires a clean formal bridge from `IsStageC`/ `IsConst` to a coherent scalar sequence.
