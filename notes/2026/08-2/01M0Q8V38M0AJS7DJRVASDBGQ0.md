---
id: 01M0Q8V38M0AJS7DJRVASDBGQ0
created: 2026-08-23T12:17:03.764441Z
updated: 2026-09-01T13:55:50.520638Z
type: task
title: The Validation tab says who made the change — user and app actors rendered distinctly
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 391
sprint: s5gwx0s
blocked_by:
- 01M0Q8TNPNB4WC0J2X8ZPVQ2BX
comments:
- id: 01M0QHM15B1MTD5S1Q3MQ9Y02K
  author: Steve Vine
  at: 2026-08-23T14:50:29.419577Z
  text: |-
    Done — PR #393 (feature/com-391-validation-actor), stacked on #392 (COM-390). Frontend only, as scoped.

    The actor now appears on the item row and again in the Decide modal — the second placement wasn't in the brief but adopting or reversing turns on who made the change, so it belongs in front of the person deciding.

    One thing the brief implied but didn't resolve: it asked for the user actor to link to the View Users modal "when the account is in the mirror", but COM-390 stores `actor_identifier` as a **UPN**, not an object id, and the modal takes an id. Rather than widening the schema I resolve the UPN against the mirror — matched **exactly**, not by the search's LIKE. That distinction matters: `ada@contoso.com` must never open `ada.smith@contoso.com` because it happened to be the first hit, and there's a test for precisely that near-miss. An actor who has since left the tenant renders as plain text rather than a dead link.

    The app actor is a badge with a "service" label and no UPN pretence — and I deliberately don't show the app id, which would be dressing a service up as a person's identifier. The whole point is that "Directory Synchronization Accounts" should read as *not a human* at a glance.

    The three null states are three different sentences, not one dimmed blank: "not yet available — the audit log lags behind the change" (resolves itself), "unavailable — {reason}" (an ops problem), and the 7-day unknown with its reason. A validator acts differently on each.

    Small supporting change: `useDirectoryUsers` gained an `enabled` flag (the `useDirectoryGroupSearch` precedent) so a non-user actor doesn't fetch a page of users it will discard.

    Four page tests, full suite green apart from the known `PortalRouting.test.tsx` load flake, which passes in isolation alongside my file.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Surface COM-390's actor on each unrequested-change item (`ValidationPage.tsx`) — validation stops being "someone did this" and becomes "Jane did this at 14:02", which is the actual basis for validate-or-reverse.

- [ ] Item card + detail: **"Changed by {actor} · {performed_at}"**. A user actor shows display name + UPN, linking to the View Users modal when the account is in the mirror.
- [ ] An **app actor** renders distinctly (a "service" badge, no UPN pretence) — "Directory Synchronization Accounts" tells the validator the change came from on-prem AD, not a rogue admin; that reading must be effortless.
- [ ] The two null states stay apart, per the backend's degraded reason: **"actor not yet available"** (enrichment pending — audit ingestion lags) vs **"actor unavailable — {reason}"** (grant missing, retention passed, no match). Never silently blank.
- [ ] Schema additions ride the existing items endpoint (additive; `schema.d.ts` regen).

Refs: COM-390 (the data), COM-255 (user-modal linking pattern), ADR 0045 §7.