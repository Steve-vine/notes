---
id: 01M16G1KQ4CCD6TRMM321AYQEG
created: 2026-08-29T10:11:33.73208Z
updated: 2026-08-29T18:48:04.065541Z
type: task
title: Archiving a company actually freezes it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 505
sprint: s2fcksg
assignee: steve
company: null
label:
- bug
priority: high
task_status: active
---
**Reported:** a company set to Archived is still selectable from the company dropdown.

The dropdown is the visible symptom of a wider gap. `POST /companies/{id}/archive` (`api/v1/companies.py:115-131`) sets `companies.status = archived`, and **nothing else in the codebase reads that status**. Archiving today changes exactly two things: a grey badge and two disabled buttons on Admin ▸ Companies. The company stays in the switcher, stays selected if you were in it, still accepts writes, and still has background work run against it.

## What "archived" means

An archived company is **frozen**: preserved and readable, but nothing about it can change and nothing chases anyone about it.

### Out of sight
- Drops out of the company switcher (`CompanySwitcher.tsx`) and any other company picker.
- Still reachable read-only from Admin ▸ Companies, and by direct link, so an auditor can look back.
- `GET /api/v1/companies` (`companies.py:45-50`) has no filter at all today. Add one — but Admin needs archived rows, so this wants an explicit `status` / `include_archived` parameter rather than a blanket filter, and the switcher asks for active only.

### Nothing writable
- Company-scoped write endpoints reject changes to an archived company. Every one currently does `db.get(Company, ...)` and 404s only if missing (`vendors.py:232`, `assessments.py:62`, `coverage.py:109`, `business_roles.py:186`, `assessment_rule_sets.py:166`, `vendor_flags.py:64`, `vendor_forms.py:69`, `core/vendor_requests.py:222-225`). This wants a shared dependency/guard rather than a check per endpoint.
- Admin ▸ Companies currently leaves **Edit** enabled for an archived company (`CompaniesSection.tsx:84-99` disables Set default and Archive but not Edit) — rename/re-slug should go too.

### If you're in it when it's archived
Selection lives in `localStorage` only (`CompanyProvider.tsx`, key `compass.companyId`) and resolves *stored id → default → first alphabetically* with no status check. Add the status check so an archived selection falls through to the default company on next load, with a brief notice saying why.

### Background work stops
There is **no per-company sync** — the Entra/Graph directory sync is one tenant-wide job on a global singleton connection, so it neither can nor should stop. What stops is the *company-attributed* work, all of which runs against archived companies today:

| Work | Where |
|---|---|
| Daily coverage snapshots — the only per-company fan-out on the schedule, `for company_id in select(Company.id)` with no filter | `core/coverage_proposals.py:406-427`, called from `tasks/directory_sync.py:1530` |
| Attributing out-of-band directory changes to the company's business roles | `tasks/directory_sync.py:1631` (`_managed_groups_by_company`) |
| Recertification schedules firing | `tasks/recert.py:484` |
| Nightly vendor review-status flips, vendor assessment auto-close | `tasks/lifecycle.py:116` |
| The company's items appearing in anyone's hourly reminder email | `tasks/reminders.py:38` → `core/mail_digest.py:274-292` (per-reader, so filter the actions, not the recipients) |

### In flight at the moment of archiving — freeze, chase nobody
Decided: outstanding vendor questionnaires, recertification campaigns and access requests stay exactly as they are, visible read-only. Nothing is withdrawn or auto-closed and no reminders go out. Vendor portal links keep working; closing those off was considered and deliberately not done.

## Not in scope
Restore and delete are separate tasks in this sprint.

## Tests
`tests/test_companies.py:128-134` is the only archive test and asserts nothing about visibility. Cover: archived company absent from the default list and present with the explicit flag; a write to an archived company refused; a selected-then-archived company falling back to default; the coverage snapshot skipping archived companies.
