# Extraction T01 — scalar identities along finite lifting chains

Date: 2026-11-21. Status: **extracted algebraic lemma proved in pinned Lean CI; independent mathematical review pending**, exact-arithmetic falsification tests completed. This document does not claim a new RH or GRH proof.

## Source lock and declarations

- Announcement: https://alpo.ge/remark.pdf (2026-11-20), page 1 and page 4; **chain length ~ sqrt(X)**, not X. The 11/15 timeline attributes multiplicity m to iterated lifts U(X0) -> ... -> U(Xm).
- Community mirror: https://github.com/leanprover-community/riemann-hypothesis at inspected commit `8f558a8848a80dac6851a00a95ca477ff403e922`.
- Exact definition of `Formalism.ThetaLiftIndependence.ChainScalar : Prop`: `src/Formalism/ThetaLiftIndependence/Statement.lean`, blob `0cbe89264b4f4920f2c0d4beab1af5bc3a915547`.
- Its recursive `downChain` map is in the same file.
- Auxiliary *proved* theorem `Formalism.ThetaLiftIndependence.ChainScalarLemmas.mem`: `src/Formalism/ThetaLiftIndependence/ThetaOrbitSums/ChainScalar.lean`.
- Related proposition `Formalism.ThetaLiftIndependence.RallisHyp` (inner product identity) and `RallisAdj` (scalar adjoint identity) are definitions in `Statement.lean`.
- Related graph-catalogued downstream scalar lower bound: `GlobalTheory.LowRow.scalar_of_form_key_lowC`, `src/Development/AbelianVarietyTheory/Proofs/DivisorProofs/AdelCOfInnerProductFormula.lean:214`, https://andrewodesky.com/rh/# (catalogue heading “Lower bound for the theta scalar”). The catalogue links it to the final zero-freeness theorem and states that it assumes extensive arithmetic/analytic data.
- The catalogue's graph is explicitly incomplete: https://andrewodesky.com/rh/graph.html. The **exact transitive link from `ChainScalar` to `Main.lean` has not been established**. Do not present it as a proven critical dependency without tracing the proof term.

## Exact original proposition in mathematical form

For a real- or complex-inner-product scalar field k, finite-dimensional inner-product spaces E_j, linear maps T_j : E_(j+1) -> E_j, subspaces S_j <= E_j and scalars c_j in k, assume for all j and all x in S_j:

1. T_j (T_j^* x) = c_j x.
2. T_j^* x lies in S_(j+1).

Write D_m = T_0 ∘ T_1 ∘ ... ∘ T_(m-1), D_0 = id. The source's `ChainScalar` proposition asserts for all m and x in S_0:

D_m(D_m^* x) = (product_{j=0}^{m-1} c_j) x.

**No positivity or nonvanishing requirement on c_j** appears in this exact proposition. It also needs no notion of theta integrals to *state* it; the arithmetic challenge is to furnish its hypotheses.

`ChainScalarLemmas.mem` proves the intermediate stability fact: under (2), D_m^* sends S_0 into S_m. Its proof uses induction, `LinearMap.adjoint_comp`, and `LinearMap.adjoint_id`. Mathlib supplies adjoints and linear algebra. `ChainScalar` itself is a `def : Prop` in the inspected file, not a theorem declaration; locating and checking a proof of the entire proposition is separate work.

## Extracted, generalized claim

The committed file `ThetaChain.lean` uses a commutative semiring R, arbitrary R-modules E_j, upward linear maps U_j : E_j -> E_(j+1), downward maps D_j : E_(j+1) -> E_j, submodules S_j, and c_j : R.

Assumptions for each j and x in S_j:
- D_j(U_j x) = c_j • x.
- U_j x belongs to S_(j+1).

Conclusion for x in S_0:
- (D_0 ∘ ... ∘ D_(m-1)) ((U_(m-1) ∘ ... ∘ U_0) x) = (product c_j) • x.

This is more general **only in the algebraic category**: no inner product, adjoint, dimension bound, field, or topology is needed. It is not a stronger claim about theta lifts or L-functions. Specializing U_j = T_j^* and D_j = T_j recovers the original algebraic identity, because adjoint reverses compositions.

The proof is induction using `upChain_mem`, R-linearity and the finite product recursion. It does not derive the local scalar identity or stability from automorphic theory.

## Counterexample hunt / hypotheses

- Dropping the intermediate stability condition invalidates the conclusion: explicit matrices and a computed mismatch are in `research/counterexamples.md`. This is a **disproof of the weakened statement**, not the exact source statement.
- `c_j != 0` is not sufficient for injectivity over a ring with zero divisors: multiplying by 2 on Z/6Z has nonzero scalar 2 but kills 3. A field or appropriate faithful torsion-free hypothesis is necessary for that *additional* conclusion.
- Zero scalars are permitted by `ChainScalar` and simply give a zero composite on S_0. They are not a contradiction.
- The m=0 identity is the empty product 1 times the identity. The source quantifies over arbitrary natural m.
- Neither independent analytic estimates nor the identification of the real theta operators has been tested here.

## Verification contract

Pin to Lean 4 v4.33.1 and Mathlib `0df444a360eaa60ab8c11dca51a86af692955474` (the published source's pin). Run `lake build ThetaChain`, check `#print axioms ThetaChain.scalar_chain`, and scan `ThetaChain.lean` for placeholders and extra axiom declarations. A completed proof may use only Lean's ordinary foundations (in source audit: `propext`, `Classical.choice`, `Quot.sound`). Compilation passed for this extracted lemma in CI run 44933966518; see `research/verification-results.md`. This is not a proof of any automorphic/analytic input or of RH.

## Original proof audit (not our verification)

MIT verification page https://math.mit.edu/~drew/grh/ was last updated 2026-11-21 12:55 UTC: reports all 175,187 files compiled, five headline statements matching the challenge, only core axioms, independent nanoda and latest con-leche accepting; other checks still underway at that timestamp. Community verification notes https://github.com/leanprover-community/riemann-hypothesis/blob/main/verification/NOTES.md distinguish older bundled con-leche/con-ron failures on a reflexive mutual inductive from current con-leche. They are **version-specific**, not evidence of a contradiction in the theorem.

The five statements are in `src/Main.lean` and `src/Statements.lean` (Mathlib's RH plus Dirichlet RH for all characters, including imprimitive); this is not ERH for arbitrary number fields.

## Status / limitations

- Source definitions inspected: YES.
- Graph and announcement inspected: YES, graph incomplete.
- Claimed novelty of scalar-chain algebra: NO; standard linear algebra.
- Falsification of a weakened claim: YES.
- Exact symbolic check of two-stage counterexample: YES (integer matrices).
- Independent Lean project committed and compiled: YES — CI run [44933966518](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./actions/runs/44933966518); `ThetaChain.scalar_chain` kernel-accepted with standard foundational axioms only.
- Source-line proof term tracing from original `ChainScalar` to headline RH: NOT DONE.
- Independent agent review: NOT YET CONDUCTED; reviewer packet exists and must be given to a separate agent.

## Verbatim Lean declaration under investigation

From `src/Formalism/ThetaLiftIndependence/Statement.lean`, commit `8f558a8848a80dac6851a00a95ca477ff403e922`:

```lean
def ChainScalar : Prop :=
  ∀ (𝕜 : Type) [RCLike 𝕜] (E : ℕ → Type) [∀ j, NormedAddCommGroup (E j)]
    [∀ j, InnerProductSpace 𝕜 (E j)] [∀ j, FiniteDimensional 𝕜 (E j)]
    (T : ∀ j, E (j + 1) →ₗ[𝕜] E j) (S : ∀ j, Submodule 𝕜 (E j)) (c : ℕ → 𝕜),
    (∀ j, ∀ x ∈ S j, T j (LinearMap.adjoint (T j) x) = c j • x) →
    (∀ j, ∀ x ∈ S j, LinearMap.adjoint (T j) x ∈ S (j + 1)) →
    ∀ (m : ℕ), ∀ x ∈ S 0,
      downChain T m (LinearMap.adjoint (downChain T m) x) = (∏ j ∈ Finset.range m, c j) • x
```

All quantifiers and hypotheses above are part of the original declaration: `RCLike` for the scalar field, normed groups/inner products/finite dimensionality for every level, `Submodule` invariants, a local scalar equation and its separate stability hypothesis. The source uses a definition `: Prop`, so this text is **not by itself a proof**. The separate `ThetaChain.scalar_chain` is an algebraic analogue with different ambient assumptions; these two statements are not definitionally equal.
