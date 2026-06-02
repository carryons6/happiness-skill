---
name: research-guardrail
description: Guardrail for AI-assisted research and analytical/computational work in ANY field — data analysis, statistics, machine learning, simulations, modeling, quantitative finance, computational science, and similar. Two jobs: (1) preserve the researcher's understanding and ownership of the parts worth owning, and (2) — the bigger threat in data work — catch the "looks-fine-but-silently-wrong" code (unit/scale mismatches, index/axis conventions, sign and ordering errors, data joins and alignment, normalization, time/epoch handling, leakage) before it quietly corrupts a result. EXPLICIT INVOCATION ONLY — do NOT trigger this skill automatically or proactively. Apply it only when the user explicitly asks for it: by running the /research-guardrail command, saying "$research-guardrail", or naming the skill (e.g. "use the research-guardrail skill to ..."). Do not invoke it on your own even when the task looks like reproducing a result, new-method development, pipeline building, or a quick implementation that could corrupt a downstream conclusion.
---

# Research Guardrail

## Overview

Use this skill to keep AI-assisted research both **trustworthy** and **satisfying** — without turning into anti-automation friction. The goal is good participation, not maximal manual labor.

**Invocation:** this skill is explicit-invocation only. Apply it when the user calls it by name (the `/research-guardrail` command, `$research-guardrail`, or asking to use the skill) — not automatically, even when the task looks like reproduction, method development, or pipeline work.

Two different things ruin research, and they need different defenses:

- **Lost trust** — the agent wrote plausible code that was silently wrong, and a conclusion got poisoned. In data and computational work this is usually the *bigger* threat, because the wrong code runs, looks reasonable, and produces a number. **Defend with verification gates.**
- **Lost understanding** — the agent did the interesting part, so the researcher never built the intuition. **Defend by keeping the mechanism manual when it's worth owning.**

This applies across fields. The silent-bug zones (units, indices, signs, joins, normalization, time, leakage) show up in astrophysics, genomics, finance, social science, and ML alike — only the specific conventions change.

A note on the underlying assumption: "satisfaction comes from participation" is a working heuristic, not a law. Some people get satisfaction from understanding, others from shipping. Calibrate to the actual person.

## First: scale the response to the task

Before any process, decide how heavy to be. **Most requests want the lightweight path.**

- **Quick / mechanical ask** (one transform, a plot, a fix, a small script): just do it. If it touches a silent-bug zone, **attach the one verification check** that would catch the error, and move on. No calibration, no table, no plan.
- **Substantial work** (reproducing a result, a new method, a multi-stage pipeline, training a student): run the fuller workflow below — split into modules, place them on the grid, give a short plan, gate the risky parts.

The verification gate is non-negotiable on either path. The *ceremony* (calibration, plans, tables) is only justified when the work is substantial enough that mapping it out pays for itself. Imposing the full ritual on a five-line request reads as condescension, not care.

## The two axes

Classify work along two axes. They are assessed differently:

- **Correctness risk** — mostly objective, read it off the code. Would a silent bug here survive review and corrupt a result? High whenever the code touches units, indexing/coordinate conventions, signs/ordering, joins/alignment, normalization, time/epoch, numerical stability, or train/test leakage.
- **Learning value** — calibrate to the person. Does *this* researcher build useful intuition by owning this? Depends on their role, prior exposure, and what they want to keep owning. You cannot read it off the code, so infer it from context or ask.

|  | **Low correctness risk** | **High correctness risk** (silent bugs survive) |
|---|---|---|
| **High learning value** | **MANUAL CORE** — own it to understand | **MANUAL CORE + hard verification** — own it *and* prove it right |
| **Low learning value** | **AGENT-OWNED** — automate freely | **AGENT-DRAFTED + VERIFICATION GATE** — let the agent write it, never trust it blind |

The bottom-right cell is the easy one to miss. You don't need to deeply *understand* an array reshape, a unit conversion, or a table join — but you must *verify* it, because a silent error there corrupts every downstream value and you find out three figures later.

(**Co-created** — "agent broadens the options, researcher chooses" — usually lands in the right column: choices that are both somewhat instructive and consequential.)

## The verification gate (the core of this skill)

Whenever code lands in the high-risk column, attach the check that would catch a silent error. A gate is a concrete, runnable assertion — not "be careful."

Common silent-bug zones and a gate for each:

- **Units & scale** — mixed units, wrong scale factor or magnitude. *Gate:* assert a known quantity comes out in the expected unit and order of magnitude.
- **Index & coordinate conventions** — 0- vs 1-indexed, row- vs column-major, inclusive vs exclusive ranges, axis order. *Gate:* round-trip a known element, or inject a known value at a known position and confirm where it lands.
- **Sign, direction & ordering** — flipped sign, ascending vs descending, transposed array. *Gate:* run a tiny hand-computed case and compare element by element.
- **Aggregation over the wrong axis** — reducing across the wrong dimension. *Gate:* check output shape plus a hand-verified aggregate on a small input.
- **Joins, merges & alignment** — wrong key, dropped or duplicated rows, misaligned series. *Gate:* check row counts and match completeness/contamination against a clean subset.
- **Normalization & weighting** — wrong constant, double counting, missing or mis-applied weights. *Gate:* recover a known calibrated value from known inputs.
- **Time, timezone & epoch** — offset, reference shift, off-by-one in date math. *Gate:* convert a known timestamp both ways against an independent reference.
- **Numerical stability** — precision, overflow/underflow, NaN propagation, order-dependent sums. *Gate:* compare against a higher-precision or analytic reference.
- **Leakage & randomness** (ML / statistics) — train/test contamination, unfixed seeds, look-ahead bias. *Gate:* assert splits are disjoint and a fixed seed reproduces the result.

**These are illustrative, not a checklist for one field.** The general move is the same everywhere: name the conventions and transforms where a *wrong assumption would survive review*, then gate those. Examples of field-specific conventions worth gating — a discipline's coordinate systems and calibration constants; an accounting sign convention or look-ahead/survivorship bias in finance; genomic coordinate offsets and strand orientation; a survey's weighting and missing-data codes; a schema's key and null rules. If you can't name a gate for risky code, **say so explicitly** — that itself is the warning.

State the relevant gate inline when you deliver the code.

## Workflow (substantial-work path)

1. If the capability boundary is unclear, run a brief calibration (below). Skip it when context already makes the answer obvious, or the task is small.
2. Identify the context: reproduction, new method, pipeline, or training.
3. Split the work into modules.
4. Place each module on the grid.
5. Give a short participation plan (template below) before writing full code.
6. Implement agent-owned parts fully.
7. For risky parts: implement them **and attach the gate**. Never hand over risk-column code without the check.
8. For manual-core parts: **default to full code plus an "understanding ledger"** (a short note of which insights the researcher skips by reading instead of writing), rather than withholding code. Offer the scaffold-only version as the alternative.

Why the flipped default in step 8: telling a capable researcher "I'll only give you a scaffold" usually lands as friction, not learning. Full code plus a clear map of the bypassed understanding respects their agency and still flags the intuition risk. Withhold only in explicit learning/training mode, or on request.

Rule of thumb: friction at **setup, dependencies, boilerplate, I/O, logging, plotting, routine tests** → just help and reduce friction. Friction at the **core mechanism, experimental judgment, failure interpretation, objective design, or what counts as a fair comparison** → slow down and preserve participation.

## Capability calibration

Only when the boundary is unclear and the task is substantial. Ask at most 3–5 short questions — enough to set a boundary, not an exam. Prefer multiple choice, and infer from context first.

1. Role: PI / postdoc / PhD / master / undergrad / engineer / other?
2. Have you implemented this method's central mechanism once, yourself, before?
3. What do you most want to keep owning: the math, the core algorithm, debugging, experiment design, or the interpretation?
4. What should the agent freely automate: environment, I/O, pipeline glue, plotting, tests, docs, packaging?
5. Priority: learning / fast reproduction / new-method exploration / production-grade infrastructure?

Adjust the grid:
- Less prior exposure → more manual core, more checkpoints.
- Strong experience → more agent-owned and co-created implementation.
- Training context → explanation, prediction, and debugging checkpoints are mandatory.
- Deadline / infrastructure context → automate setup aggressively, but still *name* the research decisions and keep the gates.

## Output templates

### Research participation plan

| Module | Cell | Researcher action | Agent support | Verification gate (if risky) |
|---|---|---|---|---|
| [module] | agent-owned / agent-drafted+gate / co-created / manual core | [what human does] | [what agent does] | [the check that catches a silent error, or "n/a"] |

Then add:

**Manual core for this task:** [1–3 bullets]
**Automate but verify:** [1–3 bullets, each with its gate]
**Safe to automate:** [1–3 bullets]
**Next step:** [one concrete thing the researcher can do now]

### Manual-core delivery (flipped default)

Default = full code + understanding ledger:
1. Provide the working implementation.
2. **Understanding ledger:** 2–4 bullets naming the insights the researcher is *not* getting by reading instead of writing (e.g. "you're skipping the gradient-shape reasoning that explains why this term is needed").
3. Offer the scaffold-only alternative: "Want the signatures + TODO blocks instead, so you implement the core yourself? I'll review."

Scaffold-only mode (use in learning/training, or on request):
1. State the invariant or mechanism in plain language.
2. Give signatures / pseudocode.
3. Minimal TODO blocks, not full code.
4. Tests, probes, and expected failure modes.
5. Ask the researcher to fill the core step, then offer to review.

### Student training plan

| Stage | Student-owned work | Agent-allowed support | Checkpoint (evidence of understanding) |
|---|---|---|---|
| [stage] | [manual / co-created] | [allowed automation] | [explain / predict / debug / modify] |

Checkpoints, e.g.: explain the core update or transform logic without looking at the code; predict how changing one parameter (learning rate, threshold, regularization strength, sample size) changes the failure mode; implement the minimal version once before using an agent-generated refactor; diagnose one failed run before asking the agent to fix it; document which lines were agent-generated, edited, or hand-written.

## Context-specific notes

**Reproduction** — pin the exact claim; extract the core algorithm, objective/metric, and evaluation protocol; researcher implements or annotates the central mechanism once; agent automates scaffolding, configs, logging, plotting, sanity tests, each risky piece with its gate. For discrepancies, separate the causes — implementation bug, missing paper detail, compute/data difference, or genuine paper fragility — and don't auto-default to "our bug." Don't produce a full repo unless the user opts out of the participation plan.

**New method** — reduce the idea to a minimal falsifiable prototype; researcher owns the core mechanism and the expected behavior; agent generates alternative formulations, harnesses, and diagnostic plots; require one hand-written or researcher-edited minimal implementation before large-scale engineering; treat surprising failures as research material, not just bugs.

**Pipeline / infrastructure** — where the gate earns its keep. Glue, I/O, batching, config → agent-owned. Convention-sensitive transforms (units, index/coordinate conventions, joins, normalization, time) → agent-drafted-with-gate. The choice of *what the pipeline is allowed to assume about the data* → co-created or manual core.

**Student training** — use the skill as a supervision protocol: define what the student must understand after the task, assign manual-core work that creates exactly that understanding, allow agent support only where it doesn't hide the learning objective, and gate on explanation/prediction/debugging.

## Override rule

If the user explicitly asks for full automation after seeing the plan, comply unless unsafe. Still (a) mark which parts would normally be manual core, and (b) keep the verification gates on risky code regardless. Bypassing *understanding* is the user's call; silently bypassing *correctness checks* on result-poisoning code is not.

## Style

Be supportive, never moralizing. Don't shame agent usage. Frame manual work as preserving taste and ownership, and frame verification gates as protecting the result, not distrusting the user. Prefer short, practical outputs over philosophy.
