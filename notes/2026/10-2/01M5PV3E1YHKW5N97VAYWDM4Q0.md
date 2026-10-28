---
id: 01M5PV3E1YHKW5N97VAYWDM4Q0
created: 2026-10-24T11:35:26.014028Z
updated: 2026-10-28T14:51:03.153632Z
type: task
title: 'Evidence search test flakes: "each group is capped" sometimes counts 12 files, not 10'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1279
comments:
- id: 01M61FWD4Q3KTB740VNZEH4REA
  author: Steve Vine
  at: 2026-10-28T14:51:00.11925Z
  text: |-
    Done. PR #1412, merged to main at 9c01c8bd. Test-only, so nothing changes on screen.

    The evidence search tests no longer fail now and then. Cause proved: the tests label their files with six random characters. About one run in 360 those characters were all letters, and the search then treated the label as words, making it a near-match for the setup's other two files (12 found instead of 10). A neighbouring test failed the same way (the restricted-incident test found 2 files instead of 0). The label is now always digits, which are matched exactly.

    Technical: forcing the tag to "beadfc" reproduced both failures every time (12 == 10, 2 == 0). _world() in tests/test_evidence_search.py now uses uuid4().int % 1_000_000 as six digits. With the fix, both tests passed 15 runs each and the whole file passes.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Seen 2026-10-24 on PR #1286 (COM-1278, a pypdf bump; nothing to do with search): `tests/test_evidence_search.py::test_each_group_is_capped_and_show_all_lifts_one` failed with `assert 12 == 10`. It passed on #1285 the same morning, so it's intermittent. Nothing users see; it costs a CI rerun when it hits.

**Chain:** independent (test only)

## Likely cause (technical)

- The test searches `capped-{tag}` and expects exactly its 10 files. `_world()` also puts `firewall-review-{tag}.pdf` and `privileged-access-{tag}.pdf` in the same company, and the search's trigram word-similarity (threshold 0.3) can match them through the shared random 6-hex `tag`. Two extra = 12.
- Whether they cross the bar likely depends on the tag's characters, hence intermittent.
- Fix: search a query that doesn't contain the shared tag (e.g. give the capped files their own uuid fragment), or assert on the capped files' ids rather than the total.

**Done when:** the test's expected files can't overlap the world's other files by name, and it passes repeatedly.