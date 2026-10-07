---
id: 01M488RWD3E1MHCWRFZY3T8CC9
created: 2026-10-06T09:30:02.019075Z
updated: 2026-10-07T16:35:45.235429Z
type: task
title: A request's status says how the job is going — "Pending validation" becomes a second pill beside it, and "Validated" goes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 847
sprint: sme8esk
comments:
- id: 01M48ES6QBV8F267VXAZDSRZ5Q
  author: Steve Vine
  at: 2026-10-06T11:15:04.043284Z
  text: |-
    Merged to main — PR #845 (2026-10-06). ADR 0087 written.

    What people see now:
    - The Status pill is the state of the job. An expedited request that has run reads Executed (or Waiting for Entra / Waiting on manual steps / Delete pending) with a separate "Pending validation" pill beside it. Once validated the second pill goes and nothing replaces it — no Validated or Amended pill.
    - "Waiting for Entra" is a new state: a hybrid joiner whose account is in AD and whose mailbox access and cloud groups follow once it reaches Entra. It flips to Executed by itself, and the request page says so in a line under the header.
    - The list, the request page and the request opened in place draw the same pills.
    - Status chips are job states only (Validated/Amended gone, Waiting for Entra added). Pending validation is its own chip beside them, and the two combine. Old addresses still work: ?status=validated|amended lands on Executed, ?status=pending_validation turns the new filter on.

    Technical:
    - display_status() derives pending_validation/validated/amended as an executed request; order delete_pending → awaiting_manual → awaiting_entra → executed. New validation_pending boolean on the request. Lifecycle status and transitions untouched; the list endpoint's status= filter still filters the lifecycle value.
    - One behaviour note: an amended request with a deletion still ahead now reads Delete pending (it used to fall through to "Amended").
    - Nothing outside the access screens read display_status (reports, exports, Actions queue, emails all use the lifecycle status) — checked, nothing to repoint.
    - Request page header: now shows the derived state like the list does, so a scheduled request's header reads Scheduled (was Approved) and one with a deletion ahead reads Delete pending (was Executed).
    - Colour for Waiting for Entra: cyan.

    Tests: 48 derivation cases (every lifecycle value × each override, precedence, validation_pending); the hybrid joiner end to end (awaiting_entra on the request and the list, executed after the sweep); the list (two pills, chips and counts, filter combinations, sort, old addresses) and the request page header.

    Left for the smoke test: an expedited hybrid joiner on staging — Waiting for Entra · Pending validation → Executed · Pending validation → Executed.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Asked for by Steve, 2026-10-06, while testing the joiner process.

## Why

The Status column on the request list answers two different questions with one pill, and for an expedited request the wrong one wins:

- **Is the work done?** — executing, waiting on something, executed, failed.
- **Has someone checked it afterwards?** — pending validation, validated.

An expedited request reads **Pending validation** from the moment it has run, whether the job is fully complete, half done (the account is made and waiting to reach Entra), or waiting on someone in AD. Once validated it reads **Validated** — hiding the job's state a second time. The person looking at the list can't tell what has actually happened.

## What people see

### The Status column

- **The main pill is always the state of the job**: Submitted · Executing · Executed · Failed · Waiting on manual steps · Delete pending · and the approval states for a standard request (Pending approval, Approved, Scheduled, Rejected, Cancelled) exactly as now.
- **A second pill, "Pending validation", sits beside it** while an expedited request is waiting to be validated. It is there in addition to the job's state, never instead of it — "Executed · Pending validation", "Waiting on manual steps · Pending validation".
- **Once validated, the second pill simply goes.** Nothing replaces it: there is no "Validated" pill and no "Amended" pill. A validated request reads **Executed** (or whatever its job state is).
- A standard request never shows the second pill.

### "Waiting for Entra" becomes a state the list can show

A hybrid joiner whose account has been created in Active Directory but hasn't reached Entra yet — so its mailbox access and cloud groups are still to come — reads **Waiting for Entra** as its main pill, and flips to **Executed** by itself once the rest has been applied. Today that state isn't on the list at all, for standard or expedited requests: the request reads Executed (or Pending validation) while part of the job is still outstanding. This is the "partly done" case Steve described.

### Everywhere a request's status is shown

The same two-pill rule applies on the request's own page and the request opened in place from other screens — not just the list — so a request never reads differently depending on where it's looked at.

### Filtering the list

- The status chips become job states only: **Validated** and **Amended** are removed as choices; **Waiting for Entra** is added.
- **Pending validation** becomes its own separate filter beside them, so "Executed" and "Pending validation" can be combined — "everything that has finished and nobody has checked yet".
- Sorting by Status sorts on the job state.

## What doesn't change

- Who validated a request, when, with what comment, and whether they amended it, is still on the request's page (its timeline already says "Validated" / "Amended & validated" with the name and date).
- The Validation tab still lists what needs validating; the **Expedited** pill on the list stays.
- Nothing about what a request does or when — this is how it is described, not how it behaves.

## Decisions taken (say if any is wrong)

- **"Amended" goes the same way as "Validated"** — once validation is complete the list shows only the job's state. That a validator corrected something is on the request's page, not in the Status column.
- **"Waiting for Entra" added as a job state** — not asked for by name, but it is the state the example describes and the list has no way to show it today.
- **Order when more than one applies:** Delete pending, then Waiting on manual steps, then Waiting for Entra — a deletion still to come must never be hidden, and something waiting on a person outranks something that will finish on its own.
- **The same rule everywhere a request's status appears**, not only on the list.

## Notes (technical)

- Today: the pill is `display_status` — `display_status()` in `app/backend/src/compass_api/api/v1/access_requests.py:689` — derived, never stored (ADR 0066 / ADR 0079): `scheduled`, `delete_pending`, `awaiting_manual`, else the lifecycle `status` value. For the expedited lifecycle that fallback is `pending_validation` / `validated` / `amended` (`AccessRequestStatus`, `models/access_request.py:61`) — lifecycle values standing in for a job state. **The stored `status` and the transitions map don't change**; this is all in the derivation and the screens.
- API (the UI is one consumer — ADR 0004):
  - `display_status` becomes the job state: for `pending_validation` / `validated` / `amended` it returns `executed`, subject to the same derived overrides as an executed standard request. Remove those three from `AccessDisplayStatus` (`api/v1/schemas.py:2320`); add `awaiting_entra`.
  - New boolean on the request, `validation_pending` (true exactly when `status == pending_validation`). The lifecycle `status` field stays on the wire unchanged for anything that needs "validated" or "amended" specifically.
  - `awaiting_entra`: derived when the request is executed-or-later and any subject has `awaiting_entra_since` set (`models/access_request.py:420`; set in `access_execute.py:1380`, cleared at `:1395` and by the five-minute sweep `_finish_joiners_awaiting_entra`). Derivation order: `scheduled` → `delete_pending` → `awaiting_manual` → `awaiting_entra` → base.
  - The list endpoint computes `display_status` per row — make sure the subjects needed for `awaiting_entra` are loaded with the list query, not lazily per request.
- Frontend:
  - `components/statusColors.ts` — colour and label for `awaiting_entra` (pick from the fixed palette; `awaiting_manual` is violet); keep `pending_validation`'s colour (grape) for the second pill; drop `validated` / `amended` from `ACCESS_REQUEST_STATUS_ORDER` and add `awaiting_entra`. The screen-conventions rules apply — a pill never truncates, so the Status cell must wrap two pills rather than squeeze them.
  - `access/RequestsPage.tsx` — the Status cell (`:254`), `STATUS_CHOICES` (`:50`), the filter (`:123`, URL-backed via `useQueryState('status')`; the new Pending validation filter needs its own query key and must compose with it), counts (`:125`), sort (`:147`).
  - `access/RequestDetailPage.tsx` — the header pill and the `awaiting_manual` alert pattern (`:145`, `:174`): add the equivalent line for Waiting for Entra ("The account is in Active Directory; its mailbox access and cloud groups follow once it reaches Entra"). `RequestDetailModal.tsx` follows the page.
  - Anything that links to the list with `?status=validated|amended|pending_validation` (dashboard tiles, the Validation tab, notifications/actions) must be found and repointed — an old link should land on a sensible filter, not an empty list.
- Check other consumers of `display_status` / the removed values before changing the type: access reports (`ReportWizardPage`, report columns), CSV exports, emails and the Actions queue wording. Where a report means "validated" it should read the lifecycle `status`, not the pill.
- API change → regenerate `schema.d.ts`, run the drift script. No migration.
- ADR: the pill's derivation is recorded in ADR 0066 and ADR 0079. This changes what the derived value means for expedited requests — add a short ADR (or a dated amendment section, as 0083 has) rather than leaving those two saying something the code no longer does.

## Done when

- An expedited request that has run reads Executed (or Waiting for Entra / Waiting on manual steps / Delete pending) with a separate Pending validation pill; after validation the second pill is gone and nothing has replaced it.
- A hybrid joiner between AD and Entra reads Waiting for Entra, and Executed once the sweep finishes it.
- The list's chips, the separate Pending validation filter, counts and sort all work on the new values; old links still land somewhere sensible.
- The request page and the in-place view show the same two pills as the list.
- Tests: `display_status` for every lifecycle value × each derived override, including precedence; `validation_pending`; the list (two pills, filter combinations, sort); the request page header; a report/export that used the removed values.
- Smoke-tested on staging with an expedited hybrid joiner: Waiting for Entra · Pending validation → Executed · Pending validation → Executed.