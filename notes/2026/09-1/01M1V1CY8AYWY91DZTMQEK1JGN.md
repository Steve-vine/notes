---
id: 01M1V1CY8AYWY91DZTMQEK1JGN
created: 2026-09-06T09:39:39.402488Z
updated: 2026-09-06T09:39:45.893201Z
type: task
title: scoring a risk shows the scale, not just the number
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 579
sprint: s2fcksg
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Raised by Steve, 2026-09-06.

Creating or editing a risk asks for likelihood and impact and offers **1, 2, 3, 4, 5**. Nothing else. The person scoring has to already know what a 3 means, or go and look it up, which nobody does — so the numbers get chosen by feel and the rubric stops governing the scores it exists to govern.

**The words are already there.** The scale is org-wide reference data (ADR 0012/0018), maintained in Admin → Rubrics, and it reads exactly as Steve wrote it:

| | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| **Likelihood** | Rare | Unlikely | Possible | Likely | Almost certain |
| **Impact** | Insignificant | Minor | Moderate | Major | Severe |

— each with a descriptor: *"Would only occur in exceptional circumstances."* The rubric somebody maintains is invisible at the one moment it matters, which is while a score is being chosen.

## What changes

- **In the list, the whole thing**: `1 - Rare: Would only occur in exceptional circumstances`.
- **Once chosen, just the name**: `1 - Rare`. Mantine supports this directly — the option's label carries the short form and a custom option renderer draws the descriptor beneath it — so the closed box stays narrow and the picker stays readable.
- **Likelihood and impact are different scales.** They are stored per dimension and read differently ("Rare" against "Insignificant"), so each box takes its own list. Today both use one shared 1–5 constant, which is the thing to remove.
- **From the API, never a constant.** The rubric is admin-editable; rename a level and the picker follows. If the scale comes back empty or the call fails, fall back to bare numbers — scoring a risk must not be blocked by a rubric that will not load.

## Three copies, not one

The hardcoded 1–5 list exists in **three** files: the risks list's create dialog, the risk detail page, and **vendor detail**, where a vendor's risk is scored the same way. Steve reported the first two; the third has the identical problem and should not be left as the last place showing bare numbers. One shared picker component, used in all three.

## Related

- The assessment panel already does this for **maturity** — it shows the chosen level's definition — so the app has a house pattern for putting rubric text at the point of scoring. This goes one better by showing every option's text while you are choosing, which is when you are comparing them. Worth asking afterwards whether maturity should adopt the same shape; not folded in here, since COM-568 is already touching that field.
- While in the file: the heat-map's axes are bare numbers too. Out of scope, but the same words would help there.
