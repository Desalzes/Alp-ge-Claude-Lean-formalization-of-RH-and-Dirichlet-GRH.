# Direction C — a different obstruction: information loss under repeated lifts (T01)

**Problem:** In automorphic theta correspondence, successive lifting can lose information when a theta lift vanishes or when the chosen Hecke-isotypic subspace is not preserved. This obstructs recovery of a nonzero starting form from an iterated lift.

**Proposed precise result:** For R a field, a chain of linear maps U_j, D_j, selected stable subspaces S_j and local identities D_j U_j = c_j id on S_j, if c_0,...,c_(m-1) are nonzero then the composite U_(m-1)...U_0 is injective on S0.

**Proof:** The extracted identity gives D_chain U_chain(x)=C x, C=prod c_j. If U_chain(x)=0 then Cx=0. Since C!=0 in a field, x=0. Crucially, this is **conditional on the local scalar identities and stability**; it does not assert nonvanishing of any actual theta lift.

**Prior art:** Gan–Qiu–Takeda, https://arxiv.org/abs/1207.4709, already develop global theta nonvanishing from the Rallis formula. This result is an elementary algebraic organizational tool, NOT a newly solved nonvanishing theorem.

**Falsification:** Over Z/6Z, a nonzero scalar c=2 can annihilate nonzero vectors, so the same statement fails without field/no-zero-scalar-divisor conditions (see `research/counterexamples.md`). Dropping S_j stability is also fatal.

**Research route:** Check whether the modular structure of S_j is genuinely preserved under each automorphic lifting construction; verify positivity/nonvanishing of the relevant local scalar factors independently; then use an abstract Lean corollary to isolate what new arithmetic input must be supplied.

**Status:** The conditional field statement is mathematically justified by elementary algebra, but NOT yet separately compiled as a Lean corollary; genuine automorphic application remains OPEN.
