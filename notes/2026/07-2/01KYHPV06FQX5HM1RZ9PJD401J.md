---
id: 01KYHPV06FQX5HM1RZ9PJD401J
created: 2026-07-27T11:54:50.447673Z
updated: 2026-08-06T08:15:30.351209Z
type: task
title: 'Read + cue tools: incident brief, proactive cues, and reads across every resource'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 332
sprint: sax9eff
assignee: steve
priority: high
task_status: done
---
Steve must-haves #1 and #2: easy incident info, and the UI's visual cues surfaced conversationally.

- **`get_incident_brief`** — one call answers "where are we": status, severity, affected entity (+ graph context), signal/alert state, master/children (merged tickets), open proposed changes, pending approvals, recent timeline, committed diagnosis. This is the bounded, ranked read (ADR 0050 spirit — shortlists, not dumps; the 424-finding lesson applies).
- **Cues block** returned by `start_incident_session` and `get_incident_brief`, mirroring what the UI shows visually: merge candidates (`propose_merges` — and the widened ISE-328 rule when it lands), similar prior incidents with outcomes (Recall), applicable playbooks, pending approvals. Cue text tells Claude to *offer* them ("IN-1091 looks related — same signal kind; want me to compare?"), keeping the conversation interactive rather than waiting to be asked.
- **Resource reads**, all role-filtered and bounded: incidents search (FTS, ADR 0050), signals/alerts, estate entity + graph traversal (blast radius), events (webhook Events screen data), tags/groups, playbooks, Document Register/Confluence content, repo search + read_repo_file (ISE-309 tools re-exposed). Reads require a pinned session (except incident search/list, needed to find the ticket to pin).
- Every read stamped to the session for the audit task to record.

Vertical DoD: from a pinned Claude session, "what's the state of this incident and is anything related?" yields status + merged tickets + alert state + the IN-1091-style merge cue, without the user naming any tool.