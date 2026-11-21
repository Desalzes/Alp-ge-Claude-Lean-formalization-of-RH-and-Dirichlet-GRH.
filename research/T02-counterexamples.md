# T02 — Hypothesis tests and falsification

The proved candidate requires a **commutative semiring with no zero divisors**, a *coherent* family of identities, nonzero normalizations, and a nonzero bottom constant.

## Counterexample 1: drop nonzero normalization

R = ℤ, a0 = 1, y0 = 0, a1 = 0, L0 = 0.
Then a1*L0 = 0 = y0*a0, and a0 is nonzero. But a1 = L0 = 0. So `y0 != 0` is essential.

## Counterexample 2: drop nonzero bottom stage

R = ℤ, a0 = 0, y0 = 1, a1 = 1, L0 = 0.
Then a1*L0 = 0 = y0*a0, with y0 nonzero, yet L0 = 0. So `a0 != 0` is essential.

## Counterexample 3: drop no-zero-divisors

R = ℤ/6ℤ, a0 = 3, y0 = 2, a1 = 1, L0 = 0.
Then a0 and y0 are nonzero, while a1*L0 = 0 = 2*3 = y0*a0 (mod 6). Thus nonzero factors alone do NOT propagate nonvanishing in general commutative semirings.

## Counterexample 4: invalid inference from a single step

A single equality at stage q+1 -> q does NOT establish a coherent family of equalities at all stages. Merely producing each lower-stage constant existentially is not enough unless the constructed data is reused as the corresponding upper-stage input for the following step and remains admissible. The Lean theorem explicitly assumes `∀ j` the shared `stage j` in both adjacent equations.

## Counterexample 5: pointwise versus analytic multiplicity

At a fixed `s0`, the equality `λ(s0)L(s0)=y(s0)c(s0)` does not impose a germ-level relation at any other s. For example, choose λ(s0)=y(s0)=1 and L(s0)=c(s0)=1, but functions L(s)=1 and c(s)=1+(s-s0) have different local derivatives while agreeing at s0. Thus no equality of derivatives or zero orders follows from pointwise equality.

A full analytic-germ statement `λ(s)L(s)=y(s)c(s)` near s0 would require λ and y *holomorphic and nonvanishing at s0* to equate zero orders. Such a hypothesis does not appear in this specific original tower-step conclusion.

## Reproduction

Run `python3 scripts/test_tower_nonzero.py` to verify the first three exact arithmetic examples and exhaustive bounded checks over ℤ. The Python test is not a proof of the universal claim; the Lean kernel check is.
