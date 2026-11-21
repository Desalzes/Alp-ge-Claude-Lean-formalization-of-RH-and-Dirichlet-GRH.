import Mathlib

/-!
# Algebraic scalar-chain extraction

A semiring/module generalization of the *shape* of
`Formalism.ThetaLiftIndependence.ChainScalar`.
This is NOT a proof of the original theta-lifting estimates, RH, or GRH.
The original proposition uses adjoints in finite-dimensional inner-product spaces.
Here upward and downward maps are arbitrary linear maps, with their composite
assumed to be scalar on an invariant family of submodules.
-/

universe u v

namespace ThetaChain

variable {R : Type u} [CommSemiring R]
variable (E : ℕ → Type v)
variable [∀ n, AddCommMonoid (E n)] [∀ n, Module R (E n)]

/-- Compose upward arrows from level 0 to level m. -/
def upChain (U : ∀ n, E n →ₗ[R] E (n + 1)) :
    (m : ℕ) → E 0 →ₗ[R] E m
  | 0 => LinearMap.id
  | m + 1 => (U m).comp (upChain U m)

/-- Compose downward arrows from level m to level 0. -/
def downChain (D : ∀ n, E (n + 1) →ₗ[R] E n) :
    (m : ℕ) → E m →ₗ[R] E 0
  | 0 => LinearMap.id
  | m + 1 => (downChain D m).comp (D m)

/-- Stability of the selected submodules under all upward arrows
    implies stability under any finite upward chain. -/
theorem upChain_mem (U : ∀ n, E n →ₗ[R] E (n + 1))
    (S : ∀ n, Submodule R (E n))
    (hU : ∀ n (x : E n), x ∈ S n → U n x ∈ S (n + 1)) :
    ∀ m (x : E 0), x ∈ S 0 → upChain E U m x ∈ S m := by
  intro m
  induction m with
  | zero =>
      intro x hx
      simpa [upChain] using hx
  | succ m ih =>
      intro x hx
      change U m (upChain E U m x) ∈ S (m + 1)
      exact hU m _ (ih x hx)

/-- Finite scalar-chain identity without inner products or adjoints.
The original `ChainScalar` is obtained on taking U_j = T_j†, D_j = T_j,
provided the source's local scalar/stability hypotheses hold.
This does NOT assert those analytic hypotheses. -/
theorem scalar_chain
    (U : ∀ n, E n →ₗ[R] E (n + 1))
    (D : ∀ n, E (n + 1) →ₗ[R] E n)
    (S : ∀ n, Submodule R (E n)) (c : ℕ → R)
    (hDU : ∀ n (x : E n), x ∈ S n → D n (U n x) = c n • x)
    (hU : ∀ n (x : E n), x ∈ S n → U n x ∈ S (n + 1)) :
    ∀ m (x : E 0), x ∈ S 0 →
      downChain E D m (upChain E U m x) =
        (∏ j ∈ Finset.range m, c j) • x := by
  intro m
  induction m with
  | zero =>
      intro x hx
      simp [upChain, downChain]
  | succ m ih =>
      intro x hx
      have hmem : upChain E U m x ∈ S m :=
        upChain_mem E U S hU m x hx
      calc
        downChain E D (m + 1) (upChain E U (m + 1) x) =
            downChain E D m (D m (U m (upChain E U m x))) := by rfl
        _ = downChain E D m (c m • upChain E U m x) := by
              rw [hDU m _ hmem]
        _ = c m • downChain E D m (upChain E U m x) := by
              rw [map_smul]
        _ = c m • ((∏ j ∈ Finset.range m, c j) • x) := by
              rw [ih x hx]
        _ = (∏ j ∈ Finset.range (m + 1), c j) • x := by
              rw [Finset.prod_range_succ, smul_smul, mul_comm]

#print axioms ThetaChain.upChain_mem
#print axioms ThetaChain.scalar_chain

end ThetaChain
