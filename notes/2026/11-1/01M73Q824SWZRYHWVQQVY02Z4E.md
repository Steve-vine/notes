---
id: 01M73Q824SWZRYHWVQQVY02Z4E
created: 2026-11-10T21:53:52.793616Z
updated: 2026-11-10T23:17:30.258068Z
type: task
title: 'A test enforces the hard rule: the build fails if collection or feed code names a particular service or branches on one'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1696
sprint: sep79bz
blocked_by:
- 01M73Q7RCSCADP3Q90XQM3PQSZ
comments:
- id: 01M73W15437NXMWGANA1CQEBBT
  author: Steve Vine
  at: 2026-11-10T23:17:29.347696Z
  text: |-
    **Done: merged to main in PR #1696.**

    **`tests/test_no_service_names.py`** (unit suite) reads the collection and feed code: `core/collection/`, `core/feeds/`, their tasks, `api/v1/collection_*` and `collected_checks`, and the Collection chat tools. It fails, naming the file, line and word, on:
    - a known service's name or host in an identifier or a short string. The list (about 40 names) lives in the test and grows;
    - a comparison of an integration's name, slug or address with a literal.

    **One change from the task:**
    - **Prose is allowed without a marker.** That covers comments, docstrings, and sentences in strings (at least four spaces): Polaris's instructions give real services as examples, and those are explanations, not logic.
    - **Code can only get through with** `# service-names: allowed (<reason>)` on the line. Nothing uses it today.
    - **A self-test** checks that it catches a literal and a comparison, and lets prose and the marker through.

    **Two things on main broke the rule; both are fixed here:**
    1. **The logo table** in `core/collection/marks.py` (Compass's own logos for GitHub, SendGrid, Tenable, Aikido…) is now data: `data/logos/marks.json`.
    2. **The key-expiry header.** `client.py` read GitHub's `github-authentication-token-expiration` header by name. It now reads a key's expiry from any answer header whose name says a token or key expires (`…-token-expiration`, `x-key-expires`, `token-expiry`). New unit test.

    `brief/ways-of-working.md` says what to do when it fails (merged with ADR 0147).

    **Independent:** no migration, no API change.
assignee: steve
label:
- chore
priority: high
task_status: review
---
Part of ADR 0145 (COM-1695). Steve's hard rule is that every bit of logic lives in the integration's configuration, never in code that knows a service. A rule that only lives in a document drifts, so a test holds it.

**Chain:** independent (a test only)

## What it checks

- The collection and feed code (`core/collection/`, the new feed modules, their tasks, and the Collection chat tools) contains none of these:
  - a known service's name, as a word in code or a string: github, aikido, nessus, cloudflare, datadog, mongodb, atlas, sendgrid, dependabot, tenable, snyk… The list lives in the test and grows;
  - a service's host (`api.github.com`, `aikido.dev`…);
  - a comparison against an integration's name, slug or ID (e.g. `integration.name ==`, `slug in (…)`).
- Docstrings and comments may name a service as an example, but only where they're marked so the test skips them. The marker is spelled out in the test, so nobody has to guess it.
- Tests and fixtures are exempt. They need real services' shapes to test against.
- Coded (Core) integrations are outside the check: they're a different kind and are allowed to know their platform.

## Done when

- The test runs in the unit suite and fails with the file, line and the word it found.
- It passes on main today. If something already breaks the rule, it's fixed in this task or listed in a comment for Steve.
- A short note in `brief/ways-of-working.md` says what to do when it fails: add a general capability to the configuration language, never an exception for one service.