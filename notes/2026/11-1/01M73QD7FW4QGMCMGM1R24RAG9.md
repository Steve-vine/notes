---
id: 01M73QD7FW4QGMCMGM1R24RAG9
created: 2026-11-10T21:56:42.108313Z
updated: 2026-11-11T11:49:43.401249Z
type: task
title: 'Limits and incremental reads per read: each read sets its own timeout, size caps and one retry within Compass''s ceilings, and can ask only for what changed since the last good run'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1709
sprint: sj4f1kj
blocked_by:
- 01M73QBT1QP9E6549CQ1C4XX5Y
- 01M73Q8M80365XPSJR7G8BG302
comments:
- id: 01M746Z0FEPQFHTN5SN7WPNHM2
  author: Steve Vine
  at: 2026-11-11T02:28:33.390192Z
  text: |-
    Merged to main in #1708.

    What it does: each read in a feed can set its own limits under the read in the editor: a timeout up to 300 seconds (30 by default), up to 250,000 items (50,000), up to 100 MB (20), and "Try once more if it times out". Compass's ceilings can't be raised from the screen. A read that hits a limit is Broken with the limit named and "raise the limit or narrow the read". Reads without limits behave exactly as before.

    A read can also ask "only what changed" by naming the query value (e.g. updated_since) and how the time is sent (date and time, date, seconds or milliseconds). The first run, a run after the feed changed, and one every 7 days (or as set) read everything. The rest ask from the start of the last good run, so a failed run never moves it. Such a feed can only close what the source says is closed: "missing from a complete read" is greyed out with why. An empty read of changes is normal and isn't held. Each run in the history says "Only what changed since …" when it read only changes.

    Feed runs stay on the background worker lane, so a long read never ties up the interactive lane.

    Tests: test_collection_limits.py, test_feed_incremental.py (integration), FeedsTab test.
- id: 01M749989WPGBMPY96DDRGB4KV
  author: Steve Vine
  at: 2026-11-11T03:09:06.236469Z
  text: |-
    Pre-UAT on staging (74c7156f), as E2E Admin A on GitHub ▸ Feeds ▸ Add a feed (nothing saved): **Passed**, with one defect fixed forward in COM-1718.
    - Each read shows Timeout (seconds), Most items, Most MB, "Only what changed, as", "The time sent as", "Read everything every" and "Try once more if it times out", each with its limit in the hint.
    - With "Only what changed" filled in, "When a complete read no longer has it" is greyed out and the hint explains why.
    - Defect (COM-1718): if that rule was already chosen it stayed chosen, so saving would have been refused. It now switches to "When the source says so".
    - **Couldn't check:** a live slow or incremental read. That needs a real service and feed (COM-1715, Aikido).
    Screenshot: ~/compass-uat/sj4f1kj/COM-1709/feed-editor.png
assignee: steve
label:
- feature
priority: high
task_status: done
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