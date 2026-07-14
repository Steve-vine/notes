---
id: 01KXGTGYZYA9P8X8QHFW58NBPD
created: 2026-07-14T17:24:19.582436974Z
updated: 2026-07-14T17:24:19.582436974Z
type: task
title: Cascade domain identifier change to its control refs
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 87
---
M18 follow-up (builds on <issue id="ad6145fb-6d31-4729-b806-57be4594f7fb" href="https://linear.app/stevevine/issue/DEV-636/domain-identifier-code-auto-generated-control-refs">DEV-636</issue>). When a domain's **identifier (code)** changes, **rename all of that domain's control refs** to the new prefix, preserving the numeric suffix. E.g. changing Access Control `ACC → AAC` rewrites `ACC.17 → AAC.17`, etc.

### Why it's safe

Control `ref` is a display/URL identifier only — assessments, gaps, control-mappings, risk-links and content-links all FK to the control **UUID**, not the ref. So renaming refs breaks no references; it only updates what's shown and the `/controls/{ref}` deep-link.

### Backend (the work)

- [ ] In `PUT /domains/{slug}` (`update_domain`), when `code` changes: for **every** control in the domain (**including soft-deleted** ones, since `ref` is uniquely constrained across all rows), recompute `ref = {new_code}.{suffix}` where `suffix` = the part after the first `.` (partition on `.`; a ref with no dot → just `{new_code}`).
- [ ] **Collision guard**: before applying, check none of the new refs collide with a ref on a control **outside this domain** (incl. soft-deleted). On collision → 409 (shouldn't happen given code uniqueness, but a manual ref edit could). No transient-collision risk within the batch since old/new prefixes differ.
- [ ] Set `updated_by` on each renamed control (audited via the M18 allowlist → one "updated control" activity row each — correct).
- [ ] Do the rename in the same transaction as the domain update.

### Tests

- [ ] Changing a domain's code renames all its controls (`ACC.x → AAC.x`), suffixes preserved; non-numeric/edge suffixes handled.
- [ ] Soft-deleted controls in the domain are renamed too (so their refs don't block reuse).
- [ ] A no-op code change (same value) renames nothing.
- [ ] Controls in other domains are untouched.

### Frontend

- [ ] Domain edit (`DomainDetailPage`): note on the Identifier field that changing it **renames every control in the domain**. No other UI change needed (refs re-fetch).

Refs: ADR 0027, 0010, <issue id="ad6145fb-6d31-4729-b806-57be4594f7fb" href="https://linear.app/stevevine/issue/DEV-636/domain-identifier-code-auto-generated-control-refs">DEV-636</issue>.

---
*Migrated from Linear [DEV-644](https://linear.app/stevevine/issue/DEV-644/cascade-domain-identifier-change-to-its-control-refs) · created 2026-06-25 · completed 2026-06-25*  
*Related to (Linear): DEV-636*