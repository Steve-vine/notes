---
id: 01M1CKGAGNM6MQQ1NHZKW8DE1M
created: 2026-08-31T19:07:28.149629Z
updated: 2026-08-31T19:07:28.149629Z
type: task
title: A silent integration must not report that it is healthy
task_status: backlog
label: bug
priority: high
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 756
tech: null
---
`System.health` is a cached verdict with no expiry. Nothing that stops being checked ever stops claiming it is fine.

**Evidence (staging, 2026-08-31).** 21 integrations disabled on 2026-08-20 still read `health = connected`, with `last_synced_at` 11 days old. The Integrations screen is a wall of green for an estate nothing has looked at since the 20th.

**Root cause.** The health check rides the sync dispatch, and dispatch filters on `System.enabled.is_(True)` (`sync.py:514`, `sync.py:556`, with early returns at `sync.py:50` and `sync.py:357`). No dispatch means no check, and `health` simply retains whatever it last said — indefinitely. `SystemDetailPage.tsx:1608` renders `<StatusPill value={system.health} />` with nothing qualifying when that verdict was formed.

**This is the general case of ISE-750.** That task fixed one instance — an outbound-only transport that was never dispatched, so its `health_check` never ran and its tile lied. The instance was fixed by giving it a cadence. The class was not: *any* System that stops being dispatched keeps its last verdict and presents it as current truth. Disabling is the commonest way in, but a paused, mis-scheduled or never-dispatched System reaches the same place.

**Shape of the fix** — health should carry freshness, not just a value:
- a verdict has an `as of` time, and the UI shows it (`connected · checked 4 min ago`)
- a verdict older than some multiple of the System's cadence reads `unknown` / `not checked`, never `connected`
- a disabled System reads `disabled`, distinctly from both healthy and faulty — the operator turned it off and should see exactly that, not green
- ADR 0081's principle applies: the guard must not depend on the target system saying anything, because a silent target says nothing at all

Worth a short ADR — this is a semantic change to what `health` means, and ISE-750 shows the instance-by-instance fix does not hold.

**Done when** no System can display an affirmative health verdict that nothing has verified, disabled reads as disabled, and every health value on screen is dated.