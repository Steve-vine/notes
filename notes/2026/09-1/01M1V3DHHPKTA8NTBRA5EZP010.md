---
id: 01M1V3DHHPKTA8NTBRA5EZP010
created: 2026-09-06T10:14:56.310525Z
updated: 2026-09-06T10:14:59.774166Z
type: task
title: linking a record to a risk works three ways depending on the card
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 583
sprint: s2fcksg
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Raised by Steve, 2026-09-06: Mitigating controls and Related gaps link the same way, Decisions does not — is there a reason?

**No reason found.** Nothing in the code, the comments or the ADRs distinguishes them. The Decisions card is a shared component used on four pages and it simply grew up separately from the two that live only on the risk page.

They differ in three ways, not one:

| | Mitigating controls / Related gaps | Decisions |
|---|---|---|
| choosing | labelled field — *"Add control"* | placeholder only — *"Link a decision…"* |
| committing | pick, then press **Link** | links the moment you choose |
| removing | small **×** beside the row | red **Unlink** text |

## Make them the same, and make the two-step one the standard

Not a coin toss — the immediate-commit version has a real edge. There is no moment to change your mind, and in a searchable list a keyboard user commits whatever row happens to be highlighted when they press Enter. The consequence is mild (unlink it again) but on a risk record it means an audit trail with a link and an unlink in it that nobody meant. The labelled field is also better than a placeholder, which disappears the moment a value is chosen and leaves an unexplained box.

The cost is honest and worth stating: one extra click on the common action. That is the trade being made deliberately.

**Unlinking should settle on one affordance too** — the × and the red "Unlink" text are the same act in two costumes.

## Do it once, not three times

There are three implementations of "a list of linked records, with a way to add and remove one". Changing the Decisions card alone would leave two of the three aligned and the third still different the next time somebody adds a link card.

This should be **one component** taking the list, the options and the link/unlink actions — the same conclusion COM-578 reaches about decision editors and COM-579 about the risk scale. Three sessions of testing have now turned up the same shape of problem, which is worth noticing on its own.

Note that the Decisions card is used on **four** pages — risk, control, the assessment panel, and content — so this improves all of them, and any change must be checked on each rather than only on the risk page where it was reported.

## Related

- COM-578 — three editors for one decision record.
- COM-579 — three copies of the risk scale list.
