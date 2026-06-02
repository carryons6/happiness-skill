# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is a **single skill distributed to two agent platforms from one set of files**. There is no application code, build step, or test suite. The "product" is the prose in `SKILL.md`; everything else is packaging, distribution, and docs.

The skill ("Research Guardrail", frontmatter `name: research-guardrail`) is a guardrail for AI-assisted research and analytical work in any field: before writing substantial code it classifies each module on two axes — *learning value* and *correctness risk* — and attaches a runnable *verification gate* to silently-wrong code (units, index/axis conventions, joins, normalization, time handling).

## Architecture: one source, two consumers

The skill body is one source of truth, but it ships in **two byte-identical copies** because the Claude Code plugin and the Codex/personal-skill installs expect the file in different places:

- **`skills/research-guardrail/SKILL.md`** — what the **Claude Code plugin** loads. The plugin loader discovers skills from a `skills/<name>/SKILL.md` directory; a root-only `SKILL.md` is not reliably picked up (some Claude Code versions only scan `skills/`, which produced a "plugin contains no skill" report). `.claude-plugin/plugin.json` (manifest) + `.claude-plugin/marketplace.json` (catalog for `/plugin marketplace add`) complete the plugin.
- **`SKILL.md`** (repo root) — what the **Codex skill** and a **personal/project Claude skill** use, because those install the repo *as* the skill directory, so `SKILL.md` must sit at its root. Codex installs via `install.sh` (macOS/Linux) / `install.ps1` (Windows) into `$CODEX_HOME/skills/research-guardrail`; `agents/openai.yaml` carries Codex interface metadata.

`references/examples.md` holds worked examples the skill can draw on. `README.md` and `README_zh-CN.md` are the English/Chinese landing docs.

The practical consequence: a change to skill *behavior* means editing the SKILL.md body in **both** locations (`cp SKILL.md skills/research-guardrail/SKILL.md` after editing root), then propagating name/metadata to the platform-specific files that mirror it (see below).

## Load-bearing details when editing

- **`SKILL.md` frontmatter `description` is what controls triggering.** Both Claude Code and Codex match this `description` against the user's task to decide whether to invoke the skill — it is not just docs. The skill is deliberately configured **explicit-invocation only**: the description instructs agents not to auto-trigger, so it fires only when the user names it (`/research-guardrail`, `$research-guardrail`, or "use the research-guardrail skill"). If you change this trade-off, keep the body's "Invocation" note (in the Overview) and both READMEs' "Triggering" sections in sync. The description is also duplicated (in condensed form) in `plugin.json` and `marketplace.json`.
- **Two `SKILL.md` copies must stay byte-identical.** `skills/research-guardrail/SKILL.md` (Claude Code plugin) and root `SKILL.md` (Codex / personal-clone) are mirrors. After editing one, copy it to the other — otherwise the plugin and the Codex skill silently drift. Verify with `diff SKILL.md skills/research-guardrail/SKILL.md` (should print nothing).
- **The two-axis grid and the verification gate are the skill's core contract.** When editing `SKILL.md`, preserve the grid (learning value × correctness risk), the "flipped default" of delivering full code + an *understanding ledger* rather than withholding code, and the override rule (bypassing understanding is the user's call; bypassing correctness gates on result-poisoning code is not). Don't quietly soften these.
- **Version lives only in `.claude-plugin/plugin.json`** (`version` field). Git history bumps it in its own commit (e.g. "Bump plugin version to 0.0.3") after content changes. `marketplace.json` and `agents/openai.yaml` carry no version.
- **Keep `README.md` and `README_zh-CN.md` in sync.** They are translations of the same content; update both.
- **Installer URLs are hardcoded** to `carryons6/research-guardrail-skill` and the `main` branch in `install.sh` / `install.ps1`. They honor `CODEX_HOME` and `RESEARCH_GUARDRAIL_REF` overrides. If the repo slug or default branch ever changes, both scripts (and the README install snippets) must change together.

## Validation

There is no build or test. The only checks are structural validators:

```bash
# Claude Code plugin manifest
claude plugin validate .

# Codex skill structure (requires the Codex skill-creator helper to be installed)
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```
