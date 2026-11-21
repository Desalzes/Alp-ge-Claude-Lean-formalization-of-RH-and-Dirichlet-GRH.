import Mathlib

/-!
# T02 — Nonvanishing propagation through compatible theta-tower factorizations

An isolated algebraic result motivated by
`GlobalTheory.SqStep.theta_tower_norm_step_small_rank`, whose original
special-value identity reads
  lam t * Lf t ((e + 1 : ℕ) : ℂ) = y t * c t, with y t ≠ 0.

This file does NOT assert the existence of a coherent tower of such identities.
It does NOT prove nonvanishing of automorphic L-functions in a critical strip.
All hypotheses needed to connect consecutive stages are made explicit.
-/

namespace ThetaTowerNonzero

universe u

variable {R : Type u} [CommSemiring R] [NoZeroDivisors R]

/-- A nonzero lower constant and nonzero normalization factor force both
the upper constant and the special L-value to be nonzero, if their
factorization identity holds. There is no requirement that the upper
constant be nonzero in advance. -/
theorem step_nonzero {upper lower special normalization : R}
    (h : upper * special = normalization * lower)
    (hnorm : normalization ≠ 0)
    (hlower : lower ≠ 0) :
    upper ≠ 0 ∧ special ≠ 0 := by
  have hp : upper * special ≠ 0 := by
    rw [h]
    exact mul_ne_zero hnorm hlower
  constructor
  · intro hz
    apply hp
    simp [hz]
  · intro hz
    apply hp
    simp [hz]

/-- An explicitly coherent finite or infinite sequence of stage equations
propagates nonvanishing from stage zero to every stage. -/
theorem stage_nonzero
    (stage special normalization : ℕ → R)
    (hstep : ∀ j, stage (j + 1) * special j = normalization j * stage j)
    (hnorm : ∀ j, normalization j ≠ 0)
    (hbottom : stage 0 ≠ 0) :
    ∀ j, stage j ≠ 0 := by
  intro j
  induction j with
  | zero => exact hbottom
  | succ j ih =>
      exact (step_nonzero (hstep j) (hnorm j) ih).1

/-- Under exactly the same hypotheses, each distinguished *special value*
in the coherent chain is nonzero. This is not a theorem about all complex
arguments of any L-function. -/
theorem special_values_nonzero
    (stage special normalization : ℕ → R)
    (hstep : ∀ j, stage (j + 1) * special j = normalization j * stage j)
    (hnorm : ∀ j, normalization j ≠ 0)
    (hbottom : stage 0 ≠ 0) :
    ∀ j, special j ≠ 0 := by
  intro j
  exact (step_nonzero (hstep j) (hnorm j)
    (stage_nonzero stage special normalization hstep hnorm hbottom j)).2

/-- With both multipliers known nonzero, the original one-step
factorization preserves the *zero set* of special values versus lower
constants, without making a statement about analytic multiplicity. -/
theorem special_zero_iff_lower_zero {upper lower special normalization : R}
    (h : upper * special = normalization * lower)
    (hupper : upper ≠ 0)
    (hnorm : normalization ≠ 0) :
    special = 0 ↔ lower = 0 := by
  constructor
  · intro hs
    have hzero : normalization * lower = 0 := by
      rw [← h, hs, mul_zero]
    exact (mul_eq_zero.mp hzero).resolve_left hnorm
  · intro hl
    have hzero : upper * special = 0 := by
      rw [h, hl, mul_zero]
    exact (mul_eq_zero.mp hzero).resolve_left hupper

#print axioms ThetaTowerNonzero.step_nonzero
#print axioms ThetaTowerNonzero.stage_nonzero
#print axioms ThetaTowerNonzero.special_values_nonzero
#print axioms ThetaTowerNonzero.special_zero_iff_lower_zero

end ThetaTowerNonzero
