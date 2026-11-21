# T01 — independent falsification attempts (exact arithmetic)

Status of the full algebraic chain formula: **no counterexample found under all hypotheses**. The result is expected from induction; see ThetaChain.lean. Two invalid strengthenings/weakenings are refuted below.

## Test 1: stability cannot be omitted

All matrices are over Q. Let E0 = Q, E1 = Q^2, E2 = Q. Let S0 = E0 and S1 = span((1,0)).
Take

    U0 = column(1,1), D0 = row(1,0);
    U1 = row(0,1), D1 = column(1,0).

Then D0 U0 = (1), so c0=1 works on S0.
For x=(t,0) in S1, D1 U1 x = 0, so c1=0 works on S1.
But U0(1)=(1,1) is NOT in S1. Thus the upward stability hypothesis fails.

The two-stage composite acts on 1 as D0 D1 U1 U0(1)=1.
The claimed product is c0*c1*1 = 0.
Hence **omitting U0(S0) subset S1 makes the formula false**.

Exact symbolic computation with SymPy on 2026-11-21 gave:
  c0 = 1
  D1 U1 (1,0) = (0,0)
  actual two-step matrix = [[1]]
  predicted two-step matrix = [[0]]

## Test 2: nonzero scalar is not injectivity over arbitrary rings

Work over R = Z/6Z. Let E0=E1=R, S0=E0,
U0(x)=2x, D0(x)=x and c0=2. The hypotheses hold:
D0 U0 x = 2x for all x; S1=E1 is stable.

c0 != 0 in R, but U0(3)=0 although 3 != 0.
Thus “all local scalars are nonzero implies every lift injective” is FALSE over a general commutative semiring.

A sufficient replacement is that the total product acts injectively on S0. Over a field, nonzero product is sufficient. Over modules with zero divisors or torsion, it need not be.

## Test 3: sanity checks, not proof

At m=0, upChain and downChain are identities and the product is 1.
For one-dimensional vector spaces, U0(x)=2x, D0(x)=3x, U1(x)=5x, D1(x)=7x:
  c0 = 6, c1 = 35, two-stage product = 210.
The operator product agrees: 3*7*5*2 = 210.

These tests do not substitute for Lean checking of the universally quantified statement.
