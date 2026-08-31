---
id: 01M1BDZKQS87BZD4C8F6MJH1EP
created: 2026-08-31T08:11:43.225871Z
updated: 2026-08-31T08:46:52.106177Z
type: task
title: 'The mirror is stuck: a group that changed twice makes a $batch Graph refuses'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 547
comments:
- id: 01M1BE6YHSAMB1AF3399DR55VV
  author: Steve Vine
  at: 2026-08-31T08:15:43.673678Z
  text: |-
    Diagnosis confirmed, not inferred — reproduced locally on feature/com-547-batch-duplicate-ids.

    The fake tenant did not enforce Graph's envelope rules, which is why this got through CI in the first place: a `$batch` with duplicate sub-request ids sailed through the tests and only failed against a live tenant. Made the fake refuse what Graph refuses (>20 sub-requests, or two sharing an `id`), and the bug reproduced immediately with the identical message staging shows — `Microsoft 365 error (HTTP 400)`.

    That is the real lesson here. The test double was more permissive than the thing it stood in for, so the contract it was supposed to protect was unguarded.

    **Fix:** `sorted(set(...))` before chunking, in both `_crawl_group_edges` and `_crawl_device_owners`. Asking twice for one group's members never meant anything — the answer belongs to the group, not the request — and the returned dict already collapsed duplicates, so nothing downstream changes.

    **Self-heals.** The stuck deltaLink was never advanced, so the next pass after deploy replays that same window, now dedupes it, succeeds, and banks a fresh link. No manual resync, no waiting for the nightly backstop.

    **Also done:** `graph_batch` now logs Graph's body on an envelope-level refusal (`graph_status`, `graph_body`, capped at 2000 chars). The sentence on the status row is untouched — that is COM-518's wording for a reader, and this is for whoever reads the logs. Covered by a test asserting the log line carries what Graph said.

    Three new tests: a group surfacing twice in one window, the same for devices, and the refusal logging.
assignee: steve
company:
- moneypenny
label:
- bug
priority: urgent
task_status: done
---
Found on staging (`staging-20260831-0741`) while verifying COM-520. **The directory mirror sync fails on every pass, and cannot recover on its own.**

```
POST https://graph.microsoft.com/v1.0/$batch "HTTP/1.1 400 Bad Request"
Directory mirror sync failed
```

Identical at 07:45 and 08:00, ~4–8s into the pass, always the `$batch` immediately after `GET /contacts` — that is `_crawl_group_edges` on the delta path.

**Not COM-520.** The whole code delta staging took in that deploy is COM-520's files, and the crawl is byte-identical to the build staging ran before it. This is older; COM-520 is only what made someone look.

## What is happening

`graph_get_delta` concatenates every delta page into one list with **no deduplication**, and Graph's delta legitimately returns the same object more than once in a window. `_run_delta_pass` then builds

```python
surviving_group_ids = sorted(str(raw["id"]) for raw in changed_groups if "@removed" not in raw)
```

— a **list**, duplicates intact. `_crawl_group_edges` chunks it ten at a time and gives each sub-request the id `f"{edge}:{group_id}"`. A group id appearing twice inside one chunk therefore emits **two sub-requests with the same `id`**, and Graph rejects the whole envelope with 400 rather than failing one entry. That is why the failure is envelope-level rather than per-sub-request, which nothing else here explains.

**COM-521 is what made it common.** Putting `members` in the groups delta `$select` is what makes a membership-only change surface its group — so a group now surfaces *once per membership change*, and a busy group appearing several times in one window went from rare to routine.

**Why it never recovers.** A failed pass never banks the new deltaLink, so the next pass replays the identical window and fails identically. The mirror is frozen at whatever it last held and will stay there. That is the urgent part: this is not a pass that occasionally fails, it is a mirror that has stopped.

`_crawl_device_owners` has the same latent shape (`sorted(...)` of a delta list, device id as the sub-request id). It is not failing because devices do not surface repeatedly the way membership-changed groups do — but it should be fixed in the same pass rather than left as the next one to go off.

## The fix

- Deduplicate the ids before the crawls — the crawl asks for *a group's* members and owners, so asking twice was never meaningful, and the reconciliation downstream is keyed by group.
- A regression test that a delta returning the same group twice produces a `$batch` with unique sub-request ids. It is the batch body that has to be right, so assert on the request Graph is handed.
- Do the same for the device crawl.

## Also, and this is why it cost an investigation

`graph_batch` turns a failed response into `Microsoft 365 error (HTTP 400)` and **throws away Graph's body**, which is where Microsoft says what was actually wrong. A 400 that explains nothing is exactly the gap COM-518 closed for the refused reads. Log the body (structured log, not the card's sentence — COM-518 owns that wording), so the next envelope-level refusal is diagnosable from the logs instead of by inference.
