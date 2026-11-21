# T02c — `Tri.IsConst` is not a substitute for `Factor`

Date: 2026-11-21. Source snapshot: `leanprover-community/riemann-hypothesis` commit `8f558a8848a80dac6851a00a95ca477ff403e922`.

## Exact definitions inspected

### `GlobalTheory.ConstRatio.Factor`

File: `src/Development/AbelianVarietyTheory/Proofs/TwistedOperators/RatInOfUnit.lean`

The source defines `Factor X ψ θ lam` as `(∀ t, lam t ≠ 0)` together with witnesses:
- a common complex module `Pi`,
- a **surjective** linear map `p : PolF(... A.rank) →ₗ[ℂ] Pi`,
- a second linear map `p' : PolF(... A'.rank) →ₗ[ℂ] Pi`,
- for **every** t, an **injective** linear map `J t : Pi →ₗ[ℂ] (GA D WW → ℂ)`,
- integrability for every polynomial input on the first side, and prescribed second-side integrability,
- a full-vector identity `∀ t P, X.I ψ θ t P = lam t • J t (p P)` (with a corresponding relation for `X.I'`),
- existence of a nonzero second-side test vector.

The same file proves `Factor.isConst : Factor X ψ θ lam → X.IsConst ψ θ lam` when T is nonempty, and `Factor.eq_mul` relating any `IsConst` scalar to a `Factor` scalar by a global nonzero multiple.

### `Tri.IsConst`

File: `src/Development/AbelianVarietyTheory/BlockTheory/TwistedDiscreteSeries/UnitCharTriangle.lean`

The source defines `X.IsConst ψ θ c` as

```lean
(∃ t, c t ≠ 0) ∧
∃ (P : PolF D WW.rank A.rank) (P' : PolF D WW.rank A'.rank), ∀ t,
  (∀ h, IntegrableOn (X.ker ψ θ t P h) X.fd X.m ∧
        IntegrableOn (X.ker' ψ θ t P' h) X.fd' X.m') ∧
  (∃ h, X.I' ψ θ t P' h ≠ 0) ∧
  ∀ h, X.I ψ θ t P h = c t * X.I' ψ θ t P' h
```

This statement compares a **selected pair of test polynomials** and does **not** require a common quotient / common kernel for the entire polynomial space. It also requires `c t ≠ 0` only for at least one t, not for every t.

## Why this matters for iterating the original stage lemma

In `src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/WittTowerNormStepOfSmallRank.lean`, the input is `Factor X W.ψ W.θ lam`, while the output for a lower-stage `Y` is only `Y.IsConst W.ψ W.θ c`.

By itself this output does not supply the stronger `Factor Y W.ψ W.θ c` hypothesis needed to reapply the *same* theorem. A separate factorization construction or an iteration argument using weaker hypotheses must supply it. **We have not shown that the original proof lacks such a result elsewhere.** The issue is a dependency/statement-fidelity checkpoint, NOT a contradiction of the published theorem.

## Concrete abstract counterexample (formalized in `ThetaFactorGap.lean`)

Take `V = ℚ²`, `W = ℚ`, with two parameter values and linear rows

`I₀(x,y) = x`, `I₁(x,y) = x+y`.

Take comparison rows `I'₀(z)=z=I'₁(z)`, common test vectors `P=(1,0)`, `P'=1`, and scalars `c₀=c₁=1`. Both row pairs have the **same nonzero test-vector identity**:

`I₀(P) = 1 = c₀ I'₀(P')` and `I₁(P) = 1 = c₁ I'₁(P')`.

But the kernels differ: `(0,1)` lies in `ker I₀`, not `ker I₁`. If a fixed `p:V→Π` and injective `J₀,J₁:Π→W` with nonzero `λ₀,λ₁` factored each row as `I_t = λ_t J_t p`, both kernels would equal `ker p`, a contradiction. The formal proof assumes even LESS than the original `Factor` (it does not require p surjective or J₁ injective), so it is a strong obstruction **in the abstract model**.

No actual automorphic `Tri` is instantiated: specialized geometry could force common kernels. This counterexample does **not** disprove `IsConst → Factor` under every source-specific hypothesis; it disproves the inference from a lone test-vector scalar identity in general linear algebra.

## Precise sufficient conditions worth investigating

For a family of linear maps `I_t : V→W_t` over a field, if the kernels `ker I_t` agree for all t, one may take the common quotient `Π=V/ker I_t`, a surjective quotient map `p`, and induced injective `J_t`. That supplies the **first-side** structural portion of `Factor`, modulo nonzero scalar normalization.

To recover the *full* original `Factor`, additional conditions must verify:
- the compatible second-side map `p'` and its identities for every t,
- integrability for **all** polynomials, not just test vectors,
- nonzero normalizations at every t,
- admissibility of the new stage for the next `IsStageC` call.

These are concrete independent proof obligations. None follows just from the algebraic T02 tower identity.

## Status

- Definition-level distinction: **VERIFIED from source**.
- Abstract matrix counterexample: **MATHEMATICALLY CONSTRUCTED**; Lean compilation status recorded in `research/T02-verification.md` once available.
- Claim of a gap in the *entire* original proof: **NOT ESTABLISHED**. A separate bridge may exist outside the inspected files.
