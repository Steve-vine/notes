---
id: 01M07P4SCYH96X30VZKE53MPXV
created: 2026-08-17T11:01:41.918723Z
updated: 2026-08-17T11:02:14.371859Z
type: task
title: '"Is the server responding?" has no cheap answer — expose the liveness register as evidence'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 752
sprint: sevhjex
assignee: steve
label:
- improvement
priority: high
task_status: backlog
tech: null
---
Found 2026-08-17 on IN-1403. Asked "is the server itself responding?", ISE attempted a live Ansible read, the read failed for its own reasons ([ISE-751]), and the failure became the answer. **ISE already held the answer and could not see it.**

`registered_server` for `mpwxdatawh`, 42 minutes before the incident opened at 10:43:

```
state                | reachable
consecutive_failures | 0
last_preflight_at    | 2026-08-17 10:01:25
identity             | Windows Server 2022, 8 cores, 215 GB, Hyper-V
profile              | s.vine-3 (winrm)
```

That is a successful `win_ping` **and** a full `setup` fact gather, over the same WinRM profile that later failed. The box was up and talking to ISE.

**The gap.** The servers evidence catalogue (`servers_evidence.py:36`) declares four queries — `server_full_facts`, `server_service_status`, `server_disk_usage`, `server_recent_logs` — and **every one requires a live connection to succeed before it returns anything**. There is no query over what ISE already knows. So the cheapest, most reliable fact about a registered server is unreachable from an investigation, and the only available route turns any ISE-side fault into evidence about the host.

`failure_category` and `failure_detail` exist on `registered_server` precisely to separate *host unreachable* from *auth refused* from *tooling broke*. Neither is exposed either, so the distinction they were built to draw is not available where it matters.

**Scope**
- A `server_reachability` evidence query: `state`, `last_contact_at` / `last_preflight_at`, `consecutive_failures`, `failure_category`, `failure_detail`, the resolved connection profile and method. Read-only, no connection, near-instant — the opposite of the four that exist.
- It must **say how old the fact is**, in the result rather than in a footnote. "Reachable, last proven 42 minutes ago" is an answer; "reachable" alone invites the same mistake in the other direction.
- Prefer it in the agent's guidance for liveness questions: ask the register first, attempt a live read only to confirm or when the register is stale.
- When a live read DOES fail, the failure must be reported as ISE's, not the host's, wherever `failure_category` can tell them apart. A connector bug and a dead server are not the same finding, and IN-1403 is what it costs to conflate them.

**Acceptance**: on an incident naming a registered host, "is the server responding?" is answered from stored state in one call, with its age stated, and a live-path failure is attributed to the right side.
