---
id: 01M756B56J09AD8DP8NHNYE3WD
created: 2026-11-11T11:36:57.298139Z
updated: 2026-11-11T12:29:33.631063Z
type: task
title: The "looks like a secret" check stops mistaking capitalised secret names and paths for keys
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1726
sprint: sep79bz
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found on staging 2026-11-11: the GitHub App's "Actions secrets" and "Deploy keys" feeds (COM-1713) broke. Compass refused the whole read because a stored field "looks like a secret's value", but the fields were harmless.

The check (ADR 0141 §2, `core/secrets/guard.py`) looks at any unbroken run of 32 or more key-like characters, and "/" counts as part of the run. A run that is mixed case, high in entropy and not mostly words is refused. Two common shapes fool it:
- **Capitalised secret names**, the usual way secrets are named. "Moneypenny-Development/docs/NPM_TOKEN" and ".../AWS_SECRET_ACCESS_KEY" are refused, because an all-capitals word over four letters ("SECRET", "ACCESS", "TOKEN") doesn't count as a word.
- **Paths**: a lower-case word straight after "/" doesn't count as a word either. This is the likely cause for a private repository's full name in Deploy keys.

Worked round in the feeds' mappings for now: the parts are joined with " / " or ":", which break the run.

**Chain:** independent

## What the person sees
- A secret named in capitals, or a path such as owner/repository/NAME, is saved and read, not refused.
- Real keys are still refused: provider prefixes, PEM blocks and long random tokens.

## Done when
- A capitalised word between "_", "-", "/", "." or the run's ends counts as a word (so "AWS_SECRET_ACCESS_KEY" passes), and a lower-case word after "/" counts as one.
- The guard's tests still refuse every real-key sample, and the false-alarm rate on random tokens is re-measured and stated, as COM-1594 did.
- The two GitHub feeds go back to plain "owner/repository" text.