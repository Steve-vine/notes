---
id: 01M05PTBWCRHQYM6Z932RR8HJA
created: 2026-08-16T16:35:00.108125Z
updated: 2026-08-16T17:22:01.891809Z
type: task
title: 'New Vendor request form: add contacts at request time'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 228
sprint: sbph5q5
comments:
- id: 01M05SGFH3EB6VKN9ZKR81VTCQ
  author: Steve Vine
  at: 2026-08-16T17:22:01.89166Z
  text: |-
    Shipped as PR #228 (branch feature/com-228-request-contacts) — awaiting CI.

    **Payload:** `contacts` array on the `new_vendor` request body, reusing `VendorContactCreate` so a contact means one thing however it arrives (EmailStr check included). Optional; explicit `[]` means the same as omitting it. `VendorContactCreate` moved above the request schemas in `schemas.py` — a Pydantic model cannot reference one declared after it — with a note saying why it sits apart from its Update/Out siblings.

    **Backend:** rows written inside the existing submit transaction alongside the vendor, so a half-submitted request still cannot exist. Refused (422) rather than ignored on `new_engagement` / `amend_engagement`: contacts belong to the vendor, and accepting-then-dropping would look like it worked.

    **Frontend:** Contacts section after the engagement question set (COM-209 ordering otherwise untouched) — repeatable rows, Name / Telephone / Email / Description / Compliance, add and remove before submit. Shared by portal and internal Requests tab, as the modal already was. A row added and left blank is an accident rather than an instruction, so it is dropped instead of failing the submission.

    **⚠️ Scope I added — an ordering bug this uncovered, and a migration.** COM-219 ordered the contacts card by `created_at, id` ("insertion order"). That held only while contacts were created one at a time, each in its own transaction: `created_at` defaults to `now()`, which in Postgres is the *transaction* timestamp, so a batch written together shares one value and the random-UUID tiebreaker decides the order — type Ada then Sam, get Sam then Ada. The first portal test I wrote caught it.

    Fixed at the root: **migration 0058** adds an explicit `position` (the `approval_areas` / `vendor_form_questions` pattern already in the codebase), backfilled from the current order so no existing card reorders on upgrade; both create endpoints append to the end. The alternative was to let the feature scramble the requester's input, or to weaken COM-219's guarantee to "stable but arbitrary within a batch" — flagged on the PR in case you'd prefer the smaller change.

    **Tests:** backend — with/without contacts (incl. explicit `[]`), field mapping and insertion order, EmailStr + name validation, refusal on the other kinds with nothing written on the way, **atomicity** (fan-out patched to raise *after* the contacts are added; no vendor and no contacts survive), the portal door end to end, and COM-219's one-at-a-time guarantee still holding through a compliance toggle. Frontend — typed contacts reach the API in the right shape, an abandoned blank row and a removed row do not, and a contact-less request sends `[]`.

    Full suites green locally: 422 backend integration + 95 unit, 310 frontend.
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The Contacts section (COM-214/221) joins the **New Vendor request form** so the requester can supply contacts up front — the request already creates the vendor at submission, so contacts land with it instead of being added after the fact.

- [ ] **Payload**: `contacts` array on the `new_vendor` request body — per entry: name (required), telephone, email, description, compliance flag; email validated as on the contacts API. Optional, empty allowed.
- [ ] **Backend**: `vendor_requests.submit` (kind `new_vendor`) creates the `vendor_contacts` rows alongside the vendor, in the same transaction (a half-submitted request still cannot exist). OpenAPI regenerated.
- [ ] **Frontend** (`RequestVendorModal` — shared by portal and internal Requests tab): a **Contacts** section — repeatable rows (Name, Telephone, Email, Description + Compliance checkbox), add/remove before submit. Sits after the engagement question set (COM-209 ordering unchanged).
- [ ] Contacts show on the Review surface via the vendor's Contacts card as normal (COM-224 renders the vendor read-only) — approvers see who was named.
- [ ] `new_engagement` / `amend_engagement` forms unchanged — contacts belong to the vendor, not the engagement.
- [ ] Tests: submission with/without contacts, validation, same-transaction atomicity, portal + internal both carry the section.