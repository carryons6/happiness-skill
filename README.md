# Happiness Skill

[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-D97757)](https://claude.com/claude-code)
[![Codex](https://img.shields.io/badge/Codex-skill-412991)](https://openai.com/codex)

Happiness is a skill for AI-assisted research coding. It helps researchers use coding agents without losing the parts of the work that create understanding, judgment, and ownership — and without letting plausible-looking code silently poison a scientific result.

It is tuned for observational-astronomy and data-pipeline work (astrometry, photometry, image registration/stacking, source detection, catalog matching, FITS/WCS handling), but the workflow applies to any research coding.

[中文说明](README_zh-CN.md)

## What It Does

The skill adds a research-agency guardrail before substantial coding work. It guards against two different ways AI-assisted research goes wrong:

- **Lost understanding** — the agent did the interesting part, so the researcher never built the intuition.
- **Lost trust** — the agent wrote plausible code that was silently wrong, and a conclusion got poisoned.

To handle both, it classifies every module on **two axes** before writing substantial code:

- **Learning value** — does owning this build research intuition?
- **Correctness risk** — would a silent bug here survive review and corrupt a result?

|  | Low correctness risk | High correctness risk |
|---|---|---|
| **High learning value** | **Manual core** — own it to understand | **Manual core + hard verification** — own it *and* prove it right |
| **Low learning value** | **Agent-owned** — automate freely | **Agent-drafted + verification gate** — let the agent write it, never trust it blind |

`Co-created` (agent broadens options, researcher chooses) still exists as a label for design choices that are both somewhat instructive and consequential.

The goal is not to avoid automation. The goal is to automate low-value pain, preserve high-value friction, and put a **verification gate** on the dangerous "looks-fine-but-silently-wrong" code.

## The Verification Gate

For any risky code (coordinate conventions, units, time systems, flux scaling, resampling, catalog matching), the skill attaches a concrete, runnable check that would catch a silent error — not "be careful." For example:

- **Array vs sky axis order** — inject a source at a known pixel, confirm it lands at the expected `(x, y)` and sky position.
- **Pixel index origin** — round-trip `pix → world → pix` on known points and assert sub-milli-pixel closure.
- **Time systems** — convert a known timestamp both ways and compare against an independent reference.

If a gate can't be named for risky code, the skill says so explicitly — that itself is the warning.

## When To Use It

Use this skill when a user is:

- reproducing a paper,
- developing a new research method,
- building or debugging an analysis pipeline,
- training lab students to use coding agents responsibly,
- deciding what to let an agent automate versus implement and verify by hand.

Trigger it even for a "quick implementation" if getting it wrong could quietly poison a scientific result.

## First-Use Calibration

On the first substantial use in a conversation, or whenever the user's capability boundary is unclear, the skill asks a short calibration questionnaire before planning. Typical questions cover:

1. the user's role in the task,
2. whether they have implemented the core algorithm or objective before,
3. what they want to preserve for learning or research ownership,
4. what the agent may freely automate,
5. whether the priority is learning, fast reproduction, exploration, or infrastructure.

The answers shift the grid — less prior exposure means more manual core and more checkpoints; strong experience means more agent-owned and co-created work; the verification gates stay on risky code either way.

## Manual-Core Delivery

By default the skill delivers the **full working implementation plus an "understanding ledger"** — a short note of which insights you skip by reading the code instead of writing it yourself — rather than withholding code. Scaffold-only mode (signatures + TODO blocks for you to fill in) is offered as the alternative, and used by default in explicit learning or training contexts.

## Install

### Claude Code

**As a plugin (recommended)** — the repo ships a plugin marketplace, so you can install it with `/plugin`:

```text
/plugin marketplace add carryons6/happiness-skill
/plugin install happiness@happiness-skill
```

**As a personal skill** — clone into your skills directory:

```bash
git clone https://github.com/carryons6/happiness-skill.git ~/.claude/skills/happiness
```

Or use it as a project skill by placing it under `.claude/skills/happiness/` in your repository. Claude Code discovers the skill automatically from the `SKILL.md` frontmatter.

### Codex

Recommended: install it through Codex with the built-in skill installer.

```text
Use $skill-installer to install the skill from https://github.com/carryons6/happiness-skill.
Use path "." and install it as "happiness".
```

Then restart Codex so it can discover the new skill.

CLI equivalent:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo carryons6/happiness-skill \
  --path . \
  --name happiness
```

Manual fallback:

```bash
mkdir -p ~/.codex/skills
git clone git@github.com:carryons6/happiness-skill.git ~/.codex/skills/happiness
```

## Use

Invoke it directly:

```text
Use the happiness skill to plan how I should reproduce this paper with a coding agent.
```

Or rely on the skill description to trigger it when the task involves research reproduction, method development, pipeline building, or student training.

## Repository Layout

```text
.
├── .claude-plugin/
│   ├── plugin.json        # Claude Code plugin manifest
│   └── marketplace.json   # marketplace catalog for /plugin marketplace add
├── SKILL.md               # the skill (also a single-skill plugin at repo root)
├── agents/
│   └── openai.yaml        # Codex interface metadata
└── references/
    └── examples.md
```

## Validation

Validate the skill structure with:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```
