---
id: 01M73Q824SWZRYHWVQQVY02Z4E
created: 2026-11-10T21:53:52.793616Z
updated: 2026-11-10T22:42:27.948626Z
type: task
title: 'A test enforces the hard rule: the build fails if collection or feed code names a particular service or branches on one'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1696
sprint: sep79bz
blocked_by:
- 01M73Q7RCSCADP3Q90XQM3PQSZ
assignee: steve
label:
- chore
priority: high
task_status: active
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