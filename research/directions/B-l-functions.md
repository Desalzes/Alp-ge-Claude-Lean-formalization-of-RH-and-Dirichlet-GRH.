# Direction B — conditional extension to related L-functions (T01)

**Setting:** Iterated theta correspondences over unitary or symplectic/orthogonal dual pairs, with eventual applications to automorphic L-functions beyond the Dirichlet family. This is a proposed **conditional research program**, not a GRH extension theorem.

**Exact abstract question:** Given compatible theta lift maps U_j between selected automorphic representation spaces, suitable reverse maps D_j and Hecke-stable subspaces S_j, can one verify
D_j U_j | S_j = c_j id and U_j(S_j) subset S_(j+1)?
If so, `ThetaChain.scalar_chain` formally provides the composite scalar formula over the chosen coefficient ring. To infer nonvanishing or injectivity one ALSO needs an appropriate nonzerodivisor / scalar-product hypothesis. To infer an L-function zero-free region one would need further analytic inequalities and an explicit bridge to that L-function; this project does not supply them.

**Literature check:**
- Gan, Qiu and Takeda, *The regularized Siegel–Weil formula (the second term identity) and the Rallis inner product formula*, Inventiones Math. 198 (2014), https://arxiv.org/abs/1207.4709 : a broad theorem for global theta lifts; hence local norm identities themselves are **not original** here.
- A critical case of the Rallis inner product formula relates norms of theta lifts to central L-values: https://experts.umn.edu/en/publications/a-critical-case-of-rallis-inner-product-formula/ .
- The source's `Main.lean` headline GRH is for Dirichlet L-functions, not all Hecke or automorphic L-functions. Any broader GRH assertion needs a separate exact definition and proof.

**Obstacle:** Local Rallis data may involve vanishing scalars, varying target representation spaces, convergence and measure normalization, as well as failure of stability of the intended Hecke-eigenspaces. No step establishing these inputs outside the original setting has been extracted.

**Status:** CONJECTURAL application; algebraic transfer statement under explicit hypotheses is the sole formal target.
