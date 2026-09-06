---
id: 01M1VJWMEMARBAP8QQEQ4G4WXW
created: 2026-09-06T14:45:19.444436Z
updated: 2026-09-06T15:19:16.209194Z
type: task
title: 'the risk page reads in the order the work happens: what is wrong, what covers it, what was decided, what is planned'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 591
sprint: s2fcksg
comments:
- id: 01M1VMTPP4FEWJ9FP2WMQ8PHMW
  author: Steve Vine
  at: 2026-09-06T15:19:13.347855Z
  text: |-
    Done — PR #594 merged to main (6c74514).

    The risk page's cards now read: Details & scoring → Related gaps → Mitigating controls → Decisions → Treatment plans → Evidence files → History. Nothing inside any card changed.

    One thing the note assumed turned out not to hold: the "links a control in two steps" test clicked the first Link button on the page by position, so it broke when gaps moved above controls. It now finds the Link button after its own "Add control" field. A new test pins the section order by document position.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
The sections on a risk page are in the order they were built rather than the order somebody reads them. Reorder them so the page tells the story: what the risk is, what is wrong today, what covers it, what was decided about it, what is planned, the proof, then the trail.

| | Now | Wanted |
|---|---|---|
| 1 | Details & scoring | Details & scoring |
| 2 | **Mitigating controls** | **Related gaps** |
| 3 | **Related gaps** | **Mitigating controls** |
| 4 | Treatment plans | **Decisions** |
| 5 | **Decisions** | **Treatment plans** |
| 6 | Evidence files | Evidence files |
| 7 | History | History |

Two moves: swap the controls and gaps cards, and lift Decisions above Treatment plans.

## What is needed

- [ ] Reorder the six components in `RiskDetailPage`'s returned `Stack` (`DetailsCard`, `GapsCard`, `ControlsCard`, `LinkedDecisions`, `TreatmentsCard`, `EvidenceFilesCard`, `ActivityHistory`). Nothing inside any of them changes, and no props move with them.
- [ ] `RiskDetailPage.test.tsx` finds its sections by name rather than by position, so nothing there should need rewriting — confirm rather than assume.

The vendor links in the page header are not part of this; they sit beside the title, not in the card stack.

## Related

- COM-583 — one link card, not three. The component behind gaps, controls and decisions.
- COM-590 — the residual scoring fix, same page's Details & scoring card.
