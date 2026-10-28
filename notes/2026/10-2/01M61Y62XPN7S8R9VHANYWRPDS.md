---
id: 01M61Y62XPN7S8R9VHANYWRPDS
created: 2026-10-28T19:00:57.398219Z
updated: 2026-10-28T22:56:51.476212Z
type: task
title: A risk names the controls it's an exception to — kept apart from the controls that reduce it, and a control's page lists the risks against it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1399
sprint: s81z16q
blocked_by:
- 01M61Y5M5CGZWG728MHQRVYV9R
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 94, Control Exceptions (ADR 0130, COM-1398). The foundation the rest of the sprint hangs off: today nothing records which control a risk is *against* — a risk only lists the controls that reduce it.

## What people see

- **The risk's page** gains an **Exception to** card above **Controls that reduce it**, which is renamed **Compensating controls** when the risk has an exception and stays as it is otherwise.
  - Add / remove controls, picked as the existing control picker does.
  - A control already on the other card can't be added (the picker greys it out, saying why).
  - An out-of-scope control can't be added: "ACC.8 is out of scope for <company> — it doesn't need an exception".
- **Activity:** "linked R-14 as an exception to control ACC.8", "removed …" — alongside the existing link lines.
- **The control** (Posture ▸ Assessments panel and the control's page) gains a **Risks** card: risks it's an exception to first, then risks it helps reduce, each with ref, title, status and residual. Today no screen shows a control's risks.
- **Risk register** gains a filter "Exception to a control".

## Who can do what

Same as linking a control to a risk today (risk writers). Anyone who can see the control sees its Risks card.

## Notes (technical)

- New link table beside `risk_control_links` (e.g. `risk_exception_controls`), soft-deletable, unique (risk, core_control), audited with summaries in `db/audit.py`. Or a `role` column on `risk_control_links` — pick whichever keeps the existing "mitigates" readers untouched; record which in the PR.
- Refuse a control on both links (409) and a control whose current assessment for the risk's company is out of scope (422).
- `GET /risks` gains `control=<id>` (either link, with which) and `exception_to=true`; the Risks card reads that.
- Risk-assessment approval's `_carry_links` still writes only "reduces" links.
- Regenerate schema.d.ts; MCP tools for these links come in the Polaris task.

**Chain:** on the chain (migration + API).

**Done when:** on staging, a risk can be made an exception to ACC.8, the control's Risks card shows it, and the refusals above hold.