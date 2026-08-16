---
id: 01M05PTBWCRHQYM6Z932RR8HJA
created: 2026-08-16T16:35:00.108125Z
updated: 2026-08-16T16:35:03.953773Z
type: task
title: 'New Vendor request form: add contacts at request time'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 228
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The Contacts section (COM-214/221) joins the **New Vendor request form** so the requester can supply contacts up front — the request already creates the vendor at submission, so contacts land with it instead of being added after the fact.

- [ ] **Payload**: `contacts` array on the `new_vendor` request body — per entry: name (required), telephone, email, description, compliance flag; email validated as on the contacts API. Optional, empty allowed.
- [ ] **Backend**: `vendor_requests.submit` (kind `new_vendor`) creates the `vendor_contacts` rows alongside the vendor, in the same transaction (a half-submitted request still cannot exist). OpenAPI regenerated.
- [ ] **Frontend** (`RequestVendorModal` — shared by portal and internal Requests tab): a **Contacts** section — repeatable rows (Name, Telephone, Email, Description + Compliance checkbox), add/remove before submit. Sits after the engagement question set (COM-209 ordering unchanged).
- [ ] Contacts show on the Review surface via the vendor's Contacts card as normal (COM-224 renders the vendor read-only) — approvers see who was named.
- [ ] `new_engagement` / `amend_engagement` forms unchanged — contacts belong to the vendor, not the engagement.
- [ ] Tests: submission with/without contacts, validation, same-transaction atomicity, portal + internal both carry the section.