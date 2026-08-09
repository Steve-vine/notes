---
id: 01KZKCX3891CBRC8S0V33HC1DS
created: 2026-08-09T13:55:24.041989Z
updated: 2026-08-09T19:32:18.491527Z
type: task
title: Vendor Portal inception (ADR 0040)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 191
sprint: sw3i5is
comments:
- id: 01KZKDTEV3QEFN5541E72WD5QR
  author: Steve Vine
  at: 2026-08-09T14:11:26.178757Z
  text: |-
    ADR written and PR opened — #183 (branch feature/com-191-adr-0040-vendor-portal).

    **What was done**
    `decisions/0040-vendor-portal.md`, five decision sections:
    - §1 `vendor_portal` role + capability sets (`_PORTAL_READ = _VENDOR_READ | {vendor_portal}`, `vendor_portal` joins `_VENDOR_SUBMIT`), migration 0050 named.
    - §2 separate shell at `/portal/*` rather than a sixth nav section — argued from audience, and from the fact that a separate shell hides future internal sections by default.
    - §3 dedicated GET-only `api/v1/portal.py` sharing helpers with `api/v1/vendors.py`; full vendor record published; activity log stays admin-only.
    - §4 `kind` + `justification` + typed nullable `proposed_*` columns; table keeps its name.
    - §5 one approval path, three execution effects; amendments judged against a projected engagement.

    Plus Alternatives (8) and Consequences (7).

    **Decisions made on the fly**
    - Recorded the rejected reduced-scope portal as an explicit alternative rather than silently dropping it, so the reversal is legible.
    - Added the "second read path" consequence in two places (§3 and Consequences) — it's the finding most likely to be mistaken for a leak later.
    - Noted that a future external/third-party portal is not foreclosed: `vendor_portal` is a role, and a row-scoped `vendor_contact` could reuse the same shell.

    **Not done**
    No index/CLAUDE.md update — CLAUDE.md's "Key ADRs" list stops at 0038 and 0039 wasn't added to it either; no ADR seed importer exists in the repo any more.

    **State**: PR #183 open against main, CI running. Staging merge deferred until all five sprint tasks are in review, per the run plan.
- id: 01KZM02WN5EW1KVG1PG52ABNYZ
  author: Steve Vine
  at: 2026-08-09T19:30:36.83699Z
  text: |-
    Released. PR #183 squash-merged to main as `eb910c7`; feature branch deleted.

    ADR 0040 also gained an **amendment** during the sprint (merged with COM-194, #186): staging smoke testing showed a `vendor_portal` account landing on the dashboard, and fixing it changed two of this ADR's decisions rather than just its implementation —

    - **"Overview is universal" no longer holds.** ADR 0026 §3 grants the Dashboard to all users; §2 inherited that. It does not survive a role that exists to see only the vendor record, because the dashboard reports company control coverage, gaps and risk. `/dashboard` and `/search` now redirect a portal-only account to `/portal`. An operator who *also* holds the role keeps their dashboard.
    - **The portal gets a sidebar entry after all.** §2's "internal users reach it by URL" was too thin — with its own shell there was no other way in, including for admins checking what employees see. The *portal's* shell still has no sidebar, so the one-way property that hides future internal sections is intact.

    The redirect race itself is recorded as implementation, not decision.
assignee: steve
label: null
priority: medium
task_status: done
---
Record the Vendor Portal design as `decisions/0040-vendor-portal.md`. Docs only — no code, no migrations.

**The need**: the Vendors section (ADR 0039) is closed to `viewer` / `vendor_owner` / `vendor_manager` / `vendor_assessor`. Everyone else has no way to see who the approved suppliers are and no way to ask for a new one — requests go by email and the register drifts. The portal is an outward-facing, read-only view of the register for all employees, plus the three requests they actually need.

---

## Agreed work (planned with Claude, 2026-08-09)

**Scoping decisions (Steve):**
- **Separate shell at `/portal/*`** — its own minimal layout, no Library/Company/Vendors sidebar, no global search. A portal-only user lands on `/portal`; internal users reach it by URL.
- **Employees, existing login** — same session cookie and `/login`; the new `vendor_portal` role decides what they see. No third-party entry point, no self-registration.
- **Reuse the approval workflow** — generalise `vendor_onboarding_requests` with `kind = new_vendor | new_engagement | amend_engagement`. All three evaluate the same `approval_rules` and produce per-area `vendor_approvals`. The portal widens who can *ask*, not who *decides*.
- **History = revisions only** — the activity log stays admin-only (ADR 0023); portal History shows the `vendor_revisions` timeline.
- **Portal detail shows the whole vendor record, read-only** (revised 2026-08-09): lifecycle, details, assurance profile, certifications, flags, engagements, **assessments** (incl. answers), **linked risks**, review history, **review actions**, revision history. Read-only means read-only — no add/complete/delete affordances anywhere.

**Three departures the ADR must state explicitly:**
1. **`vendor_portal` is not in `_LIBRARY_READ`.** The ADR 0026 amendment opened Library read to *every* role; a portal-only account is the first role with no Library and no Company access at all. Say so, so the next role author doesn't "fix" it.
2. **The request table keeps its name.** `vendor_onboarding_requests` now carries three kinds. Renaming would churn the FKs from `vendor_approvals` and `vendor_form_answers` plus the stored `NotificationTargetType.vendor_onboarding_request` values, for no functional gain — the name is historical, the `kind` column is the truth.
3. **The portal reads two things its role can't reach elsewhere.** Linked risks are risk-register rows (normally `_COMPANY_READ`) and review actions are Actions-queue items with owners and due dates — a `vendor_portal` user sees both *through the vendor lens* while `/risks` and `/actions` stay 403. Deliberate: the vendor record is the unit being published, and a partial record is a misleading one. Record it as a consequence so the asymmetry isn't read later as a leak. Vendor assessment answers are likewise now visible company-wide.

**Checklist:**
- [ ] `decisions/0040-vendor-portal.md` — Context / Decision (§1 role + capability sets, §2 separate portal shell & IA, §3 portal read API surface, §4 request kinds + amendment payload, §5 approval reuse & per-kind execution) / Alternatives considered / Consequences.
- [ ] Alternatives to record: widen `require_vendor_read` instead of a dedicated portal router; a fifth sidebar section instead of a separate shell; a lightweight notify-only change-request with no sign-off; JSONB amendment payload instead of typed `proposed_*` columns; a genuinely external (third-party) portal with per-vendor row scoping; a reduced portal record omitting assessments/risks/actions (considered and rejected — see §3 above).
- [ ] PR to main.
