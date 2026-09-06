---
id: 01M1V0Q49GB6K4WGSWMMH9ZE4Q
created: 2026-09-06T09:27:44.688324Z
updated: 2026-09-06T14:21:53.849486Z
type: task
title: writing a decision should be the same job whether it is new or not
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 578
sprint: s2fcksg
comments:
- id: 01M1V8YTARGXGKJ8X8F1SA8KFB
  author: Steve Vine
  at: 2026-09-06T11:51:45.240032Z
  text: |-
    Done — PR #586, merged to main as bfbd6c8.

    One editor, three entry points. `DecisionEditor` (two columns, monospace source, live preview) is now the only place a decision is written, reached at `/decisions/new` for a new one. Supersede routes to the same address with `?supersedes=<number>` rather than keeping a third copy, and gains the status and decided-on fields it never had. Edit renders the same component in place.

    Went with the screen rather than a large modal, for the reason in the task: the point is not two editors that resemble each other but one editor. Both modals are gone.

    One deliberate exception to "every entry point offers whatever the editor offers": `supersedes` appears while creating and is absent while editing, because a supersession is recorded when the superseding ADR is written and `DecisionUpdate` does not accept it. Present-and-ignored would have been worse.

    New `NewDecisionPage.test.tsx` covers writing and creating in the full editor, the preview rendering as you type, superseding from the same editor (accepted by default, still a picker), the status and decided-on Supersede used to omit, an empty title refused, and a junk `?supersedes=` ignored. The two tests that drove the removed modals now assert the entry points are links to the shared editor.

    Frontend only — no API change, no migration.

    Worth noting for later, out of scope here: the status picker shows raw lowercase values (`proposed`, `accepted`) on both the editor and the Decisions filter. Cosmetic, and pre-existing.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Raised by Steve, 2026-09-06.

A decision is a piece of writing — a Markdown document explaining why something was decided. The app offers **three different places to write one, and they are not the same**:

| | body box | preview | monospace | fields |
|---|---|---|---|---|
| **New decision** (modal) | 4 rows | none | no | title, status, decided on, supersedes, body |
| **Edit** (full page) | 12 rows, two columns | live | yes | title, status, decided on, body |
| **Supersede this** (modal) | 4 rows | none | no | title, body only |

Steve's point stands on its own: a four-row box with no preview, in a dialog, is not somewhere anybody writes an ADR. So they do not — **they type a title, save a stub, and go and edit it properly**. The tool has taught them a workaround.

The third surface is one he has not raised: **Supersede this** has the same cramped box, and it is the one where writing matters most. Superseding an accepted decision is the act ADR governance exists for, and it is offered in the weakest editor of the three — and without the status or decided-on fields the other two have.

**Decisions are audited** (`decision_records`), so the stub-then-edit habit also puts a create-with-nothing-in-it followed by an edit into the trail, on the one record type whose reason for existing is explaining a decision.

## What changes

Steve offered two shapes — a large modal with the edit screen's capability, or creating on the screen rather than in a modal. **The second, and for a specific reason: the point is not two editors that resemble each other, it is one editor.** Two components tuned to match today drift apart the next time either is touched — which is how three of them came to exist.

So: the editor that the edit screen already renders — two columns, monospace source, live preview — becomes a component, reached at its own address for a new decision. **Supersede routes to the same place**, pre-filled with what it supersedes, rather than keeping a third copy. One editor, three entry points.

The fields follow from that: whatever the editor offers, every entry point offers, which settles the inconsistency in the table above without anyone maintaining a list.

**If the modal is preferred after all**, it has to host that same shared component rather than reimplement it, and it needs to be genuinely large — a two-column Markdown editor is cramped even at the widest standard dialog size, which is most of why the current one is being avoided.

## Related

- ADR 0016 / the decisions module — these are the app's own decision records, authored in-app, distinct from the repo's ADRs.
