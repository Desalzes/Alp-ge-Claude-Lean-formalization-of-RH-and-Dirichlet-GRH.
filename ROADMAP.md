# Research roadmap and next-session handoff

**Updated:** 2026-11-21  
**Scope:** reuse, independently test, and extend mathematical techniques extracted from the Alpöge–Claude Lean formalization of RH and Dirichlet GRH.  
**Status:** planning document; **no new mathematical result is asserted by this roadmap.**

## Start here: current project state

- [PR #1 (T01)](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./pull/1): finite theta-chain scalar identity, verified in pinned Lean; `ThetaChain.scalar_chain` is an **elementary algebraic transfer**, not the theta-lifting theorem.
- [PR #2 (T02)](https://github.com/Desalzes/Alp-ge-Claude-Lean-formalization-of-RH-and-Dirichlet-GRH./pull/2): conditional tower nonvanishing and StepRatio algebra; an **abstract** counterexample showing that a test-vector `IsConst` identity does not imply a full `Factor` factorization. PR #2 is stacked on #1. Their upstream theorem-chain applicability remains unverified.
- `main` initially contains project orientation; read both **open draft PR branches** before undertaking mathematical work.
- Source snapshot used in existing PRs: [leanprover-community/riemann-hypothesis](https://github.com/leanprover-community/riemann-hypothesis), commit `8f558a8848a80dac6851a00a95ca477ff403e922`; local isolated workbench pinned to Lean 4.33.1 and Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.
- **Boundaries:** no claim to prove RH anew; no claim of a defect in the published formalization merely because a *particular* isolated lemma has a stronger input than output; no extrapolation from Dirichlet GRH to arbitrary Hecke/automorphic GRH; don't equate Lean compilation with independent human mathematical exposition/refereeing.

## External sources: reusable work, not automatically certified truth

| Source | Likely reusable contribution | Intake/review action |
|---|---|---|
| [james-shore/rh-proof-dependencies](https://github.com/james-shore/rh-proof-dependencies) | **Highest priority.** Kernel-term dependency dataset and `tools/structure/query.py` (deps/users/path/meet/dominator). README describes dataset v0.2.1 as of this research pass. | Pin commit/dataset version; ask whether T01/T02 originals are in the final five-theorem proof cone. Avoid new text-only dependency crawlers. |
| [nasqret/riemann-rev](https://github.com/nasqret/riemann-rev) | Guided atlas/blueprint, status and independent reading aids, including example bridge lemmas. | Reference the relevant exact declarations; check statement fidelity; do not treat dashboard or exploratory bridges as independent proofs of our extracted generalizations. |
| [jae-63/rh-alpoge-blueprint](https://github.com/jae-63/rh-alpoge-blueprint) | Annotated top-level architecture, proposed crux classification, date-by-date theta chain map. | Cross-check against kernel dependencies; labels such as “crux” are interpretive. |
| [keithadler/rh-trim](https://github.com/keithadler/rh-trim) | Proof map, literature table, cautionary evidence that text-only pruning misses implicit dependencies. | Reuse literature/provenance map; **do not** reuse its acknowledged broken early reduced build as validated. |
| [andrewodesky.com/rh](https://andrewodesky.com/rh/) and [graph](https://andrewodesky.com/rh/graph.html) | Statement catalogue and navigational graph. | Use for discovery; explicitly identify edges not confirmed by kernel data. |
| [Lean source mirror](https://github.com/leanprover-community/riemann-hypothesis), [Deicyde mirror](https://github.com/Deicyde/riemann-hypothesis), [MIT proof audit](https://math.mit.edu/~drew/grh/) | Primary Lean declarations and formal-verification references. | Pin snapshots/line numbers; verify original theorem statements rather than transcribing summaries as facts. |
| [Robin Zhang, preliminary note](https://hexagonmath.org/2611.00809v1) | Human-readable reconstruction/provenance, especially iterated theta lifts. | Compare the source mechanism and hypotheses; it is a preliminary interpretation, not an independently kernel-checked bridge. |
| [Three simplifications in the Alpöge–Claude argument](https://hexagonmath.org/2611.00828v1) | Proposed conditional simplifications downstream of arithmetic input. | Extract exact hypotheses, rederive and independently check before implementing; don't presume the reductions hold in the entire formal development. |
| [Gan–Qiu–Takeda, Rallis inner-product formula](https://arxiv.org/abs/1207.4709) | Established theta correspondence, norms and nonvanishing context. | Establish which pieces are classical vs possibly specific to the new mechanism. |
| [User-shared r/mathematics discussion](https://www.reddit.com/r/mathematics/s/K5JTwJtn5q) | Possible newly surfaced papers, Lean projects, counterarguments, or reports. | **UNRESOLVED:** short URL could not be expanded at intake. Recover its canonical `/comments/...` URL and read the actual post and relevant replies before attributing any claim to it. |

**Public discussion is a lead generator, not proof evidence.** Record a claim only with permalink, author, date, exact sourced assertion, underlying source, and corroboration. If the Reddit link remains inaccessible, ask for its canonical full URL or pasted post; do not silently replace it with a similarly themed thread.

## Sequence for future sessions

### R00 — External-source & Reddit intake (short, can run alongside R01)
**Goal:** create a reliable source inventory without repeating existing work.  
**Actions:** check all URLs above, collect commit SHAs and publication versions, resolve the Reddit shortlink and investigate its *actual* cited leads; search arXiv/Hexagon/GitHub for stronger replacements or more recent updates. Cross-reference findings with both open PRs.  
**Deliverable:** `research/source-registry.md` with source/date/SHA/version, mapped local task, license notes, overlap, confidence, and exact actionable next step.  
**Exit:** each cited finding labeled `primary source verified`, `secondary interpretation`, `unverified lead`, or `not relevant`. Never invent a Reddit thread mapping.

### R01 — Kernel dependency reachability (TOP PRIORITY)
**Goal:** distinguish parts of our work used by the headline RH/Dirichlet GRH theorems from standalone algebra.  
**Actions:** reuse the dataset and `tools/structure/query.py` from `james-shore/rh-proof-dependencies`. Locate exact names for:
- `Formalism.ThetaLiftIndependence.ChainScalar`, `ChainScalarLemmas.mem`;
- `GlobalTheory.SqStep.theta_tower_norm_step_small_rank` and wrapper `GlobalTheory.T.witt_tower_norm_step_of_small_rank`;
- `GlobalTheory.Square.StepRatio` and `GlobalTheory.SqStepArith.stepFac_ratio_core`;
- `GlobalTheory.ConstRatio.Factor`, `Factor.isConst`, and `GlobalTheory.BotTransfer.bottom_constant_transfer_along_tower`.

For each, test presence/absence in the **kernel proof closure**, direct users, one path to a headline theorem if present, and use by any relevant intermediate lemma. Distinguish a *proposition/definition* from an actually used proof term. A missing item may still affect compilation/elaboration. Compare with the approximate blueprint and catalogue.  
**Deliverable:** `research/reviews/R01-kernel-dependency.md` with literal query commands, dataset SHA/version, positive/negative results, and source paths.  
**Exit:** no unsupported “critical dependency” labels; prioritize only truly used or mathematically informative routes. **Do not rebuild the entire 175k-file formalization merely for a small path query.**

### R02 — The `Factor` versus `IsConst` bridge (TOP mathematical question)
**Goal:** identify the *actual* mechanism supporting iteration of theta lifts without alleging a source defect.  
**Actions:** start from `research/T02-Factor-versus-IsConst.md` in PR #2. Trace constructors, callers, and exact hypotheses of `theta_tower_norm_step_small_rank`, `IsStageC`, `Factor`, `IsConst`, and the bottom transfer. Is the stage descent applied repeatedly, or is a different intermediate theorem/induction used? Search for a separate factorization reconstruction. Compare Robin Zhang's theta-lift exposition and relevant classical sources.  
**Mathematical micro-target:** for linear maps over a field, a common kernel induces a common quotient and injective maps; formally state *which extra second-side, integrability, and nonzero hypotheses* the original `Factor` still requires. Do not claim the common-kernel theorem fills the original bridge unconditionally.  
**Deliverable:** `research/reviews/R02-stage-bridge.md`; if a truly reusable lemma emerges, isolate it in a tiny `.lean` file with pin, compilation, axiom audit and counterexample tests.  
**Exit:** classify the bridge as `located`, `different iteration mechanism`, or `open after a scoped search`; give links and exact declarations.

### R03 — Algebraic consolidation and fidelity
**Goal:** prevent duplicated elementary work and verify all translations to/from upstream source.  
**Actions:** review T01/T02 with an independent skeptical pass. Check the original `ChainScalar` adjoint specialization, submodule stability, scalar multiplication ring order, totalized division in `StepRatio`, nonzero factors, and stage coherence. Identify existing Mathlib lemmas before implementing anything.  
**Deliverable:** a statement-fidelity table and test results; small targeted PR(s) to repair any mismatch.  
**Exit:** each theorem recorded as `kernel-checked local abstraction`, `source-specialization checked`, or `not connected`. Passing CI only proves the file's actual statement.

### R04 — Mathematical provenance and the genuinely novel input
**Goal:** identify which mathematical assumptions are classical and which are distinctive in the Stepanov-style / iterated theta-lifting mechanism.  
**Actions:** read Zhang's reconstruction, the two proof blueprints, the MIT audit, and relevant sections of Gan–Qiu–Takeda. Compare exact theorem statements for Rallis/seesaw, the `m ≈ sqrt(X)` chain, normalization, determinant/positivity, and conversion into smoothed prime-sum bounds.  
**Deliverable:** `research/reviews/R04-provenance.md`, a short theorem-by-theorem matrix: known result / new or uncertain / source Lean location / standard literature / open proof obligation.  
**Exit:** identify **one** nontrivial, reusable theorem to investigate next, not dozens of vague extensions.

### R05 — Evaluate independently proposed simplifications
**Goal:** discover whether the new three-simplifications note can shorten a verified downstream argument.  
**Actions:** restate each suggested change with quantified hypotheses; distinguish established reductions from AI-generated conjectural arguments; search Mathlib/Lean source for the needed inequality/oscillation machinery. Check for counterexamples to weakened assumptions.  
**Deliverable:** `research/reviews/R05-simplifications.md` with accept/reject/blocked classifications, plus optional isolated Lean experiment.  
**Exit:** no recommendation to replace any part of a validated proof until the replacement theorem is correctly stated, kernel-checked and connected.

### R06 — Conditional extensions to other L-functions (later)
**Goal:** determine precisely what input would be required to generalize beyond Dirichlet GRH.  
**Actions:** classify proposed unitary/orthogonal/symplectic theta correspondences, automorphic L-functions, local factors, stable subspaces, and nonvanishing/normalization conditions. Search existing literature and Lean formalizations first.  
**Deliverable:** a theorem template plus an explicit table of unavailable hypotheses and references; **no automorphic GRH claim** from algebraic scalar identities alone.  
**Exit:** a bounded and falsifiable next lemma, or documented reason to stop.

### R07 — Maintenance and skeptical review (recurring when starting a new task)
**Goal:** keep research source-pinned, reproducible, and honest as outside reports change.  
**Actions:** check whether new papers/repo updates supersede a claim; record original exact theorem statements; test adversarial edge cases; note incomplete human review; update this roadmap's `Current state`, source registry, and next-session queue.  
**Deliverable:** `research/reviews/R07-audit-YYYY-MM-DD.md` or a focused correction PR.  
**Exit:** no stale citation is treated as current merely because it appeared in a previous assistant answer.

## Ordering and stop rules

1. Run **R00** once for source hygiene; resolve Reddit if possible. Start **R01** as the main mathematical-navigation task.
2. Use R01 to choose the actual branch of **R02**; if the source already has the necessary construction, stop trying to prove it from `IsConst` alone.
3. Complete **R03** before merging any T01/T02 expansion; use **R04/R05** to avoid re-proving well-known analysis.
4. Only pursue **R06** after a source-faithful working mechanism and its nontrivial assumptions are understood.
5. Stop a line of work when it is already in a cited source, its assumptions cannot be met, or a counterexample invalidates it. A negative result with a reproducible counterexample is valuable.

## Reusable new-session instruction

> Read `README.md`, this `ROADMAP.md`, and open PR #1 and #2 *including their branches and research notes*. Refresh the relevant external source and its revision. Pick the highest-priority unfinished task **not being worked on**. First search kernel dependency datasets, mathlib, GitHub, and the published literature for prior work. Produce one verifiable deliverable (precise theorem/dependency path, test, formal lemma, or sourced obstruction); do not merely produce another speculative plan. Put notes in `research/reviews/` and update the source registry/roadmap. Work on a fresh `research/*` branch with a draft PR; don't merge. State exactly which claims were compiled, independently reviewed, inferred from source, or unverified. Never silently replace the user-shared Reddit short URL with a different discussion.

## Operating rules

- Keep the upstream Lean snapshot and local Lean/Mathlib pin explicit for every executable test.
- Separate (a) checking an abstract Lean lemma, (b) matching its type to the original source, (c) proving its source hypotheses from mathematics, and (d) proving it is actually in the headline theorem's dependency cone.
- Explicitly search existing tools/papers/Mathlib before proposing new infrastructure or a new proof.
- When citing mathematical assertions include declaration name + file + source revision, or a paper with a stable URL and precise proposition/section.
- Do not reproduce bulk source from the released Lean proof without checking the source's reuse rights; prefer theorem names, minimal statements, and links.
- Retain successful falsification/counterexamples. No `sorry`, `admit`, custom axioms, unsupported critical-edge assertions, or unreviewed merges.
- Reddit, social media, and early AI-authored writeups can point to work to check; they cannot certify a theorem.
