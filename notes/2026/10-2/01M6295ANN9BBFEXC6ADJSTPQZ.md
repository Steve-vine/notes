---
id: 01M6295ANN9BBFEXC6ADJSTPQZ
created: 2026-10-28T22:12:46.901655Z
updated: 2026-10-29T08:34:28.731716Z
type: task
title: Checks run on their own — each company's checks run on a schedule and keep their results; a failing check raises a gap marked "Raised by Compass check", and closes it when the check passes again
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1416
sprint: s6j9773
blocked_by:
- 01M6294VHF0RVNJYTC79YZQVJJ
comments:
- id: 01M63CQN7WS67KMGV24DZ75467
  author: Steve Vine
  at: 2026-10-29T08:34:27.708283Z
  text: |-
    Done — PR #1433 (auto-merge on). The engine, with no checks of its own yet; real checks come in COM-1417/1418.

    What you'll see once checks exist:
    - A gap a check raised reads "Raised by Compass check: <name> · date" where a person's name usually is. Its description says what was failing (counts only) and that Compass will close it.
    - When the check passes, the gap closes as Complete and its comment thread says "Closed by Compass: check passing since 3 Nov 2026". The Activity log names Compass as the one who did it.
    - Cancel is believed: no new gap until the check has passed in between. Marking it Complete while it still fails gets it reopened ("Reopened by Compass: check still failing").
    - Can't tell does nothing. Switching a check off closes its gap ("check switched off").
    - Status and maturity never move.

    My calls:
    - The gap's title is "<control ref>: <check name> — failing", e.g. "IDM.13: Everyone has MFA registered — failing".
    - History of a gap = its comment thread. Gaps have no History panel of their own, so Compass writes its closes and reopens there, as "Compass".
    - No gap on an unassessed or out-of-scope control, or on one with an exception in date (ADR 0132 §5).
    - Checks run hourly at :27 for every active company, and after a read of their source finishes.

    Tests: 7 integration tests cover raise/close, cancel, reopen, can't tell, unassessed/out of scope, switched off, and results kept on a change and once a day.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 96, Continuous Control Checks (ADR 0132, COM-1415).

The engine, with no checks of its own yet. The tests use a stand-in check. Real checks arrive in COM-1417 and COM-1418.

## What people see

- **Gaps register and gap page:** a gap raised by a check says **Raised by Compass check: <check name>** where "Raised by" usually names a person. Its description lists what was failing when it was raised, such as "4 people have no MFA registered", and links to the check.
- **When the check passes again**, the gap closes as **Complete**. Its History says "Closed by Compass: check passing since 3 Nov 2026", and it leaves Actions.
- **A person cancels the gap** with a reason, as today. The gap stays cancelled and isn't raised again until the check has passed and then failed again.
- **A person marks the gap Complete while the check still fails.** On its next run, the check reopens the gap as New, with "Reopened by Compass: check still failing" in History.
- **Can't tell** never raises, closes or reopens anything.
- **A check switched off for a company** (Settings comes in COM-1420) closes its open gaps with "Check switched off".
- Nothing changes a control's **status or maturity**.

## Who can do what

Nobody runs the engine; it runs on a schedule. A gap raised by a check is worked by the same people, with the same permissions, as any other gap.

## Notes (technical)

- Add `core/checks/` with a registry like `evidence_of_operation.SOURCES`.
  - `Check(key, name, control_keys, integration, needs, evaluate, threshold_defaults)`.
  - `evaluate` returns `CheckOutcome(state: passing|failing|unknown, failing_count, total, items: list[CheckItem], reason)`.
  - Items are references (a directory user id, a VUL id), never copied personal data.
- New table `check_results(company_id, check_key, state, failing_count, total, reason, items JSONB, observed_at)`. Write a row only when the state or count changes, plus one row a day.
- New table `company_check_settings(company_id, check_key, enabled, thresholds JSONB)`. A missing row means on, with the defaults.
- Add Beat task `tasks/control_checks.py`, hourly, for every active company. Each check also runs after its source's read ends, the way `findings.evaluate` runs at the end of a read. It must be idempotent, take ids, and stop when `feature_on(integration, …)` is false.
- Gap: add `raised_by_check` (text, nullable) and `check_rearm` (bool) to stop re-raising after a cancel.
  - One open check gap per (company, control, check).
  - It needs an assessment row. If the company hasn't assessed the control yet, create it the way raising a gap from the screen does, or skip it, and decide which in the ADR.
  - Close and reopen through the gap service so revisions, History and Actions follow. The actor is the system (`core.via` = "check").
- Raise the target date from a Settings default (30 days). The owner is the assessment's owner if it has one.

**Chain:** on the chain (migration + API).

**Done when:** a stand-in check, failing then passing, raises then closes one gap; cancel stops re-raising until it passes; can't tell does nothing. Integration tests cover each path.