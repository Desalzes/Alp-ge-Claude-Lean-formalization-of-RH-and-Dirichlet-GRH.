import Mathlib

/-!
# T02b — Safe nonvanishing transfer in a StepRatio-shaped product

The original `GlobalTheory.Square.StepRatio` has a term
  σ₀ (b * ∏ v ∈ S0, (g v : K) / (g' v : K)) * u0.
Its arithmetic hypotheses must guarantee that b and every numerator and
denominator are nonzero before a nonvanishing conclusion follows.
This standalone lemma proves only that *conditional algebraic core*.

The required hypotheses are NOT inferred from the full source predicate here;
see research/T02-StepRatio-audit.md for the original positive-norm route.
-/

namespace ThetaStepRatioCore

universe u v

variable {K : Type u} [Field K]
variable {T : Type v}

/-- The embedded ratio multiplier is nonzero when every numerator and
denominator, as well as the common scalar, is nonzero. -/
theorem multiplier_nonzero
    (σ : K →+* ℂ) (S : Finset T)
    (b : K) (g g' : T → K)
    (hb : b ≠ 0)
    (hg : ∀ t ∈ S, g t ≠ 0)
    (hg' : ∀ t ∈ S, g' t ≠ 0) :
    σ (b * ∏ t ∈ S, g t / g' t) ≠ 0 := by
  have hprod : (∏ t ∈ S, g t / g' t) ≠ 0 := by
    exact Finset.prod_ne_zero_iff.mpr
      (fun t ht => div_ne_zero (hg t ht) (hg' t ht))
  exact (map_ne_zero σ).2 (mul_ne_zero hb hprod)

/-- An explicit nonzero StepRatio multiplier preserves nonvanishing in
both directions. No claim about critical-strip zeros is made. -/
theorem step_ratio_nonzero_iff
    (σ : K →+* ℂ) (S : Finset T)
    (b : K) (g g' : T → K) (u1 u0 : ℂ)
    (h : u1 = σ (b * ∏ t ∈ S, g t / g' t) * u0)
    (hb : b ≠ 0)
    (hg : ∀ t ∈ S, g t ≠ 0)
    (hg' : ∀ t ∈ S, g' t ≠ 0) :
    u1 ≠ 0 ↔ u0 ≠ 0 := by
  have hm := multiplier_nonzero σ S b g g' hb hg hg'
  constructor
  · intro h1 h0
    apply h1
    simp [h, h0]
  · intro h0
    rw [h]
    exact mul_ne_zero hm h0

/-- Lean's field division is totalized; a zero denominator makes the
quotient zero. This sanity check explains the need for `hg'`. -/
example : (1 : ℚ) / 0 = 0 := by simp

#print axioms ThetaStepRatioCore.multiplier_nonzero
#print axioms ThetaStepRatioCore.step_ratio_nonzero_iff

end ThetaStepRatioCore
