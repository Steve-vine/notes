---
id: 01M7B5SSXB4JB705V8MENY65S8
created: 2026-11-13T19:22:55.27524Z
updated: 2026-11-14T00:15:33.531014Z
type: task
title: 'Choose the fields a check keeps: every field listed, Polaris''s choice ticked, the person decides; the sample scrolls sideways; the sensitive-field flags go'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1804
sprint: spsp226
blocked_by:
- 01M7AKAHNNRFAAG07ZH7278E0K
comments:
- id: 01M7BPHJT498K2J12FHT4T7PAH
  author: Steve Vine
  at: 2026-11-14T00:15:31.651918Z
  text: |-
    Done — PR #1803 (auto-merge on). The migration (0846) sets the live checks' kept fields; the ADR 0142 and 0153 §5 amendments are appended.
    - The proposal card (Checks ▸ Review, and a control's "How Compass collects this") lists every field the sample returned, nested ones included, with Polaris's choice ticked. Buttons tick All, None or Polaris's choice. With nothing ticked, Approve is off ("Tick at least one field for the check to keep").
    - The sample table shows every field and scrolls sideways. Ticked columns come first and are highlighted; unticked ones are greyed.
    - A check keeps only its ticked fields from the first capture. The PDF's columns are those fields, in the order shown. With more than 12 fields, the PDF lists each item's fields in turn rather than one very wide table (a choice made here).
    - On a live check, the ⋯ menu has "Change the fields it keeps", which applies from the next capture.
    - The sensitive flags are gone from the card, the held review (just Confirm or Discard now) and Polaris's design prompt. Polaris returns the relevant fields, chosen as what an auditor needs. A field the service adds isn't kept and doesn't hold the capture; a ticked field going missing still holds it.
    - The live checks keep every field they kept before, minus anything left out. Their fields are listed by name, not the service's order, because that order was never stored. Until someone narrows them, their PDFs show every kept field, so a wide check uses the item-by-item layout.
    Points for Steve:
    - Asking Polaris to re-check a live check can still answer "something sensitive", and applying that verdict unticks those fields. That's outside this task.
    - The audit-pack copy still blanks email addresses and phone numbers (COM-1612).
    Unit suite, integration (including a migration upgrade test), lint, tsc and drift checks pass. Not yet seen in a browser; that's in the pre-UAT pass.
assignee: steve
label:
- feature
priority: high
task_status: review
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