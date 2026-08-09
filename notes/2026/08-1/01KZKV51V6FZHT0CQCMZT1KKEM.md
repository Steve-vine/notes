---
id: 01KZKV51V6FZHT0CQCMZT1KKEM
created: 2026-08-09T18:04:24.806636Z
updated: 2026-08-09T18:04:24.806636Z
type: task
title: A successful reboot reports as failed — the runner's 60s timeout kills a 600s operation
task_status: backlog
priority: high
assignee: steve
label: bug
project: 01KX671DATY39VW6GWK3M2T3DN
number: 630
---
Found on the first real act-path run, 2026-08-09 (staging `2be505a`). Steve proposed and approved `reboot_server` against `mpwxscript.moneypenny.local`. The preview passed, the change was approved, the module was invoked — and ISE recorded **`failed`**:

```
Task execute_change succeeded in 60.35s: status 'failed',
  'ansible-runner ended with status timeout and no host result'
```

**Root cause.** `ansible_exec.run_module` passes `timeout=PREFLIGHT_TIMEOUT_SECONDS` — **60 seconds** — to `ansible_runner.run()` for *every* call, while `reboot_server` tells the module `reboot_timeout=600`. `win_reboot` issues the restart and then waits for the host to come back; ansible-runner kills the run at 60s, long before it can.

The 60.35s runtime in the log is the constant, exactly.

**Why this is worse than a wrong status.** The reboot almost certainly HAPPENED — `win_reboot` sends the shutdown before it starts waiting. So ISE tells an operator that an **irreversible T2 action failed, when it succeeded**. The natural response to "failed" is to retry, which reboots a production machine a second time. That is the most expensive wrong answer this integration can give, and it is worse than the `auth_refused` misdiagnosis the preflight categories were built to avoid.

**The naming was the tell.** One constant, named for the *preflight*, used as the job timeout for every module call including a ten-minute one. Anything long-running has the same problem — a large facts gather, a slow service restart, a future long operation.

**Fix direction (decide before building).**

1. **Per-operation runner timeout.** The catalogue already knows what it is invoking; a reboot's job timeout should be derived from its own `reboot_timeout` plus a margin, not from a preflight constant. Rename the constant so it can only be used for what it names.
2. **Distinguish "we lost contact" from "it failed".** A reboot that times out waiting is not the same as a module that errored. For an operation that is expected to sever the connection, "dispatched, awaiting return" is a truthful state that `failed` is not — and the register's own preflight is what should then decide whether the machine came back.

Option 1 is the minimum and stops the false failure. Option 2 is the honest model for any operation that deliberately kills its own transport, and is worth considering before more act operations are added.

**Also check**: whether the change record can be moved out of `failed` once the machine returns, or whether an operator is left with a permanently wrong record of what ISE did.

**Acceptance**: a reboot that succeeds is recorded as executed; a reboot that genuinely fails still says so and says why; no operation inherits a timeout named for a different operation.