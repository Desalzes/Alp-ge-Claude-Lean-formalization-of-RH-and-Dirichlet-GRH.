# Lean verification record — T01

## Successful verified proof (2026-11-21)

- Proof source: `ThetaChain.lean` at commit `660bcbbf44fb158da1670c7822e315157a2d1794`.
- GitHub Actions run: https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./actions/runs/44933966518
- Job: `lean`, ID `136936460834`.
- Result: **SUCCESS** (all CI steps green, build compiled 8707 jobs).
- Command in CI build step: `lake build` via `leanprover/lean-action@v1`.
- Independent file elaboration/kernel step: `lake env lean ThetaChain.lean`: **SUCCESS**.
- Placeholder/custom axiom source scan: **SUCCESS**, no `sorry`, `admit` or project `axiom` tokens in candidate file.
- Lean: `leanprover/lean4:v4.33.1`.
- Mathlib exact pin: `0df444a360eaa60ab8c11dca51a86af692955474`.
- Full dependency graph pinned in `lake-manifest.json` (same mathematical library set as source release).

Actual `#print axioms` output from the successful GitHub Actions log:

```text
'ThetaChain.upChain_mem' depends on axioms: [propext, Quot.sound]
'ThetaChain.scalar_chain' depends on axioms: [propext, Classical.choice, Quot.sound]
```

There is **no `sorryAx`**. These are Lean's ordinary foundational axioms, not source-specific axioms.

## Statement audited

The proved theorem is exactly `ThetaChain.scalar_chain` in this repository. It says that for a commutative semiring R, R-modules E_j, linear maps U_j and D_j, submodules S_j, local identities D_j U_j x = c_j x for x ∈ S_j, and stability U_j(S_j) ⊆ S_(j+1), the composite downward/upward chain on S_0 equals multiplication by ∏ c_j.

This is an abstract, standard algebraic result extracted from the shape of the published `Formalism.ThetaLiftIndependence.ChainScalar` proposition (which is about adjoints in finite-dimensional inner-product spaces). **We have not compiled the original `ChainScalar` definition or proved a specific theta-lift hypothesis here.**

The proof does not assert the nonvanishing of any automorphic L-value, RH, or GRH.

## Failed iterations before success

1. Run 44933529763 (and corresponding PR event): FAILED before theorem compilation, because the new Lake project initially lacked `lake-manifest.json`.
2. Run 44933666544: FAILED with exact Lean errors in the local recursive calls of `upChain`/`downChain`; missing recursive parameter elaboration led to synthetic `sorryAx` in the *failed compilation*, **not** a successful proof.
3. Run 44933903226: FAILED after accidentally removing explicit `E` at *external* call sites; the Lean goal reported application type mismatch at lines 39 and 61.
4. Run 44933966518: SUCCESS after restoring explicit `E` at external call sites and removing it **only** from local recursive calls.

This history is retained to demonstrate proof-debugging based on actual compiler diagnostics rather than treating uncompiled code as verified.

## Independent review

A separate agent or mathematical referee has **not** reviewed this PR. See `research/independent-review.md` for the source-blinded review contract. The proof is kernel-accepted, but independent *statement fidelity / novelty / mathematical relevance* review remains pending.

**Final statuses:** extracted algebraic lemma — **PROVED**; weakening that drops stability — **DISPROVED**; any new RH/Dirichlet GRH consequence — **NOT CLAIMED**; proposed automorphic generalization — **CONJECTURAL/BLOCKED ON NEW HYPOTHESES**.
