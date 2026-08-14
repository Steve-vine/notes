---
id: 01KZZS5KE3RAVX92EMY3J1Y5M6
created: 2026-08-14T09:20:38.851033Z
updated: 2026-08-14T10:54:02.356561Z
type: task
title: The resolution note is mandatory, stored, audited, served — and displayed nowhere
project: 01KX671DATY39VW6GWK3M2T3DN
number: 704
sprint: sevhjex
comments:
- id: 01KZZYGE57DBN2QY8YMMJK0YHW
  author: Steve Vine
  at: 2026-08-14T10:53:56.775556Z
  text: |-
    BUILT + MERGED 2026-08-14 — PR #653 (squashed to main as 2b3b2c4), CI green.

    FOUR SURFACES, not three — the MCP check you asked for found the same gap.

    1. THE TIMELINE. The note renders under the status-change row it was written on. `apply_status_change` had been putting it in the audit details since ISE-642 under a comment saying it belongs there; the backend did exactly that and the front end had no reference to the field. It gets its OWN line rather than being appended to the sentence: it is prose of any length, and the row above stays scannable.

    2. THE INCIDENT ITSELF. A resolved incident shows "How this was resolved"; a dismissed one shows "Why this was dismissed" — same field, different question, and a dismissal is sticky so the why is what a future operator needs. It sits with the description, since on a closed incident that is the pair worth reading first.

    3. RECALL. Both, not one or the other, and the split is the reason: `outcome` is what ISE DERIVED (the change that ran, or the diagnosed cause), the note is what the person who closed it WROTE. The outcome keeps its truncation on the flex child; the note does not, because a prior's account of what worked is the thing the list exists to carry.

    4. THE MCP BRIEF had the identical gap. `build_brief` now carries the incident's own `resolution_note`, and each similar prior carries its note beside its outcome. Claude Code forms its first opinion of an incident from that brief, so it needed the same fix for the same reason.

    EDITABLE AFTER THE FACT — decided NO, deliberately. The note is the audited record of a status transition, and `audit_event` is append-only by trigger; silently rewriting `issue.resolution_note` would leave the incident and its own history disagreeing about what was said. Amending it properly wants a fresh audited event (a "note corrected" line on the timeline), which is a change of its own rather than a text box. Raise it if you want it — the display fix is what closes the ISE-642 hole.

    ONE UNRELATED FIX RIDING ALONG, because it reddened this batch's CI: `test_relevance_puts_what_you_typed_first` (from ISE-698, merged this morning) created all four entities in ONE transaction, so `created_at` — Postgres `now()`, which is the TRANSACTION's clock — was identical across them. The `id desc` tiebreak then decided the default order, and its last assertion failed whenever the cluster's random uuid sorted highest: about one run in four. Timestamps are explicit now; re-ran it five times clean, and the same commit that failed passed on re-run, which is what proved it a flake rather than a regression.
assignee: steve
label:
- bug
priority: high
task_status: review
tech: null
---
ISE-642 made a resolution note **mandatory** on `resolved` and `dismissed` — enforced in `apply_status_change` so no surface can route around it, and the 422 that blocked a 39-way bulk resolve (ISE-686) exists to enforce it. The note is captured, stored, audited and served to the API. **It is rendered nowhere in the UI.**

Found on IN-1341 (resolved 2026-08-14 09:12), verified against `origin/main` @ 75c57f6:

| Layer | State |
|---|---|
| `issue.resolution_note` | *"The issue resolved itself once the pods had stabalised."* |
| audit row 09:12:06 | `{"note": "The issue resolved itself…", "status": {"to": "resolved", "from": "acknowledged"}}` |
| `IssueRead.resolution_note` | on the read model (`schemas.py:507`) |
| `RecallPriorRead.resolution_note` | served to Recall (`issues.py:508`) |
| frontend | **zero references** to `resolution_note` outside generated `schema.d.ts` / `openapi.json` |

**Three surfaces, one gap.**

1. **The timeline drops it.** `apply_status_change` puts the note in the audit details with the comment *"On the timeline, which merges audit rows — so the account of what was done sits where the status change is read"* (`issues.py:1608`). The backend does exactly that; `IssueTimeline.tsx` has no reference to the `note` field, so the row renders as a bare status change and the sentence is discarded. The comment describes behaviour that was never built on the front end.

2. **The incident never shows its own note.** A resolved incident displays no account of how it was resolved. The operator who wrote it gets no confirmation it saved, no way to spot a typo, and no way to correct it. Nobody arriving later can read it at all.

3. **Recall shows the wrong field — and this is the one that matters.** The priors list renders `{p.outcome}` and never touches `p.resolution_note`, though the API sends both. ISE-642's justification for making the field mandatory was *"the next operator reads it in Recall"*. Recall does not show it. Every operator has paid the cost of a blocking required field since 2026-08-10 for none of the benefit it was introduced to deliver.

**Scope**
- Render the note on the timeline's status-change row, where ISE-642 intended it.
- Show it on the resolved/dismissed incident itself — and decide whether it is editable after the fact. It is the record of what was done; a typo in it is currently permanent, and `apply_status_change` only writes it on a status transition, so there is no path to amend it without a fresh transition.
- Show it in the Recall priors list. Decide the relationship with `outcome`: whether the note replaces it, or both appear (outcome as the what, note as the how). Truncation matters — the row already uses `truncate` on a flex child.
- A dismissal note deserves the same treatment: a dismissal is sticky (a recurring signal will not reopen it), so *why* it was dismissed is the fact a future operator most needs.

**Check the MCP and AI surfaces too.** `get_issue` / the incident brief and Recall's AI-facing output should carry the note for the same reason the screen should — worth confirming they do before closing, since the gap here was precisely a field that everything stored and nothing surfaced.

Related: ISE-686 (the mandatory field's 422 broke bulk resolve), ISE-703 (the Learning panel — the other half of the Incident Loop with no visible output).