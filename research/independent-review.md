# Independent adversarial review packet — T01

**Status: NOT independently reviewed.** This packet is prepared for a genuinely separate agent or mathematician. The discovery author does not count as the independent referee.

## Read first, WITHOUT the discovery agent's assessment
- Original source `src/Formalism/ThetaLiftIndependence/Statement.lean` at mirror commit `8f558a8848a80dac6851a00a95ca477ff403e922`.
- Original `src/Formalism/ThetaLiftIndependence/ThetaOrbitSums/ChainScalar.lean`.
- `ThetaChain.lean` in this PR and the pinned `lakefile.toml`.
- Rallis literature https://arxiv.org/abs/1207.4709 .
- Original theorem statement from `Statement.lean`; do not take the explanatory English as authoritative.

## Required challenges
1. Reconstruct the original `ChainScalar` proposition exactly, including field, Hilbert, finite-dimensional and submodule hypotheses, and the adjoint direction.
2. Determine whether a proof of the full `ChainScalar` proposition is in the import closure of `Main.lean`, rather than assuming `def ChainScalar : Prop` is itself proved.
3. Independently compare the algebraic extraction to the original. Can arbitrary U_j/D_j be specialized to adjoints, without hidden finiteness or continuity assumptions?
4. Search counterexamples when stability is absent, scalar vanishes, coefficient ring has zero divisors, or n=0.
5. Attempt to compile the exact Lean file on the pinned Mathlib. Reproduce goal states on failure; no placeholders or extra axioms.
6. Check `#print axioms` and whether the statement is actually stronger/weaker than the English claim.
7. State whether any *new* automorphic or analytic consequence has been established (expected: no, absent further arithmetic arguments).
8. Distinguish conditional algebraic injectivity from genuine nonvanishing of theta lifts or from an RH consequence.
9. Confirm the direct dependency path, if claimed, rather than relying on an incomplete public graph.

Deliver an adversarial report with a verdict PROVED / DISPROVED / BLOCKED / CONJECTURAL and an evidence table. Until then do not label this step “independent agent review completed.”
