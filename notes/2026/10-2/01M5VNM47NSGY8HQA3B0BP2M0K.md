---
id: 01M5VNM47NSGY8HQA3B0BP2M0K
created: 2026-10-26T08:35:53.717992Z
updated: 2026-10-26T08:36:42.667635Z
type: task
title: Polaris knows where you are — the status bar shows the page you're on, and on DDQ screens Polaris is told the questionnaire and question you're looking at
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1334
sprint: s9ls6e7
blocked_by:
- 01M5VNKW1CQETC1M8FB8GD096C
assignee: steve
label:
- feature
priority: high
task_status: todo
---
## Behaviour

- **The status bar** across the top of the Polaris window shows where you are, in the words on the screen:
  - the company, then the section and the record;
  - on a DDQ: **"Company One · DDQ-4 · Acme supplier questionnaire · Question 5a"**;
  - elsewhere: the section and page, for example "Company One · Posture ▸ Risks".
- **It updates as you move.** It follows the page and, on a DDQ, the question you have open.
- **Polaris is told what the bar shows** with each prompt. "Draft this one" or "why is this held back?" then means the question on screen, without you naming it.
  - On DDQ screens, Polaris also gets the DDQ's reference and the open question's reference, so it can go straight to them.
  - Elsewhere, it's told the section and page only this sprint. More screens become record-aware in later sprints.
- **The section you're on decides Polaris's core tools** (see the engine task). On a DDQ it has the DDQ tools to hand. It can still reach anything else your role allows.
- If you move to a different DDQ mid-conversation, Polaris is told on your next prompt. Earlier replies stay as they were.

## My calls (awaiting Steve)

- Only DDQ screens pass a record this sprint. Other screens pass their section and page.
- Context is sent with each prompt, not live as you click. Clicking around costs nothing.

## Notes

- **Independent** of migrations. Small API change: the turn request carries a `context` object (`company_id`, `section`, `page`, and optionally `ddq_id`/`question_id`). If that lands after the engine merges, it joins the chain and needs a schema.d.ts regen.
- Pages publish their context through a small React context provider. DDQ pages set it; `AppLayout` falls back to the route's section and title.
- Polaris gets the context as a short system note at the start of each turn, not as a fake user message.
