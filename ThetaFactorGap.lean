import Mathlib

/-!
# T02c — A common-factorization obstruction visible from two test rows

The source's `GlobalTheory.ConstRatio.Factor` requires a shared surjective
linear map p and parameter-dependent *injective* linear maps J_t, whereas
`Tri.IsConst` only tests a particular pair of vectors.

This small rational-vector-space example proves that a shared test-vector
relation does not imply a shared injective factorization. It is a counterexample
to an ABSTRACT LINEAR-ALGEBRA STRENGTHENING, not to any original automorphic
theorem: geometric theta-integral hypotheses may rule out this example.
-/

namespace ThetaFactorGap

universe u

variable {W : Type u} [AddCommGroup W] [Module ℚ W]

/-- A single vector gives the same nonzero value under both distinct rows
x and x+y; taking a one-dimensional comparison row gives an abstract
IsConst-shaped scalar equality at both parameters. -/
def testVector : Fin 2 → ℚ := fun i => if i = 0 then 1 else 0

theorem testVector_same_nonzero_value :
    testVector 0 = 1 ∧ testVector 0 + testVector 1 = 1 := by
  constructor <;> simp [testVector]

/-- Even without assuming p surjective or J₁ injective, the rows x and
x+y cannot share a factor p through an injective J₀ and nonzero λ₀.

The proof uses v=(0,1): row x kills v, so injectivity of J₀ and
nonvanishing λ₀ force p(v)=0; row x+y does not kill v. -/
theorem no_common_injective_factor
    (p : (Fin 2 → ℚ) →ₗ[ℚ] W)
    (J₀ J₁ : W →ₗ[ℚ] ℚ)
    (hJ₀ : Function.Injective J₀)
    (lam₀ lam₁ : ℚ)
    (hlam₀ : lam₀ ≠ 0)
    (h0 : ∀ v : Fin 2 → ℚ, v 0 = lam₀ * J₀ (p v))
    (h1 : ∀ v : Fin 2 → ℚ, v 0 + v 1 = lam₁ * J₁ (p v)) :
    False := by
  let v : Fin 2 → ℚ := fun i => if i = 0 then 0 else 1
  have hv0 : v 0 = 0 := by simp [v]
  have hv1 : v 1 = 1 := by simp [v]
  have hzero : lam₀ * J₀ (p v) = 0 := by
    calc
      lam₀ * J₀ (p v) = v 0 := (h0 v).symm
      _ = 0 := hv0
  have hjzero : J₀ (p v) = 0 :=
    (mul_eq_zero.mp hzero).resolve_left hlam₀
  have hpv : p v = 0 := by
    apply hJ₀
    simpa using hjzero
  have h1v := h1 v
  rw [hpv, map_zero] at h1v
  norm_num [hv0, hv1] at h1v

#print axioms ThetaFactorGap.testVector_same_nonzero_value
#print axioms ThetaFactorGap.no_common_injective_factor

end ThetaFactorGap
