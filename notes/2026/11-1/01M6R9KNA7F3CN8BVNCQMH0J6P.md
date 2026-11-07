---
id: 01M6R9KNA7F3CN8BVNCQMH0J6P
created: 2026-11-06T11:23:54.055898Z
updated: 2026-11-07T08:55:18.941217Z
type: task
title: 'Small fixes from pre-UAT: chat names controls by key, the batch summary forgets its counts, a built-in-covered control says it isn''t collected, "1 controls", and saving a service doesn''t re-read checks it unbroke'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1620
sprint: s5khbev
comments:
- id: 01M6RCXJYQWB3MSVHM6973GKJA
  author: Steve Vine
  at: 2026-11-06T12:21:45.04782Z
  text: |-
    Done: PR #1635 merged. On staging since 63d195ce. Re-tested:
    1. **Chat.** "What's broken?" now lists `"controls": ["ACC.13"]` (was `s42.ACC.4`).
    2. **Review tab.** The old batch's summary now reads "Looked at 2: 0 changes · 3 new checks · 0 rules · 0 still fine · 1 can't be automated · 0 couldn't. All reviewed."
    3. **IDM.14.** The card says "A built-in check covers it. Compass doesn't collect evidence for it yet."
    4. **Audit look-over.** The job title is singular for one control (covered by the code change; not re-run, to save spend).
    5. **Saving settings.** With the GitHub account broken, saving the service's settings with the right sign-in re-read the check, and it came back without pressing Test.

    Screenshot: ~/compass-uat/s5khbev/COM-1620/
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found in Claude's pre-UAT pass on staging, 6 Nov 2026. Sprint "Checks - Coverage and batch work".

1. **COM-1613.** Polaris's "what's broken" lists the affected controls by their internal key (`s42.ACC.4`) instead of their reference (ACC.13). Names in chat must be refs.
2. **COM-1610.** The Review tab's batch summary ("Looked at 2: … 3 new checks · 1 can't be automated") recounts what's left as items are worked. It ends at "0 new checks · 0 can't be automated", which loses what Polaris found. Keep the batch's own counts, and say how many are still waiting.
3. **COM-1607.** A control fully automated by a built-in check (CRD.5, now IDM.14) shows "Fully automated" next to "Compass doesn't collect this control's evidence yet." Say a built-in check covers it instead.
4. **COM-1612.** The audit look-over job is titled "Look over 1 controls for an audit". Make it singular for one.
5. **COM-1611.** Saving a Collection service's settings re-tests every account. An account that now signs in doesn't re-read the checks it had broken: only the account's own Test does. Do the same after a save.

**Done when:** each is covered by a test, and checked on staging.

**Chain:** independent (no migration or API shape change).