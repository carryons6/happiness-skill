# Research Guardrail Skill

[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-D97757)](https://claude.com/claude-code)
[![Codex](https://img.shields.io/badge/Codex-skill-412991)](https://openai.com/codex)

Research Guardrail 是一个面向 AI 辅助科研编程的 skill。它的目标是让研究者用 coding agent 提效，同时不丢掉真正形成理解、判断力和研究 ownership 的关键部分——也不让看似合理、其实静默错误的代码悄悄污染科学结论。

它适用于各类科研与数据/科学计算编程——机器学习、数据分析、仿真模拟、统计、计算科学等等。

[English README](README.md)

## 安装

### Claude Code

**作为 plugin 安装（推荐）**——仓库自带一个 plugin marketplace，可以直接用 `/plugin` 安装：

```text
/plugin marketplace add carryons6/research-guardrail-skill
/plugin install research-guardrail@research-guardrail-skill
```

**作为个人 skill**——克隆到你的 skills 目录：

```bash
git clone https://github.com/carryons6/research-guardrail-skill.git ~/.claude/skills/research-guardrail
```

或作为项目 skill，把它放到仓库的 `.claude/skills/research-guardrail/` 下。Claude Code 会根据 `SKILL.md` 的 frontmatter 自动发现这个 skill。

### Codex

**一键安装（推荐）**——一行命令，安装到 `~/.codex/skills/research-guardrail`。重复执行即可更新。

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/carryons6/research-guardrail-skill/main/install.sh | bash
```

Windows（PowerShell）：

```powershell
iwr -useb https://raw.githubusercontent.com/carryons6/research-guardrail-skill/main/install.ps1 | iex
```

安装后重启 Codex，让它重新发现这个 skill。脚本支持用 `CODEX_HOME` 和 `RESEARCH_GUARDRAIL_REF`（分支/标签）环境变量覆盖默认值。

**其他方式**

内置 skill installer：

```text
Use $skill-installer to install the skill from https://github.com/carryons6/research-guardrail-skill.
Use path "." and install it as "research-guardrail".
```

手动克隆：

```bash
mkdir -p ~/.codex/skills
git clone https://github.com/carryons6/research-guardrail-skill.git ~/.codex/skills/research-guardrail
```

## 如何触发

这个 skill **只在显式调用时触发**——即使任务看起来像复现论文、开发新方法或构建流水线，它也不会自行触发。需要时按名字唤起：

- **Claude Code**：运行 `/research-guardrail` 斜杠命令，或直接用自然语言，例如 *“用 research-guardrail skill 帮我规划这篇论文的复现。”*
- **Codex**：`$research-guardrail`。

在你调用它之后第一次处理实质性任务时，skill 会先跑一轮简短的[首次校准](#首次使用校准)（3–5 个问题），再给出方案。

## 它解决什么问题

这个 skill 会在大规模生成代码之前，先加上一层科研 agency 护栏。它防范 AI 辅助科研出错的两种不同方式：

- **失去理解**：agent 把有意思的部分做了，研究者没建立起直觉。
- **失去信任**：agent 写了看似合理、其实静默错误的代码，结论被污染。

为同时应对这两点，它在写实质性代码之前，把每个模块按**两个维度**分类：

- **学习价值**：亲手掌握它，能否建立研究直觉？
- **正确性风险**：这里的静默 bug 会不会逃过 review、污染结果？

|  | 低正确性风险 | 高正确性风险 |
|---|---|---|
| **高学习价值** | **manual core**——亲自掌握以理解 | **manual core + 硬验证**——既亲自做，*又*证明它是对的 |
| **低学习价值** | **agent-owned**——放心自动化 | **agent-drafted + 验证门**——让 agent 写，但绝不盲信 |

`co-created`（agent 提供选项、研究者做判断）仍然作为一个标签保留，用于那些既有一定启发性、又有后果的设计选择。

它不是反自动化。原则是：自动化低价值痛苦，保留高价值摩擦，并给那些「看着没问题、其实静默错误」的危险代码挂上**验证门**。

## 验证门（Verification Gate）

对任何高风险代码（单位与量纲、索引/轴约定、数据连接与对齐、归一化、时间处理），skill 会附上一个具体、可运行、能抓出静默错误的检查——而不是一句「小心点」。例如：

- **索引与轴约定**——把已知元素经变换做往返，断言它落在预期位置；或在已知位置注入已知值，确认其落点。
- **数据连接与对齐**——对照干净子集检查行数与匹配完整度。
- **时间与时区处理**——把已知时间戳来回转换，与独立参考比对。

如果某段高风险代码说不出对应的验证门，skill 会明确指出——这本身就是警告。

## 什么时候使用

适合在这些场景使用：

- 复现论文；
- 开发新的科研方法；
- 构建或调试分析流水线；
- 训练实验室学生合理使用 coding agent；
- 判断哪些部分交给 agent 自动化、哪些应该亲手实现并验证。

即使只是一个「快速实现」，只要做错可能悄悄污染科学结果，也值得显式调用它。

## 首次使用校准

在当前对话中第一次处理实质性科研任务时，或者用户能力边界不清楚时，这个 skill 会先问一组简短问题，用来判断自动化边界。典型问题包括：

1. 用户在这个任务中的角色；
2. 是否已经亲自实现过核心算法、目标函数或实验协议；
3. 最希望保留哪一部分作为学习或研究 ownership；
4. 哪些部分可以让 agent 自由自动化；
5. 当前优先级是学习训练、快速复现、新方法探索，还是生产级研究基础设施。

回答会调整这张网格——之前接触越少，manual core 和检查点越多；经验越强，agent-owned 和 co-created 的部分越多；无论哪种，危险代码上的验证门都保留。

## Manual-core 交付方式

默认情况下，skill 会交付**完整可用的实现 + 一份「理解账本」（understanding ledger）**——简短列出你「读代码而非亲手写」所跳过的洞见——而不是藏着代码不给。Scaffold-only 模式（只给函数签名 + 待填 TODO，由你实现核心）作为备选，在明确的学习/训练场景下默认采用。

## 仓库结构

```text
.
├── .claude-plugin/
│   ├── plugin.json        # Claude Code 插件清单
│   └── marketplace.json   # marketplace 目录，供 /plugin marketplace add 使用
├── SKILL.md               # 技能本体（在仓库根目录同时作为单技能插件）
├── install.sh             # Codex 一键安装脚本（macOS / Linux）
├── install.ps1            # Codex 一键安装脚本（Windows）
├── agents/
│   └── openai.yaml        # Codex 界面元数据
└── references/
    └── examples.md
```

## 校验

校验 Claude Code 插件清单：

```bash
claude plugin validate .
```

校验 Codex skill 结构：

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```
