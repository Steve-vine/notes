---
id: 01M756B56J09AD8DP8NHNYE3WD
created: 2026-11-11T11:36:57.298139Z
updated: 2026-11-11T17:20:13.117406Z
type: task
title: The "looks like a secret" check stops mistaking capitalised secret names and paths for keys
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1726
sprint: sep79bz
comments:
- id: 01M75BM46RGKFMV1VKZ5WK0G92
  author: Steve Vine
  at: 2026-11-11T13:09:14.072285Z
  text: |-
    Built and merged to main (PR #1719, 2026-11-11). Goes to staging with the sprint.

    What changed:
    - Secret names in capitals and paths now pass the "looks like a secret" check: AWS_SECRET_ACCESS_KEY, POSTGRES_PASSWORD, Moneypenny-Development/docs/NPM_TOKEN, RootCause-IT/helm-charts/NPM_TOKEN.
    - "/" now separates words like "-", "_" and ".". Letters that fill a whole stretch between separators count as a word whatever their case. This goes a little beyond the "Done when": with only "capitals count", names like SENDGRID, ANTHROPIC and helm-charts still failed the vowel rule.
    - Real keys are still refused: provider prefixes (including all-capitals AKIA/ASIA), PEM blocks, long random tokens, and a key on the end of a path or after NAME=.

    Re-measured on the same seeded samples, old check vs new:
    - Random 32-byte url-safe tokens (2,000,000): 1 in 15,600 let through before, 1 in 14,700 after. That's within noise.
    - Other key shapes: unchanged.
    - Realistic secret names and paths (2,659): 2,211 refused before, 0 after.

    Still not caught, before or after: base32 secrets (capitals and digits only, such as TOTP seeds). Catching those needs its own task.

    Still to do after deploy (me): put the two GitHub feeds (Actions secrets, Deploy keys) back to plain "owner/repository" text.
- id: 01M75EHFZY21TQCTEQ5A8GPGMM
  author: Steve Vine
  at: 2026-11-11T14:00:13.566564Z
  text: |-
    Pre-UAT on staging (bb59b9a2), 2026-11-11: **Passed**.

    As E2E Admin A, in E2E Test Company ▸ Secrets ▸ Add a secret:
    - Name "E2E COM-1726 Moneypenny-Development/docs/AWS_SECRET_ACCESS_KEY", kept in "GitHub Actions Moneypenny-Development/infrastructure-terraform/NPM_TOKEN": saved as SEC-55. Before this fix, the check refused this shape.
    - A name with a GitHub-token-shaped value: refused, "That looks like a secret, so Compass won't save it (name)."

    Screenshots: ~/compass-uat/sj4f1kj/COM-1726/.

    Not done: I left the GitHub feeds' plain "owner/repository" text unchanged. Changing a live feed's mapping sends it back to waiting for approval, which would stop the three live GitHub feeds until Steve approves them again. Steve, say if you want it done, and approve the three feeds afterwards.
assignee: steve
label:
- bug
priority: medium
task_status: done
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