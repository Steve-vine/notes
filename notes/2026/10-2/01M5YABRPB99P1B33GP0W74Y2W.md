---
id: 01M5YABRPB99P1B33GP0W74Y2W
created: 2026-10-27T09:16:48.715525Z
updated: 2026-10-27T09:19:09.369156Z
type: task
title: A retest report closes what was fixed — linked to the original pen test, Polaris proposes which earlier findings are resolved, still open or new, and a person confirms
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1380
sprint: ssp4evc
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 92, Vulnerabilities - Scanner sources (ADR in COM-1374). Builds on COM-1379.

Pen-test findings have no scanner to confirm a fix. The tester's retest is the confirmation.

## What people see

- **Import ▸ Pen-test report** has **"This is a retest of…"**, choosing an earlier pen-test import.
- **The retest's import page lists each of the original's findings**, each with:
  - a proposal: **Resolved**, **Still open** or **Not retested**;
  - a page reference;
  - plus any **new** findings the retest raised.
  - Polaris fills the proposals when it's on; otherwise a person sets them.
- **On confirm:**
  - Resolved findings become **Fixed — confirmed by retest**. A person's earlier "fixed, waiting to confirm" turns confirmed;
  - Still open stays open and gains a sighting from the retest;
  - Not retested changes nothing;
  - new findings are recorded as in the first import.
- **The original import page** shows its retests and how many findings each resolved.

## Who can do what

Work vulnerabilities.

## Notes (technical)

- A retest is an import with a parent import. The proposal rows reference the original findings' vulnerabilities.
- Polaris gets the original findings as context for the read, so it can match them.

**Chain:** on the chain (migration + API).

**Done when:** a retest closes the resolved findings, keeps the open ones open and records new ones, all after a person's confirm.