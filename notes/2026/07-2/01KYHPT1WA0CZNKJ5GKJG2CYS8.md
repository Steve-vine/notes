---
id: 01KYHPT1WA0CZNKJ5GKJG2CYS8
created: 2026-07-27T11:54:19.402516Z
updated: 2026-08-13T19:00:21.440597Z
type: task
title: 'ADR + brief: Claude investigation surface over a governed ISE MCP server'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 329
sprint: sax9eff
assignee: steve
label: null
priority: high
task_status: done
tech: null
---
The direction decision needs recording before code: deep incident investigation happens in Claude Code (operator's own machine + subscription) over an ISE-hosted MCP server; ISE remains the system of record and the sole write gate. Touches/amends ADRs 0022/0023/0049 (chat surfaces and boundaries).

**ADR must cover:**
- Why external harness (IN-1092 re-hash failure; two tuning rounds; homegrown harness vs frontier one; spend moves off ISE's metered budget).
- ToS constraint that shaped it: Feb-2026 Consumer ToS forbids personal Pro/Max tokens inside company-provisioned products — so NO embedding, no per-user pods; operators run real Claude Code themselves. Embedded Agent-SDK pane (org API key) recorded as rejected-for-now alternative.
- **Tools are the audit surface**: MCP server sees only its own tool calls, never the conversation — so every meaningful capability routes through an ISE tool and is recorded on the ticket; transcript is colour, not record.
- Auth model v1: per-user reveal-once MCP tokens (board-token precedent, mig 0057 pattern), RBAC enforced server-side per call, tool list filtered by role. OAuth 2.1 documented as the follow-on, not v1.
- Session model: sessions keyed user+incident in the DB (not the MCP connection); substantive tools refuse without a pinned session.
- In-app issue-chat demoted to quick Q&A over ISE state — explicitly not rewritten a third time.

**Brief must cover:** the tool catalogue tier-by-tier (discover / read+cues / evidence / record / act / approve), refusal messages, and the cue model (what the UI shows visually — merge candidates, similar priors, pending approvals — returned conversationally on session start and after writes).