---
id: 01M0R40M85A82JB5JASP1P7DJF
created: 2026-08-23T20:11:56.549782Z
updated: 2026-08-24T21:44:41.202437Z
type: task
title: Mail contacts are dropped from group membership, so a contacts-only distribution list reads as empty
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 398
sprint: s5gwx0s
assignee: steve
label:
- bug
priority: low
task_status: active
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