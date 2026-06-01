# Happiness Skill

Happiness is a Codex skill for AI-assisted research coding. It helps researchers use coding agents without losing the parts of the work that create understanding, judgment, and ownership.

[中文说明](README_zh-CN.md)

## What It Does

This skill adds a research-agency guardrail before substantial coding work. It asks the agent to separate a task into:

- **agent-owned**: low-value, routine work that can be automated.
- **co-created**: work where the agent drafts options and the researcher decides.
- **manual core**: work the researcher should implement, derive, inspect, or decide first.

The goal is not to avoid automation. The goal is to automate low-value pain while preserving high-value friction.

## When To Use It

Use this skill when a user is:

- reproducing a paper,
- developing a new research method,
- training lab students to use coding agents responsibly,
- asking an agent to implement research code,
- deciding what should be automated and what should remain researcher-owned.

## First-Use Calibration

On the first substantial use in a conversation, or whenever the user's capability boundary is unclear, the skill asks a short calibration questionnaire before planning. Typical questions cover:

1. the user's role in the task,
2. whether they have implemented the core algorithm or objective before,
3. what they want to preserve for learning or research ownership,
4. what the agent may freely automate,
5. whether the priority is learning, fast reproduction, exploration, or infrastructure.

The answers are used to decide which modules should be agent-owned, co-created, or manual core.

## Install

From this repository root:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo carryons6/happiness-skill \
  --path . \
  --name happiness
```

Then restart Codex so it can discover the new skill.

Manual install is also possible:

```bash
mkdir -p ~/.codex/skills
git clone git@github.com:carryons6/happiness-skill.git ~/.codex/skills/happiness
```

## Use

Invoke it directly:

```text
Use $happiness to plan how I should reproduce this paper with a coding agent.
```

Or rely on the skill description to trigger it when the task involves research reproduction, method development, or student training.

## Repository Layout

```text
.
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    └── examples.md
```

## Validation

Validate the skill structure with:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```
