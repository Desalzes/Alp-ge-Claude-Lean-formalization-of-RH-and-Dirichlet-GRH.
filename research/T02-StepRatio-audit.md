# StepRatio sub-audit — total division and positivity prerequisites

Date: 2026-11-21. Source lock: `leanprover-community/riemann-hypothesis`, commit `8f558a8848a80dac6851a00a95ca477ff403e922`.

**Exact definition path:** `src/Development/AbelianVarietyTheory/Definitions/Foundations/TupleConstantsNeZero.lean`, namespace `GlobalTheory.Square`.

```lean
def StepRatio {T : Type} (σ₀ : K →+* ℂ) (Qn : ℕ) (S0 : Finset T) (cc qq : T → ℕ) (u1 u0 : ℂ) : Prop :=
  ∃ (b : K) (g g' : T → 𝓞 K), IsAwayUnit Qn b ∧
    (∀ v ∈ S0, g v ∣ (qq v : 𝓞 K) ^ cc v ∧ g' v ∣ (qq v : 𝓞 K) ^ cc v) ∧
    u1 = σ₀ (b * ∏ v ∈ S0, (g v : K) / (g' v : K)) * u0
```

and

```lean
def IsAwayUnit (m : ℕ) (x : K) : Prop :=
  ∃ (a : 𝓞 K) (k k' : ℕ), a ∣ (m : 𝓞 K) ^ k' ∧ x * (m : K) ^ k = (a : K)
```

## The elementary denominator issue

Lean's field division is totalized: `x / 0 = 0`. Thus a logical predicate involving a fraction is **not** automatically a proof that its denominator is invertible.

The definition `StepRatio` *alone* does not require `Qn > 0` or `qq v > 0`, and therefore does not guarantee `b ≠ 0`, `g v ≠ 0` or `g' v ≠ 0`. For instance:

- Work in K=ℚ, with its standard embedding into ℂ, let S0 consist of one index, Qn=1, qq(v)=0, cc(v)=1, b=1, g(v)=1, g'(v)=0, u0=1, u1=0.
- `IsAwayUnit 1 1` holds; `1 | 0^1` and `0 | 0^1` both hold.
- `g(v)/g'(v) = 1/0 = 0` in the totalized field, so the final equation defining `StepRatio` is `0 = σ₀(0)*1`, true.
- Hence **`StepRatio ... u1 u0` does not in general imply `u0 ≠ 0 → u1 ≠ 0`**.

This is a counterexample to that *invalid inferred strengthening*, not to the original published theorem, which does not assert it unconditionally.

## Sufficient arithmetic conditions

Suppose `Qn > 0` in ℕ and `∀ v ∈ S0, qq v > 0`. In characteristic zero, these imply:
1. `b ≠ 0` from `IsAwayUnit Qn b`: if `b=0`, the chosen algebraic integer `a` is zero, which cannot divide the nonzero `Qn^k'`.
2. `g(v) ≠ 0` and `g'(v) ≠ 0`: each divides the nonzero integral power `qq(v)^cc(v)`.
3. All fractions `g(v)/g'(v)` are nonzero in K and so is their finite product; the field embedding is injective, giving a nonzero normalization scalar.
4. Therefore `u1 ≠ 0 ↔ u0 ≠ 0` for that fixed admissible data.

This is a *conditional consequence* and is not formalized yet from the entire original number-field definition.

## Where the hypotheses come from in the source

`src/Development/AbelianVarietyTheory/Proofs/DivisorProofs/ThetaStepFactorRatioUnitGaussSumQuotient.lean` contains `GlobalTheory.SqStepArith.stepFac_ratio_core`. It explicitly establishes

```lean
have hQn : 0 < Qn G t := Finset.prod_pos fun w _ =>
  Nat.pos_of_ne_zero fun h => w.ne_bot (Ideal.absNorm_eq_zero_iff.1 h)
```

before applying `GlobalTheory.Square.isAwayUnit_closure`.

It also uses `fun v => Ideal.absNorm v.asIdeal` for the `qq` argument in the exported `StepRatio` declaration. Height-one prime ideals are nonzero, so their absolute norms are positive by the displayed fact. **This source appears to supply the very positivity needed**; the observation above does not identify a bug in the actual application.

## Remaining research questions

1. Verify the precise orientation of the input pair `(u1,u0)` in the `stepFac_ratio_core` statement versus the `theta_tower_norm_step_small_rank` statement; one reads `stepFac(μ₀), stepFac(t)`, the other `y(t), y(μ₀)`. This might be intentional, and no incompatibility is claimed without tracing how the factor is formed.
2. Prove a small isolated `StepRatioCore` nonvanishing lemma under explicit nonzero b/g/g' assumptions, then separately map the original positive norms and the `IsAwayUnit` predicate to those hypotheses.
3. Test any proposed generalization with `Qn=0` and `qq(v)=0` first; a field division term has no implicit denominator precondition.
4. The original relation evaluates Hecke L at `e+1`, not a neighborhood of a critical-strip spectral variable; no zero multiplicity can be inferred just from this equation.

**Status:** exact source predicate inspected; counterexample to missing-positivity strengthening given; actual source positivity route identified; full Lean transport from original number-field objects not yet proved.
