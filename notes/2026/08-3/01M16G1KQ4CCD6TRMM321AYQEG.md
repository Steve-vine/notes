---
id: 01M16G1KQ4CCD6TRMM321AYQEG
created: 2026-08-29T10:11:33.73208Z
updated: 2026-08-30T06:57:54.771511Z
type: task
title: Archiving a company actually freezes it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 505
sprint: s2fcksg
comments:
- id: 01M17F636CZ1HR882QN167RRQQ
  author: Steve Vine
  at: 2026-08-29T19:15:46.508747Z
  text: |-
    Done — PR #523, merged to main as 175925a.

    An archived company is frozen now: preserved and readable, but nothing about it can change and nothing chases anyone about it.

    Out of sight. GET /companies defaults to active only with an explicit include_archived flag, and Admin ▸ Companies is the one caller that asks for archived rows. Worth noting the switcher needed no status check of its own — it takes the default, and CompanyProvider's stored-id → default → first resolution then falls back for free. It does say why, though: being moved out of the company you were working in, silently, reads as a bug. Telling "archived" apart from any other stale id needs a lookup (an archived company is still readable by id), which is what the notice is gated on.

    Nothing writable. One guard, core/company_access.require_writable_company, called from the write paths — vendors, risks, assessments, business roles, rule sets, vendor flags/forms, approval areas, compliance rules, access requests, all four recert writes, framework carry-forward and scope, portal branding, requirement applicability, vendor request submission. Deliberately not a route dependency or a blanket filter: the same endpoint modules serve reads, and reads stay open, which is the whole point of preserving the company. Rename and re-slug went with the rest, and Edit is disabled to match.

    409 rather than 403, and it is worth being explicit about why: nothing is wrong with the caller's permissions and nothing is wrong with the request — it is the state of the company that conflicts, and restoring it makes the identical call succeed. That reads correctly to a caller and sets COM-506 up properly.

    Background work stops: coverage snapshots, out-of-band attribution to business roles, recert schedules firing, the nightly vendor cadence expiry, and the company's items in anyone's reminder mail. The mail is filtered on the actions rather than the recipients — someone with work in two companies should still hear about the live one. The in-app actions queue is deliberately left alone: reading an archived company is the point of preserving it, and it is the mail that does the chasing. The Entra/Graph mirror is untouched, as the ticket says it should be.

    One decision taken that COM-506 had listed as open: a recert schedule falling due while its company is archived is skipped, not queued. The dedupe key is (schedule, period), so restoring resumes from the next occurrence rather than firing a backlog at whoever owns it. That decision belongs this side of the switch, so it is made here.

    Verified against the full integration suite (1376) and the full frontend suite — that is what says the guard refuses the archived case and nothing else.

    COM-506 and COM-507 unblocked. Ready for smoke test on staging.
assignee: steve
company: null
label:
- bug
priority: high
task_status: done
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
