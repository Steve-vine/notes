---
id: 01M4BDFNYKHG06NHZ9184A1P97
created: 2026-10-07T14:50:06.67581Z
updated: 2026-10-07T14:50:09.358779Z
type: task
title: Every access request has a reference — ACR-1, ACR-2… — shown first on the Requests list and wherever a request is named
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 857
sprint: sme8esk
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve, 2026-10-07: requests have no reference a person can say or write down. *"Use the format ACR-x, start at 1, add it as the first column in the request list and in the places you've suggested."*

## Why

A request is identified only by a long machine id — the one in the page address. Nobody can say "have you approved d0b25c70-be2e…?", so people describe requests instead ("the leaver for Arthur from this afternoon"), and where one request refers to another it quotes that id in full. Gaps, risks and assets already have a short reference; requests should too.

## What people see

- **Every access request has a reference: ACR-1, ACR-2, ACR-3…** Given when the request is raised, in order, and never changed, reused or renumbered — a cancelled or rejected request keeps its number.
- **Requests that already exist are numbered in the order they were raised**, the oldest being ACR-1.
- **Requests list:** *Reference* is the **first column**. It sorts in number order (ACR-9 before ACR-10), and typing a reference into the list's search finds it.
- **A request's own page:** the reference is in the header, beside the title.
- **Wherever one request names another**, it is by reference, as a link:
  - "Amends ACR-41" / "Amended by ACR-57" on the request page;
  - an amendment's default reason reads "Correction of ACR-41" instead of quoting the long id;
  - the validation note on the original reads "Amended and validated via corrective request ACR-57".
- **Wherever something else points at a request**, the link reads as its reference rather than "the request": the request that gave someone a role (role page ▸ Holders), the request behind an approved exception (the Exception marker on a membership), a to-do or action that opens a request, and the corrective request raised from a change made outside Compass.
- **Emails and notifications** about a request carry its reference in the subject or first line.

## What's permanent

The reference is fixed for the life of the request. The long id stays as it is underneath, and existing links to requests keep working.

## Decisions taken (say if any is wrong)

- **One run of numbers across all companies**, as gaps and risks have — a reference identifies one request, whichever company it belongs to.
- **Every kind of request shares the run** — joiners, movers, leavers, membership changes, group requests, and amendments. An amendment is a request in its own right and gets its own number.
- **No padding**: ACR-7, not ACR-0007.
- **The page address keeps the long id.** Opening a request by typing its reference into the address bar is not part of this; the list's search is the way to find one by reference.
- **Old text is not rewritten.** Reasons and notes already saved that quote a long id stay as they were written; only new ones use the reference.
- **Reports:** the reference is available as a column on reports about requests, and is in their default columns.

## Notes (technical)

- Follow the existing pattern exactly: `number: Mapped[int] = mapped_column(Integer, Sequence("gap_number_seq"), unique=True, index=True, nullable=False)` on `models/gap.py` (COM-645), likewise risks, data assets, software assets, containers. Add `access_requests.number` with `Sequence("access_request_number_seq")`.
- Migration: create the sequence; add the column nullable; backfill by `row_number() OVER (ORDER BY created_at, id)`; `setval` the sequence to the max; then `NOT NULL` + unique index + default `nextval`. CI migrates a fresh DB only — add an upgrade-path test with populated requests (the pattern in `tests/test_upgrade_path.py`), and confirm the count on staging in the PR. Revision id ≤ 32 chars. No f-strings in SQL (semgrep).
- API: `AccessRequestOut.number` (int) — format "ACR-n" in one place on the frontend (a `requestRef(number)` helper), not in the payload, the way gap references are formatted. Wherever the API returns only a request id for a link (`BusinessRoleHolderOut.request_id`, `MembershipProvenanceOut.request_id`, `ManualStepOut` / actions, `amends_request_id`, `amended_by_request_id`, `UnrequestedChange`'s corrective request), add the number beside it so the link can be labelled without a second fetch.
- Server-written text: `f"Correction of {original.id}"` (`api/v1/access_requests.py`, amend) and `f"Amended and validated via corrective request {request.id}"` (`tasks/access_execute.py`, `_finish`) — use the reference. Check `core/actions/access.py`, notification/email templates and audit summaries for other places a request is named.
- Requests list: `app/frontend/src/access/RequestsPage.tsx` — new first column with `SortableTh` (`{ kind: 'number', value: (r) => r.number }`, as `GapsPage.tsx` does: "G-9 before G-10"); add the reference to whatever the list's search matches. Screen conventions test: every table header needs `SortableTh` or a no-sort comment.
- Request page header: `RequestDetailPage.tsx`; the two `RequestLink`s there and the one in `RoleDetailPage.tsx`; `MembershipProvenanceBadge.tsx` (exception → request link); `ManualSteps` / Actions links.
- Reports: `reports/catalogue.py` — add the field to the access-requests dataset and its default columns.
- Regenerate `schema.d.ts`, run the drift script.
- Tests: numbers are given in order and never reused (including after a rejected/cancelled request); the backfill order; the list column, its sort and search; the header; each cross-reference; the amend texts.

## Done when

- A new request gets the next ACR number when raised; existing requests are numbered oldest-first from ACR-1.
- The Requests list shows Reference as its first column, sortable and searchable.
- The request page shows it in the header, and every place that names a request — amendments, role holders, exceptions, to-dos, corrective requests, emails — shows the reference.
- Smoke-tested on staging: raise a request, note its reference, find it by searching the list for it; amend one and check both ends of the link read as references.