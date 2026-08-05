---
id: 01KYHPTP7VQ60TCQ3X133JZWTV
created: 2026-07-27T11:54:40.251419Z
updated: 2026-08-05T14:49:02.015803Z
type: task
title: 'Incident session pinning: start/exit tools, MCP prompts, session indicator on the incident screen'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 331
sprint: sax9eff
assignee: steve
priority: high
task_status: done
---
The "ISE start working on IN-1234 … ISE exit incident" model, enforced structurally.

- **Session table** (migration, stacks after the foundation task's) keyed **user + incident**, not the MCP connection — survives reconnects and new Claude conversations; states active/ended; one active session per user.
- `start_incident_session(IN-NNNN)` / `end_incident_session` tools. Start returns the incident brief + cues (see read-tools task) so pinning immediately orients the conversation.
- **Refusal without a session**: substantive read/evidence/write tools answer "no active incident session — start one with start_incident_session or /ise:work-on" when unpinned. This is the structural separation of incident work from noise: nothing *happens* outside a session, whatever gets chatted about.
- **MCP prompts**: `/ise:work-on IN-NNNN` and `/ise:exit` surfaced as slash commands in Claude Code — first-class affordance, not a magic phrase.
- Session start/end recorded on the incident timeline (who, when).
- **UI (pane-of-glass DoD)**: incident screen shows an active-session chip — "Claude session active — Steve, started 14:02" — so anyone looking at the incident can see an investigation is live. Clears on end/timeout (idle timeout, e.g. 4h, auto-ends with a timeline note).

Vertical DoD: pin IN-1092 from Claude, see the chip appear on the incident screen, exit, see it clear — all three events on the timeline.