---
id: 01KZ3Q8R140FTJD7T9JMYRB4YS
created: 2026-08-03T11:48:40.612814Z
updated: 2026-08-13T19:00:13.741232Z
type: task
title: 'Pack interpreter core: auth, pagination, retry menus'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 502
sprint: s1mg25q
comments:
- id: 01KZF8JBS8H8NGEJ7XW3JJREX5
  author: Steve Vine
  at: 2026-08-07T23:22:40.295908Z
  text: |-
    Done — PR #537 (branch feature/ise-502-pack-interpreter, stacked on #536).

    `packs/interpreter.py` — the generic version of code written eight times by hand in `connectors/`: build a client, authenticate from a short menu, walk a list endpoint by one of four idioms, honour a 429 once, hand back the items. Nothing in it is authored by a pack; a pack *chooses* from menus this module implements, which is exactly what keeps "packs execute no code" structural rather than a review promise.

    **Bounds a pack cannot relax**
    - Timeouts and connect retries from `http_bounds` (ADR 0092), like every other outbound client.
    - One bounded 429 wait (capped 30s), then the error surfaces — the task is already the retry.
    - A platform page cap of 50 that `page_limit` may *lower* and nothing may raise, plus cursor-repeat detection, so a source that pages forever or in a circle can't hold a worker. A capped walk is **logged with its counts** rather than quietly coming back short: a pack hitting the cap needs a narrower `query`, and nobody learns that from a number that merely looks small.

    **The design point worth keeping: pagination has two terminations, not one.**
    A CURSOR idiom (`next_link`, `link_header`) is source-driven — it continues across an empty page and stops when the cursor is absent or repeats. A COUNTER idiom (`page_number`, `offset`) is ours — nothing tells us where the end is except running off it, so an empty (or short) page is the only end there is. My first cut used one loop with a shared empty-page stop, which would truncate a source that pads a page and loop on one that doesn't.

    **A source-supplied next link is confined to the configured host.** It's the one place a source chooses where ISE's next request goes, carrying that integration's credential; an off-host link is refused, not followed.

    Two smaller calls:
    - An empty credential field fails at the client with the field named, rather than reaching the source as `Authorization: Bearer ` and coming back 401 — which sends whoever reads the card looking at the source's IAM instead of at the empty box in ISE.
    - The OAuth client-credentials token is cached per client (so per connector call), not globally: a discovery pass over several endpoints pays for the exchange once, and the cache can't outlive the credential it was minted from.

    Health probing lands here too — `PackConnector.health_check` now makes the one cheap authenticated call instead of the honest-but-temporary `degraded` from ISE-501. A pack with no health endpoint reports connected *and says nothing was probed*, rather than either claiming a check that never ran or showing permanent amber on a working integration.

    28 contract tests over `httpx.MockTransport`: every auth scheme, every pagination idiom and where it stops, the cap, the cycle, the off-host link, both 429 paths, non-JSON, transport failure, and the item-extraction shapes. Brief updated so the documented semantics match the implementation exactly.

    Test-fixture trap worth noting: YAML is whitespace-significant, and a `textwrap.dedent`-ed f-string with `textwrap.indent`-ed blocks injected into it produces a document that fails to parse for reasons that have nothing to do with the test. Fixtures now join explicit lines.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
The generic HTTP engine a pack drives: auth schemes (header token / basic / client-credentials OAuth), pagination styles (nextLink follow / page counter / Link header / offset), the standard bounded Retry-After 429 retry, page caps and runaway guards, per-System containment on failure. Headless core with contract tests against fakes; no pack-authored code ever executes — the interpreter is the only executable.