---
id: 01KZKV51V6FZHT0CQCMZT1KKEM
created: 2026-08-09T18:04:24.806636Z
updated: 2026-08-09T18:46:11.097253Z
type: task
title: A successful reboot reports as failed — the runner's 60s timeout kills a 600s operation
project: 01KX671DATY39VW6GWK3M2T3DN
number: 630
comments:
- id: 01KZKXGBRZ7MDCRX8PBX183M8Z
  author: Steve Vine
  at: 2026-08-09T18:45:32.574847Z
  text: |-
    BUILT + MERGED to main 2026-08-09 — PR #575, `97dbd41`. Steve confirmed the machine did reboot, so this was purely the reporting.

    **Option 1 built.** One constant was answering two questions: how long to wait for a host to ANSWER (the SSH `ConnectTimeout`, legitimately 60s) and how long a whole run may TAKE. Split into `PREFLIGHT_TIMEOUT_SECONDS` (which now says what it is) and `DEFAULT_RUN_TIMEOUT_SECONDS`, with `run_module` taking a `timeout` an operation can raise. `reboot_server` declares its own, **derived from `REBOOT_WAIT_SECONDS` + margin** so the two cannot drift apart.

    Default left at 60 rather than widened globally: everything that works today finishes well inside it, and a bigger default turns a hung run into a long wait instead of a reported failure.

    **The guard generalises, which is the part worth keeping.** It reads the module ARGS rather than a list of operations somebody remembered: anything telling a module to wait N seconds must have a run budget greater than N. The next long operation is covered automatically, and one added without a budget fails loudly with a message saying why. All three tests verified to fail against the shipped behaviour.

    Third acceptance criterion covered too: a reboot that genuinely never comes back still fails and still says why — widening a budget must not convert a real failure into a success.

    **Two things NOT done, both deliberate, both yours to overrule:**

    1. **The existing `failed` change record is left alone.** The task asked whether it should be reconciled once the machine returns. My answer is no: the audit trail records what ISE believed at the time, and rewriting it is a worse property than a record that was wrong once. If you disagree that is a real design decision, not a tweak.
    2. **Option 2 — a distinct state for an operation that deliberately severs its own transport** — is not built. It is the honest model, and I still think it is right eventually, but it adds a change status and deserves an ADR rather than being smuggled in under a bug fix. Option 1 meets every acceptance criterion on this task.

    Deploying to staging now. Worth re-running the reboot once it lands: same propose → approve → execute, and the change should record `executed` with the "came back" detail rather than a timeout.
assignee: steve
label:
- bug
priority: high
task_status: review
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