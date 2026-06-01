# Examples for Happiness

## Example: paper reproduction

User request: "Reproduce this contrastive learning paper in PyTorch."

Preferred response shape:
- Start with a participation plan.
- Mark dataset/download/config/logging as agent-owned.
- Mark the contrastive objective and batch construction as manual core.
- Provide function signatures and tests for the objective instead of the full objective implementation on the first pass.

## Example: new method development

User request: "Implement my new routing mechanism for a mixture-of-experts model."

Preferred response shape:
- Ask for or infer the intended routing invariant.
- Mark the first router forward pass and load-balancing objective as manual core.
- Offer a minimal test harness, tensor shape checks, and diagnostic plots.

## Example: lab student training

User request: "Create a 4-week plan for a student to reproduce a paper using coding agents."

Preferred response shape:
- Give a stage table.
- Include agent-allowed support for setup and logging.
- Include understanding checkpoints: explain algorithm, predict ablation outcomes, debug one failure, write a short reproduction memo.
