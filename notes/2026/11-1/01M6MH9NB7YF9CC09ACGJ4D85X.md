---
id: 01M6MH9NB7YF9CC09ACGJ4D85X
created: 2026-11-05T00:21:17.287266Z
updated: 2026-11-10T08:42:01.143548Z
type: task
title: 'Secrets: a random key in a note is sometimes not caught (flaky test_secret_guard[random])'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1594
assignee: steve
label:
- bug
priority: medium
task_status: active
---
The guard that refuses key-shaped text in a secret's notes or description (ADR 0141 §2, COM-1564) sometimes misses a real random token. The unit test `tests/test_secret_guard.py::test_key_shaped_text_is_caught[random]` builds `"the key is " + secrets.token_urlsafe(32) + " for prod"` fresh each run, and it failed on PR #1609 (2026-11-05) with:

`looks_like_key('the key is k9QKICdjcAJotsekqrcSFlImzBDgnYyiUcRUUTrwAQk for prod')` → False

A rerun passed. So it's a real false negative some of the time, not just a flaky test: someone pasting a key like that would get it saved.

**Done when:** that token, and any `token_urlsafe(32)` text, is caught every time. The test checks a fixed sample of tokens (or a seeded loop of a few hundred) so it can't pass or fail by chance, and the "lets through" cases still pass.

**Where to look:** `core/secrets/guard.py` `looks_like_key`. A run must be mixed-case with digits, above `_MIN_ENTROPY`, and not `_wordy`. Check which of these rejects the sample. `_wordy` is the likely one, since a long random run can contain dictionary-looking substrings. Also check whether `-`/`_` split the run in `_RUN`.

Found by Claude while building Initiatives - improvements (not part of that sprint).