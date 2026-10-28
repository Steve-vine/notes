---
id: 01M5PV3E1YHKW5N97VAYWDM4Q0
created: 2026-10-24T11:35:26.014028Z
updated: 2026-10-28T13:05:11.77029Z
type: task
title: 'Evidence search test flakes: "each group is capped" sometimes counts 12 files, not 10'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1279
assignee: steve
label:
- bug
priority: low
task_status: active
---
Seen 2026-10-24 on PR #1286 (COM-1278, a pypdf bump; nothing to do with search): `tests/test_evidence_search.py::test_each_group_is_capped_and_show_all_lifts_one` failed with `assert 12 == 10`. It passed on #1285 the same morning, so it's intermittent. Nothing users see; it costs a CI rerun when it hits.

**Chain:** independent (test only)

## Likely cause (technical)

- The test searches `capped-{tag}` and expects exactly its 10 files. `_world()` also puts `firewall-review-{tag}.pdf` and `privileged-access-{tag}.pdf` in the same company, and the search's trigram word-similarity (threshold 0.3) can match them through the shared random 6-hex `tag`. Two extra = 12.
- Whether they cross the bar likely depends on the tag's characters, hence intermittent.
- Fix: search a query that doesn't contain the shared tag (e.g. give the capped files their own uuid fragment), or assert on the capped files' ids rather than the total.

**Done when:** the test's expected files can't overlap the world's other files by name, and it passes repeatedly.