---
id: 01M0R40M85A82JB5JASP1P7DJF
created: 2026-08-23T20:11:56.549782Z
updated: 2026-08-25T15:07:47.065161Z
type: task
title: Mail contacts are dropped from group membership, so a contacts-only distribution list reads as empty
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 398
sprint: s5gwx0s
comments:
- id: 01M0WADKC91EZ88QSY4VEWSHZD
  author: Steve Vine
  at: 2026-08-25T11:20:50.825822Z
  text: |-
    Done — PR #401, merged to main as 705745d. (The task had no sprint set; put it in Sprint 34 with the other two.)

    Fixed rather than left alone, and on COM-386's shape exactly:

    - `directory_contacts` + `directory_group_contact_members`. Own edge table, so the governable surface cannot pick a contact up by accident — which matters more here than it did for devices: a contact is not a principal at all, so it can never be joined, moved, left or recertified.
    - Counted apart and never merged — "0 users · 3 contacts" — and the members sort uses the combined total, so a contacts-only list no longer sorts as empty either.
    - `/groups/{id}/contact-members`, the third sibling of `/members`, with the same direct/inherited split and via-group naming. Without it the modal would show a count with nothing behind it.
    - Deliberately **not** on the access graph: that canvas answers "who can reach what", and a contact reaches nothing. Stated in the code at the exclusion.
    - Read in full on every pass, delta included. Contacts are a handful beside 3,341 groups, so one paged read costs less than the bookkeeping that would avoid it, and it leaves no window where a new contact is missing from its list. A refused `/contacts` read is logged and the pass carries on with the contacts it already had — browse-only garnish must never put the mirror's correctness at risk.

    No new consent needed. ADR 0045 gained an amendment for the widened mirror scope.
assignee: steve
label:
- bug
priority: low
task_status: done
---
Found by a full reconciliation of the mirror against Graph (2026-08-23, all 3,341 live groups). It is the **only** genuine gap the reconciliation found.

The `$batch` edge crawl classifies member ids into users, groups and — since COM-386 — devices, and drops everything else. `orgContact` (Exchange mail contacts) falls in the bin, so a distribution list whose members are external contacts reads as having nobody in it.

Measured: **64 orgContact members across 35 groups**, of which **16 groups have no other members at all** and therefore show a bare zero.

This is the same shape of untruth COM-386 fixed for devices, with a much smaller blast radius: contacts only ever appear in distribution lists, which are browse-only inventory (COM-252) and outside the governable surface entirely. Nothing about the matrix, JML or recertification is affected — this is a screen telling a small lie, not a governance gap.

If it is worth fixing, the shape is COM-386's exactly:

- [ ] `directory_contacts` mirror table (display name, mail, `vanished_at`), plus a `directory_group_contact_members` edge reconciled each pass.
- [ ] Contacts counted **apart** from users and devices, as devices are: "0 users · 3 contacts", never merged.
- [ ] Browse-only, and stated in code at the exclusions: contacts are not principals and can never be a governed member.
- [ ] `Directory.Read.All` already covers `/contacts` — no new consent.

Worth weighing against doing nothing: 35 groups out of 3,341, all distribution lists. Recording it so the gap is known rather than rediscovered.

Refs: the reconciliation in this session, COM-386 (devices — the precedent), COM-252 (DLs are browse-only).