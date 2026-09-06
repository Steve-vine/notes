---
id: 01M1V0Q49GB6K4WGSWMMH9ZE4Q
created: 2026-09-06T09:27:44.688324Z
updated: 2026-09-06T11:34:23.852613Z
type: task
title: writing a decision should be the same job whether it is new or not
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 578
sprint: s2fcksg
assignee: steve
label:
- improvement
priority: medium
task_status: active
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
