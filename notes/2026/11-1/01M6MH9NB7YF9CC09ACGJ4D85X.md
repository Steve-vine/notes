---
id: 01M6MH9NB7YF9CC09ACGJ4D85X
created: 2026-11-05T00:21:17.287266Z
updated: 2026-11-10T08:58:58.86809Z
type: task
title: 'Secrets: a random key in a note is sometimes not caught (flaky test_secret_guard[random])'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1594
comments:
- id: 01M72AX43HCF9H35ECCDFCS82S
  author: Steve Vine
  at: 2026-11-10T08:58:57.009084Z
  text: |-
    **Done: merged to main in PR #1670.**

    **Why it missed:** about one random key in 33 (601 of 20,000 tried) was let through. Its "this is mostly words, so it's a name" test counted random letter runs like `Jotsekqrc` or `UUTRW` as words. Ten of the misses had no digit, which the guard required.

    **What changed:** a word now has to look like one:
    - three or more letters, at least a quarter of them vowels, and never four consonants in a row;
    - an all-capitals word is at most four letters (API, AWS);
    - a word starting lower case counts only at the start or after `-`, `_` or `.`.

    A digit is no longer required.

    **Result** (300,000 random keys tried locally): misses fell to about one in 17,000. Every name-like example still passes, including four new ones (a long camel-case name, an acronym path, a dotted name, a name with a year). It remains a safety net, not a guarantee: no single measure cleanly separates random keys from names.

    **Tests:** the key that slipped through on PR #1609 is now a fixed case. A seeded sample of 1,000 random url-safe keys must all be caught, and 995 or more of 1,000 seeded alphanumeric keys. Nothing depends on chance, so the flaky test is gone.

    **On staging:** nothing to look at on screen. Pasting a random key into a secret's notes is refused, as before, just more reliably.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
The guard that refuses key-shaped text in a secret's notes or description (ADR 0141 §2, COM-1564) sometimes misses a real random token. The unit test `tests/test_secret_guard.py::test_key_shaped_text_is_caught[random]` builds `"the key is " + secrets.token_urlsafe(32) + " for prod"` fresh each run, and it failed on PR #1609 (2026-11-05) with:

`looks_like_key('the key is k9QKICdjcAJotsekqrcSFlImzBDgnYyiUcRUUTrwAQk for prod')` → False

A rerun passed. So it's a real false negative some of the time, not just a flaky test: someone pasting a key like that would get it saved.

**Done when:** that token, and any `token_urlsafe(32)` text, is caught every time. The test checks a fixed sample of tokens (or a seeded loop of a few hundred) so it can't pass or fail by chance, and the "lets through" cases still pass.

**Where to look:** `core/secrets/guard.py` `looks_like_key`. A run must be mixed-case with digits, above `_MIN_ENTROPY`, and not `_wordy`. Check which of these rejects the sample. `_wordy` is the likely one, since a long random run can contain dictionary-looking substrings. Also check whether `-`/`_` split the run in `_RUN`.

Found by Claude while building Initiatives - improvements (not part of that sprint).