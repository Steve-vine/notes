---
id: 01M7B5SSXB4JB705V8MENY65S8
created: 2026-11-13T19:22:55.27524Z
updated: 2026-11-13T19:22:55.27524Z
type: task
title: 'Choose the fields a check keeps: every field listed, Polaris''s choice ticked, the person decides; the sample scrolls sideways; the sensitive-field flags go'
label: feature
task_status: todo
assignee: steve
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1804
---
Steve, 2026-11-13. Today the review card only offers **Leave out** tick boxes for fields Polaris or Compass think may be sensitive. Those flags are mostly wrong, and you can't see or choose the rest of the fields.

## What people see

- The card lists **every field** the sample returned, including nested ones (e.g. `approvals[].approver.name`). **Polaris's choice of relevant fields is ticked.** The person ticks or unticks any of them, and there's All / None / Polaris's choice.
- The **sample table shows every field and scrolls left and right**. Ticked columns come first and are highlighted. Unticked ones are greyed, so you can see what you'd be dropping.
- **The check keeps only the ticked fields**, from the first capture on. The readable page (PDF) shows those fields as its columns, in the order shown, instead of the first 10 fields the service happens to return. This fixes the CHM.1 page showing IDs rather than approval, risk and type.
- The same field list is on a live check's settings (Change), so fields can be added or dropped later. A change applies from the next capture.
- **The sensitive-field flags go**: no highlighting, no "may be sensitive" text, and nothing in Polaris's design asks for them.

## Decisions (made, say if wrong)

- Polaris's design now returns the **relevant fields** for each check instead of the sensitive ones. It's told to pick what an auditor would need to see the control operating.
- A field the service adds later isn't kept and doesn't hold the capture. A **ticked** field going missing still holds it for review.
- The eight live Moneypenny checks start with every field ticked except what was left out, so nothing they keep changes until someone edits them.

## Done when

- The card shows the full field list with Polaris's choice ticked, and the sample scrolls horizontally with every field.
- Approving keeps only the ticked fields, and the PDF's columns are those fields.
- A live check's fields can be changed.
- The sensitive flags are gone from the screen, the design prompt and the hold rule.
- Tests cover the kept fields, the PDF columns, holding on a missing ticked field and not on a new unticked one.

**On the chain** (API: kept fields on a proposal and a check). After COM-1795.