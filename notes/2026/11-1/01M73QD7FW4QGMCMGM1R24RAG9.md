---
id: 01M73QD7FW4QGMCMGM1R24RAG9
created: 2026-11-10T21:56:42.108313Z
updated: 2026-11-10T21:58:24.665883Z
type: task
title: 'Limits and incremental reads per read: each read sets its own timeout, size caps and one retry within Compass''s ceilings, and can ask only for what changed since the last good run'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1709
sprint: sj4f1kj
assignee: steve
label:
- feature
priority: high
task_status: todo
---
ADR 0146 §4 and §5 (COM-1705). Today every Collection read shares one timeout and the 50,000-item / 20 MB cap. Aikido's full issue download is the case in point: COM-1693 shows it running past a 20-second limit.

**Chain:** on the chain — API

## What the person sees

- **Limits** on each read, with today's values as the defaults:
  - a timeout of up to 5 minutes (my call);
  - an item cap of up to 250,000 (my call);
  - a size cap of up to 100 MB (my call);
  - **retry once on a timeout** (off by default).
  
  Compass's hard ceilings can't be raised from the screen.
- **Incremental:** a read can take *changed since the last successful run* as a query value (e.g. `updated_since={last_success}`), in a declared format.
  - The first run, or a run after the feed changed, reads everything.
  - **A feed that reads incrementally can only close what the source says is closed.** The *missing from a complete read* rule is unavailable to it (the form greys it out and says why).
  - A **full read** still happens on a schedule (weekly by default, my call), to catch anything missed.
- A read that hits a limit is Broken with the limit named, and "raise the limit or narrow the read", as today.

## Done when

- Tested against a fake service: a slow answer under a raised timeout passes, one beyond the ceiling is refused, the retry works, the item and size caps work, incremental values are filled from the last *successful* run (not the last attempt), the weekly full read happens, and the closing rule is restricted.
- The configuration form, Polaris (COM-1702) and the assistant tools validate against the ceilings.
- No service name in code (COM-1696).

## Notes

- `core/collection/client.py` (`_too_big`, timeouts) and the read definition's schema.
- A longer timeout ties up a worker. Long reads go to the right Celery lane (memory: interactive worker lane, ToDo sweep 2026-10-28).