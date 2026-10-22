---
id: 01M5JTK8ZHJDB0J15T2KCNYG1H
created: 2026-10-22T22:09:38.801165Z
updated: 2026-10-22T22:10:23.269432Z
type: task
title: Mark a DDQ as sent — it's frozen with exactly what was said and which files went out, and can't be edited or deleted; to change anything you start the next one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1263
sprint: s5uw2fz
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — migration + API

## What people see

**Mark as sent** (owner, once Ready to send): the date sent and how ("Uploaded to their portal", "Emailed to jane@acme.com"). The DDQ becomes **Sent**:
- Everything is read-only: the questions as worded, the answers, their sources and classifications, the NDA position, and any releases.
- **What went out** is kept: the completed file and the evidence pack exactly as downloaded at sending (with fingerprints), or the reply text.
- The register shows the sent date. The DDQ page has **Start the next one from this** (the recertification task).

Later edits to the library, a policy or a classification don't change a sent DDQ.

## Notes (technical)

- Freeze by snapshot on send (the ADR 0032 §4 pattern): answer text, source titles and versions, classification names, rule outcome, file fingerprints. The completed file and pack are stored, not regenerated.

**Done when:** after sending DDQ-1, editing its library entry and reclassifying a policy leaves DDQ-1's record unchanged, and its pack downloads byte-for-byte as sent.