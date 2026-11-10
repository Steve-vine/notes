---
id: 01M73QDH6S86WH4VMHAXD2DJ98
created: 2026-11-10T21:56:52.057316Z
updated: 2026-11-10T21:58:25.316701Z
type: task
title: 'Choosing which run to read, and closing only where it looked: a read can pick the newest finished item by a field and pass it on, and a feed names its scope so "missing" closes only within it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1710
sprint: sj4f1kj
assignee: steve
label:
- feature
priority: high
task_status: todo
---
ADR 0146 §6 and §7 (COM-1705). Scanners report in runs. The newest finished run is the truth, and a host absent from it might just have been switched off. Nessus is the first user (ADR 0129 §4a). The capability is general.

**Chain:** on the chain — API

## What the person sees

- **Choose from a list:** a read can keep only the items that match a condition (a field equals one of some values, e.g. status = completed), group them by a field (e.g. per scan), and take the **newest** or **oldest** in each group by a date or number field.
  - The chosen items' fields feed the next follow-on read (COM-1706), e.g. `/scans/{scan_id}?history_id={history_id}`.
  - Preview shows which run was chosen for each group, and why.
- **Scope of a complete read:** a feed using *missing from a complete read* can name a **scope field** (e.g. each finding's host, as listed in the chosen run).
  - A record closes only if its scope value was in this run and the record wasn't.
  - Records whose scope is absent from the run are left as they were. The run's history says "47 hosts not in this run: nothing closed on them".
- A feed records which run it last read for each group, so the same run is never applied twice, and an older run can't overwrite a newer one.

## Done when

- Tested against a fake scanner: several scans with several runs each, unfinished runs ignored, the newest finished one chosen per scan, a host missing from the newest run closes nothing, a host present without a finding closes that finding, a re-read of the same run changes nothing, and an older run doesn't apply.
- The conditions are declarative (equals or in a list, present or absent, before or after a date). No expressions run code (ADR 0145).
- No service name in code (COM-1696).