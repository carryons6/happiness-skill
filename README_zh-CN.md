# Happiness Skill

Happiness 是一个面向 AI 辅助科研编程的 Codex skill。它的目标是让研究者使用 coding agent 提高效率，同时不丢掉真正形成理解、判断力和研究 ownership 的关键部分。

[English README](README.md)

## 它解决什么问题

这个 skill 会在大规模生成代码之前，先把科研任务拆成三类：

- **agent-owned**：低价值、重复性、容易验证的工作，可以交给 agent 自动化。
- **co-created**：agent 可以提供草案和选项，但研究者必须做判断。
- **manual core**：研究者应该先亲自实现、推导、检查或决策的核心部分。

它不是反自动化。它的原则是：自动化低价值痛苦，保留高价值摩擦。

## 什么时候使用

适合在这些场景使用：

- 复现论文；
- 开发新的科研方法；
- 训练实验室学生合理使用 coding agent；
- 让 agent 实现科研代码；
- 判断哪些部分适合自动化，哪些部分应该由研究者亲自掌握。

## 首次使用校准

在当前对话中第一次处理实质性科研任务时，或者用户能力边界不清楚时，这个 skill 会先问一组简短问题，用来判断自动化边界。典型问题包括：

1. 用户在这个任务中的角色；
2. 是否已经亲自实现过核心算法、目标函数或实验协议；
3. 最希望保留哪一部分作为学习或研究 ownership；
4. 哪些部分可以让 agent 自由自动化；
5. 当前优先级是学习训练、快速复现、新方法探索，还是生产级研究基础设施。

回答会用于决定每个模块应该归为 agent-owned、co-created，还是 manual core。

## 安装

从这个仓库根目录安装：

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo carryons6/happiness-skill \
  --path . \
  --name happiness
```

安装后重启 Codex，让它重新发现这个 skill。

也可以手动安装：

```bash
mkdir -p ~/.codex/skills
git clone git@github.com:carryons6/happiness-skill.git ~/.codex/skills/happiness
```

## 使用方式

可以显式调用：

```text
Use $happiness to plan how I should reproduce this paper with a coding agent.
```

也可以让 Codex 根据 skill 描述自动触发，例如在论文复现、新方法开发、学生训练等任务中触发。

## 仓库结构

```text
.
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    └── examples.md
```

## 校验

用下面的命令校验 skill 结构：

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```
