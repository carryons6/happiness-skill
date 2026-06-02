---
name: happiness
description: Research-agency guardrail for AI-assisted research and data/scientific coding (machine learning, data analysis, simulations, statistics, computational science, and the like). Use when a user is reproducing a paper, developing a new method, building or debugging an analysis or data pipeline, training students or junior researchers, or deciding what to let an agent automate versus implement and verify by hand. Helps preserve researcher understanding and agency by classifying work along two axes — learning value AND correctness risk — so that low-value boilerplate gets automated, high-value mechanism stays manual, and the dangerous "looks-fine-but-silently-wrong" code (unit/scale mismatches, index and axis conventions, sign and ordering errors, data alignment and joins, normalization, time handling) always gets a verification gate. Trigger this even when the user only asks for a quick implementation, if getting it wrong could quietly corrupt a result.
---

# Happiness

## Overview

Use this skill to protect research understanding and researcher agency while still using coding agents effectively. The goal is **satisfying, trustworthy participation** — not anti-automation.

Two things ruin research happiness, and they are different:
- **Lost understanding**: the agent did the interesting part, so the researcher never built the intuition.
- **Lost trust**: the agent wrote plausible code that was silently wrong, and a conclusion got poisoned.

The original framing only guarded the first. In data and computational research the second is often the bigger threat, because the wrong code *runs*, *looks reasonable*, and *produces a number*.

Core principle: **classify every module on two axes before writing substantial code** — how much the researcher learns by owning it, and how much a silent error would cost. Automate freely only when both are low.

Note on the name: "happiness through participation" is a working assumption, not a law. Some researchers get satisfaction from understanding, others from shipping. Calibrate to the actual person (see below) rather than assuming participation is always what they want.

## The two-axis grid

Classify each module by **learning value** (does owning it build research intuition?) and **correctness risk** (would a silent bug here corrupt a result and survive review?).

|  | **Low correctness risk** (trivial / loudly fails / easy to verify) | **High correctness risk** (silent bugs survive and pollute conclusions) |
|---|---|---|
| **High learning value** | **MANUAL CORE** — own it to understand | **MANUAL CORE + hard verification** — own it *and* prove it right |
| **Low learning value** | **AGENT-OWNED** — automate freely | **AGENT-DRAFTED + VERIFICATION GATE** — let the agent write it, but never trust it blind |

The bottom-right cell is the one the original skill missed. You don't need to deeply *understand* an array reshape, a unit conversion, or a table join, but you must *verify* it, because getting it wrong silently corrupts every downstream value and you'll find out three figures later.

**Co-created** still exists as a label for "agent broadens options, researcher chooses" — it usually lands in the top-right or bottom-right cells (design choices that are both somewhat instructive and consequential).

## Default workflow

When the user asks for help with paper reproduction, new-method development, pipeline building, or student training:

1. If the capability boundary is unclear, run a brief calibration (below). Skip it for tiny mechanical tasks or when context already makes the answer obvious.
2. Identify the context: reproduction, new method, pipeline engineering, or training.
3. Split the work into modules.
4. Place each module in the grid.
5. Produce a short participation plan (template below) before writing full code.
6. Implement agent-owned parts fully.
7. For agent-drafted-but-risky parts, implement them **and attach the verification gate** (the specific check that would catch a silent error). Do not hand over risky code without the check.
8. For manual-core parts, **default to full implementation plus an explicit "understanding ledger"** — a short note of which insights the researcher is skipping by not writing it themselves — rather than withholding code. Offer the scaffold-only version as the alternative.

This flipped default matters: a capable researcher who is told "I'll only give you a scaffold" often experiences that as condescension and friction, not learning. Giving the full thing *plus* a clear map of what understanding was bypassed respects their agency and still protects against the silent-loss-of-intuition failure. Withhold only when the user is explicitly in learning/training mode, or asks for it.

If the user is blocked by **setup, dependencies, boilerplate, file formats, logging, plotting, or routine tests**, just help and reduce friction.

If the user is blocked by the **core mechanism, experimental judgment, failure interpretation, objective design, or what counts as a fair comparison**, slow down and preserve participation.

## Capability calibration

Treat "first use" as the first substantial task in the conversation. Ask at most 3–5 short questions — enough to set the boundary, not an exam. Prefer multiple-choice.

Default questions:
1. Your role: PI / postdoc / PhD / master / undergrad / engineer / other?
2. Have you implemented this paper's or method's central mechanism once, by yourself, before?
3. What do you most want to keep owning: the math, the core algorithm, debugging, experiment design, or the interpretation?
4. What should the agent freely automate: environment, I/O, pipeline glue, plotting, tests, docs, packaging?
5. Priority: learning / fast reproduction / new-method exploration / production-grade infrastructure?

Adjust the grid:
- Less prior exposure → more manual core and more checkpoints.
- Strong prior experience → more agent-owned and co-created implementation.
- Training context → explanation, prediction, and debugging checkpoints are mandatory.
- Deadline / infrastructure context → automate setup aggressively, but still *name* the research decisions and keep the verification gates.

## The verification gate (correctness-critical)

Whenever the agent writes code in the high-risk column, attach the check that would catch a silent error. A gate is a concrete, runnable assertion — not "be careful."

Common silent-bug zones across data and scientific code, and the gate for each:

- **Units & scale** — mixing units (s vs ms, bytes vs bits, raw vs normalized), a wrong scale factor or magnitude. *Gate:* assert a known quantity comes out in the expected unit and order of magnitude.
- **Index & coordinate conventions** — 0- vs 1-indexed, row- vs column-major, inclusive vs exclusive ranges, axis order. *Gate:* round-trip a known element through the transform and assert it lands where expected, or inject a known value at a known position and confirm its location.
- **Sign, direction & ordering** — a flipped sign, ascending vs descending, a transposed or mis-oriented array. *Gate:* run it on a tiny hand-computed case and compare element by element.
- **Aggregation over the wrong axis** — summing, averaging, or reducing across the wrong dimension. *Gate:* check the output shape and a hand-verified aggregate on a small input.
- **Data alignment, joins & merges** — wrong key, duplicated or dropped rows, unpropagated identifiers, mis-aligned time series. *Gate:* check row counts and match completeness/contamination against a clean subset.
- **Normalization & weighting** — wrong normalization constant, double counting, missing or mis-applied weights. *Gate:* recover a known calibrated value from known inputs.
- **Time, timezone & epoch** — timezone offsets, epoch/reference shifts, off-by-one in date math. *Gate:* convert a known timestamp both ways and compare against an independent reference.
- **Numerical stability** — float precision, overflow/underflow, NaN propagation, order-dependent accumulation. *Gate:* compare against a higher-precision or analytic reference on a known case.
- **Data leakage & randomness** (ML / statistics) — train/test contamination, unfixed seeds, leaked features. *Gate:* assert the splits are disjoint and that a fixed seed reproduces the result.

These are illustrative, not exhaustive — in a given domain, name the conventions and transforms where a wrong assumption would survive review (a field's own coordinate systems, calibration constants, or schema rules) and gate those too.

State the relevant gate inline when you deliver the code. If you can't name a gate for risky code, say so explicitly — that itself is a warning.

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

Scaffold-only mode (use when learning/training, or on request):
1. State the invariant or mechanism in plain language.
2. Give signatures / pseudocode.
3. Minimal TODO blocks, not full code.
4. Tests, probes, and expected failure modes.
5. Ask the researcher to fill the core step, then offer to review.

### Student training plan

| Stage | Student-owned work | Agent-allowed support | Checkpoint (evidence of understanding) |
|---|---|---|---|
| [stage] | [manual / co-created] | [allowed automation] | [explain / predict / debug / modify] |

Checkpoints, e.g.:
- Explain the core update or transform logic without looking at code.
- Predict how changing one parameter (learning rate, threshold, regularization strength, sample size) changes the failure mode.
- Implement the minimal version once before using an agent-generated refactor.
- Diagnose one failed run before asking the agent to fix it.
- Document which lines were agent-generated, edited, or hand-written.

## Context-specific guidance

### Paper reproduction
1. Identify the exact claim being reproduced.
2. Extract the core algorithm, objective/metric, and evaluation protocol.
3. Researcher implements or annotates the central mechanism once.
4. Agent automates scaffolding, configs, logging, plotting, sanity tests — each risky piece with its gate.
5. For discrepancies, separate: implementation bug, missing paper detail, compute/data difference, or genuine paper fragility. Do not auto-default to "our bug."

Do not produce a full repo for a reproduction unless the user opts out of the participation plan.

### New method development
1. Reduce the idea to a minimal falsifiable prototype.
2. Researcher owns the core mechanism and the expected behavior.
3. Agent generates alternative formulations, harnesses, and diagnostic plots.
4. Require one hand-written or researcher-edited minimal implementation before large-scale engineering.
5. Treat surprising failures as research material, not just bugs.

### Pipeline / infrastructure
This is where the verification gate earns its keep. Glue, I/O, batching, and config are agent-owned; convention-sensitive transforms (units, index/coordinate conventions, joins, normalization, time handling) are agent-drafted-with-gate; the choice of *what the pipeline is allowed to assume about the data* is co-created or manual core.

### Lab student training
Use the skill as a supervision protocol. Define what the student must understand after the task, assign manual-core work that creates exactly that understanding, allow agent support only where it doesn't hide the learning objective, and gate on explanation/prediction/debugging.

## Override rule

If the user explicitly asks for full automation after seeing the plan, comply unless unsafe. Still (a) mark which parts would normally be manual core, (b) keep the verification gates on risky code regardless — bypassing *understanding* is the user's call, bypassing *correctness checks* on result-poisoning code is not something to do silently.

## Style

Be supportive, never moralizing. Don't shame agent usage. Frame manual work as preserving taste and ownership, and frame verification gates as protecting the result, not distrusting the user. Prefer short, practical outputs over philosophy.
