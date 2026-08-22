---
id: 01M0N5M16F87VAZE8SZT4HGFCD
created: 2026-08-22T16:42:17.679484Z
updated: 2026-08-22T16:42:17.679484Z
type: task
title: One Start button for the batch — all pending assessments open together, one link sent
label: improvement
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 365
---
COM-358 shipped Start as a per-assessment action, so a vendor with several assigned assessments means several modals and several emails to the same contacts. Change it: **one Start button** on the vendor's Assessments tab that opens **all pending assessments together** and sends **a single link** to complete them.

- [ ] The per-row Start buttons go; a single **Start Assessments** button (tab-level) is enabled while the vendor has ≥1 `pending` assessment. The modal is unchanged in shape — compliance contacts ticked by default, one **valid until** (default +2 weeks) — but it lists the assessments it is about to open, and the chosen date applies to **all of them** (they were sent as one ask; they expire as one).
- [ ] On Start: every pending assessment goes `pending → open` with the shared `valid_until`, in one transaction; per-contact tokens (re)generated once as today. The access model already makes the single link natural — one portal destination per vendor — so the contact email becomes **one email, one link, listing the assessments** to complete; the owner email likewise lists the batch.
- [ ] Later additions: an assessment assigned *after* a batch is already open sits `pending` and the Start button reappears for it — starting it re-uses the modal (its own valid-until this time), regenerates the ticked contacts' tokens per the existing rule, and the email says what's newly asked; the portal simply shows the newly opened one alongside the rest.
- [ ] Per-assessment machinery is untouched: individual % complete, individual Close (COM-359), individual expiry handling — only *starting* is batched. Since the batch shares one date they will normally expire together, but the invariants must not assume it.
- [ ] Decide in review: is "start all pending" always right, or does the modal want per-assessment checkboxes (ticked by default) for the rare partial send? Cheap to add while the modal lists them anyway — recommend the checkboxes.
- [ ] Tests: batch start opens all pending with one shared date, one email per contact naming every assessment, one owner email; a later single start leaves open ones untouched; tokens regenerated not duplicated; zero-pending hides/disables the button.