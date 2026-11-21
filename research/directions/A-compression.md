# Direction A — compress the argument (T01)

**Precise target:** Replace the geometric `ChainScalar` induction with an algebraic lemma about two composable families of linear maps over arbitrary modules.

Original Lean source: `Formalism.ThetaLiftIndependence.ChainScalar` at `src/Formalism/ThetaLiftIndependence/Statement.lean`; its `downChain` is defined alongside it. `ChainScalarLemmas.mem` proves one necessary invariant by induction in `ThetaOrbitSums/ChainScalar.lean`.

The extracted file `ThetaChain.lean` uses just:
1. Submodule stability under each upward step.
2. Local scalar equation D_j U_j = c_j id on the selected submodule.
3. R-linearity.

No inner product, finite-dimensional space, topology, field, adjoint or theta interpretation is used in the inductive core. This cleanly separates (i) a standard algebraic composition identity from (ii) the nontrivial number-theoretic construction establishing each local identity and lower bound. The compression claim is only for **this sublemma**, not for the 17-million-line RH proof.

**Prior knowledge:** Composition and adjoint reversal are standard functional analysis; Rallis inner-product identities are non-new (Gan–Qiu–Takeda, Invent. Math. 2014, https://arxiv.org/abs/1207.4709). Stepanov's multiplicity-based polynomial method is classical (IAS exposition https://www.ias.edu/video/csdm/stepanov).

**Next test:** Compile `ThetaChain.lean` in pinned Mathlib and compare its statement to the original `ChainScalar` specialization by explicitly defining U_j := adjoint(T_j), D_j := T_j. Avoid importing the entire source project into this workbench.
