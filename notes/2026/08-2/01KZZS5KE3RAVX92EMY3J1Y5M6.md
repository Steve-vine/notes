---
id: 01KZZS5KE3RAVX92EMY3J1Y5M6
created: 2026-08-14T09:20:38.851033Z
updated: 2026-08-14T09:20:38.851033Z
type: task
title: The resolution note is mandatory, stored, audited, served — and displayed nowhere
priority: high
task_status: backlog
label: bug
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 704
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