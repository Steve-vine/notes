---
id: 01M07P4BVHXBJXJKZK0R4FAHG3
created: 2026-08-17T11:01:28.049609Z
updated: 2026-08-17T11:02:03.032459Z
type: task
title: win_powershell is called with raw params — Windows log evidence and Hyper-V discovery both fail
project: 01KX671DATY39VW6GWK3M2T3DN
number: 751
sprint: sevhjex
assignee: steve
label:
- bug
priority: high
task_status: backlog
tech: null
---
Found 2026-08-17 working IN-1403 ("DD Agent Offline is Alert on host:MPWXDataWH"). Asked whether the server was responding, ISE tried a live read and came back with `win_powershell does not support raw params` — a fault in ISE, reported as an inconclusive answer about the host.

`ansible.windows.win_powershell` does not accept raw / free-form module params; it needs its `script` as a structured argument. Two callers pass it as a free-form string into `ansible_runner.run(module_args=...)`:

| Call site | What it breaks |
|---|---|
| `servers_evidence.py:389` — `module_args=f"script={script}"` | **`server_recent_logs` on EVERY Windows server**, not just this host. The Windows branch is the only way to read the System/Application event logs. |
| `servers_coverage.py:453` — `module_args=f"script={HYPERV_GUEST_QUERY}"` | **Hyper-V guest enumeration**, silently — nothing has asked recently, so it has never been seen to fail. |

**Why it survived review.** The idiom is correct for other modules three lines away: `servers_evidence.py:324` passes `gather_subset=hardware` to `ansible.builtin.setup`, which *does* take raw params. So "module + free-form args string" reads as the house style, and only this module rejects it. A fix that changes one call site and not the other leaves the silent half broken — grep for `win_powershell` before closing (2 hits today).

**Scope**
- Pass structured args for `win_powershell` at both sites. `run_module`'s `module_args: str` signature is the thing forcing free-form here (`ansible_exec.py:410`) — it likely needs to accept a mapping, which is also what makes the next module of this kind safe.
- A test that actually asserts the argument SHAPE reaching `ansible_runner.run`, not just that the call was made. The current tests pass with the broken form, which is how this shipped.
- Check the rest of the catalogue for modules that reject raw params while we are here.

**Not this bug — do not fold it in.** The same investigation's *first* attempt failed with an NTLM `Remote end closed connection without response`, before any module ran. Profile resolution is correct (`s.vine-3`, winrm, Windows host) and the same transport preflighted cleanly at 10:01:25 the same morning, so that failure is unexplained and may be transient. Fixing the raw-params bug will not address it; if it recurs it needs its own task.
