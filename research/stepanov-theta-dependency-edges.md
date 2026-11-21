# Original Stepanov/theta-tower dependency anchors (not a full dependency closure)

Source lock: `leanprover-community/riemann-hypothesis` commit `8f558a8848a80dac6851a00a95ca477ff403e922`.
The public graph https://andrewodesky.com/rh/graph.html announces incomplete coverage; the catalogue https://andrewodesky.com/rh/ explicitly links many listed claims to final Dirichlet zero-freeness. These are **verified source and catalogue links**, not a claim that the extracted `ChainScalar` is in the final proof's transitive closure.

## Mechanism described in the November 20 announcement

The four-page announcement https://alpo.ge/remark.pdf compares Stepanov multiplicity over function fields with iterated theta lifting over number fields. It specifically proposes using **approximately sqrt(X) lifts for a prime sum of length X**. That is an analogy, not a verified equality of operators or a self-contained estimate.

## Concrete original “tower descent” declaration

Exact source file:
`src/Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/LocalTypeDictionary/WittTowerNormStepOfSmallRank.lean`

- Underlying theorem: `GlobalTheory.SqStep.theta_tower_norm_step_small_rank` (line 16 in inspected excerpt).
- Export wrapper: `GlobalTheory.T.witt_tower_norm_step_of_small_rank` (~line 70).
- Both assume a `ThetaLocalInputs` package, `ThetaIntegralsAgree`, and `LocalMatching` plus a large `GBig` arithmetic datum and stage conditions. They are not unconditional statements about all theta lifts.
- Given a `q+1`-stage theta triangle, a dimension relation `A.rank = A'.rank + 2*e`, an initial factorization `Factor X ... lam`, and Hecke-L constraints `IsHeckeL`, they construct a `q`-stage triangle `Y` and scalars `c,y`, satisfying for every family parameter `t`:
  `y t ≠ 0` and `lam t * Lf t ((e + 1 : ℕ) : ℂ) = y t * c t`,
  together with the arithmetic `GlobalTheory.Square.StepRatio` constraint for `y t / y μ₀`.

The source proof starts with:
```lean
refine gbig_three
  (_root_.GlobalTheory.T.seesaw_first_reduction_level hP hK hM)
  GlobalTheory.T.thetaStepFactor_ratio_unit_gaussSumQuotient
  GlobalTheory.T.partialHeckeLFunction_square_eq_primitive ?_
```
and then invokes arithmetical `NumbersIn` and ratio data. This is a **substantive bridge from a stage-descending construction to Hecke L-values and algebraic scalar ratios**, unlike the elementary scalar-chain composition theorem.

The catalogue lists direct dependencies:
- “A self-dual orthogonal complement to a given hyperbolic plane”
- “Splitting a hyperbolic plane from a self-dual Hermitian lattice”
- “Existence of a nonzero adelic lattice and Fock vacuum”
- “Finite units fixing every nonunit”

and labels the tower-descent statement as used in “Zero-freeness for all Dirichlet characters.” This catalogue relationship is not a machine-extracted transitive import proof, and the 175k-file project is too large to call the entire chain audited from these few edges alone.

## Another direct bridge: lower theta scalar

Catalogue declaration:
`GlobalTheory.LowRow.scalar_of_form_key_lowC` in
`src/Development/AbelianVarietyTheory/Proofs/DivisorProofs/AdelCOfInnerProductFormula.lean:214`.

As catalogued, a global scalar identity and a quantitative lower bound are obtained **under extensive arithmetic and analytic hypotheses**, including the matching theta and Rallis packages. The catalogue explicitly lists it as used by the final Dirichlet zero-freeness claim.

## Where the present extraction sits

`Formalism.ThetaLiftIndependence.ChainScalar` and its proven `ChainScalarLemmas.mem` isolate the standard finite-composition operation. Our general `ThetaChain.scalar_chain` removes inner products from **that operation only**. It does not establish the `StepRatio` arithmetic property or `Lf` identity above, which look much more specific to the proposed number-theory mechanism.

**Research priority after T01:** investigate the assumptions of `theta_tower_norm_step_small_rank` one by one, especially whether `StepRatio` can be isolated as an independent valuation statement and tested against elementary CM/Hecke examples. Do not replace `GBig` with a weaker informal hypothesis without a proof.
