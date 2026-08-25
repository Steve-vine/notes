---
id: 01M0XE6NEYM936EBGSGTEHYK2J
created: 2026-08-25T21:46:12.318847Z
updated: 2026-08-25T21:46:12.318847Z
type: task
title: Actions moves to Overview, and each row decides who may see it
company: moneypenny
assignee: steve
label: feature
task_status: todo
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 408
---
ADR 0055 §1. The first of four; everything else in the set builds on this.

Actions is filed under Company and gated on Company access, so a Vendor Admin
who runs the vendor register cannot open it, and a recertification reviewer —
who holds no module role by design (ADR 0047 §6) — cannot either. It is the
one page that should be universal, and it is one of the narrowest.

## What changes for the reader

**Actions moves to Overview, next to Dashboard**, and every internal user sees
it. What is *in* it is now decided per reader:

- **anything assigned to you**, whatever roles you hold;
- **everything in the modules your roles cover**, assigned or not.

A union, not a precedence. So a vendor owner with no internal role sees their
own follow-ups; a Vendor Admin sees every vendor row including ones nobody
owns; an admin sees the lot, as everywhere else.

Nothing else about the page changes yet — same five kinds of work, same
sorting, same filters. The sources come in COM-XXX (§3).

## Implementation

- `nav.ts`: move the Actions entry from `section: 'Company'` to
  `section: 'Overview'`. No `gate` override — Overview's section gate is
  `null`, so the entry is universal. (Reports is the contrast worth reading
  first: Overview section, but it keeps `gate: 'Company'` because its *rows*
  are all company data. Actions is the opposite case.)
- `api/v1/actions.py`: `list_actions` drops `require_company_read` for plain
  authentication. **The gate does not disappear — it moves into `_collect`**,
  which now takes the reader and filters per row. The API stays the boundary;
  the ungated nav entry hides nothing and is not asked to.
- Each of the five existing sources gains a module attribution, so rule two
  can be applied: gaps / treatments / control reviews → Company, content
  reviews → Library, vendor review actions → Vendors. This is the shape
  COM-XXX (§3) generalises into a declaration — do the minimum here and let
  that task refactor it.
- Rule one is `owner_id == user.id`. Rule two reads the reader's capability
  sets (`models/user.py`), not a list of role names.

## Watch for

`_collect` currently builds the whole list and filters in Python afterwards.
Per-reader filtering makes that worse, not better — it now runs on every
request for every user. Acceptable at current scale and called out in the
ADR's consequences, but push the module filter into the queries here if it is
cheap to do; do not leave it for the task that doubles the number of sources.

Tests: a `vendor_admin` sees vendor rows and no gaps; an owning `vendor_user`
sees their own follow-up and nothing else; a `viewer` sees Company rows; an
admin sees everything; an unauthenticated caller still gets 401.
