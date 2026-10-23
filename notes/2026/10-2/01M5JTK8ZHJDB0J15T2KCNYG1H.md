---
id: 01M5JTK8ZHJDB0J15T2KCNYG1H
created: 2026-10-22T22:09:38.801165Z
updated: 2026-10-23T16:06:17.317214Z
type: task
title: Mark a DDQ as sent — it's frozen with exactly what was said and which files went out, and can't be edited or deleted; to change anything you start the next one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1263
sprint: s5uw2fz
blocked_by:
- 01M5JTK2Q9VSGKR920T0GRJW8A
comments:
- id: 01M5MR6MEF4KFDBV7E8FBHE26J
  author: Steve Vine
  at: 2026-10-23T16:06:16.271176Z
  text: |-
    Done — merged in #1282 (a3ca32d3, migration 0675_ddq_sent).

    - Once a DDQ is **Ready to send**, someone who manages DDQs gets **Mark as sent** on the Review card: the date sent (today unless changed, never later) and how ("Uploaded to their portal", "Emailed to jane@acme.com"). It becomes **Sent**.
    - The window says which evidence pack is kept — the one last downloaded. With evidence to send but no pack downloaded, it asks "No evidence pack was downloaded — send without one?" and won't send until that's ticked or the pack is downloaded.
    - A sent DDQ can't be changed in any way: details, questions, answers, assignments, NDA, files, approvals, releases; no new pack. (Approved answers can still be added to the library.)
    - Its page shows the record kept at sending, not live data: a green "Sent" banner (when, how, who); **What went out** — the completed file or reply and the evidence pack with fingerprints and **Download as sent**; **Answers as sent** — each question as worded, the answer or why it was blank, its classification, whether it could be given, who approved it, sources and evidence with their versions; **NDA and releases when sent**.
    - Later library edits or reclassifications change nothing on it; its files download byte-for-byte as they went. Register and header read "Sent 23 Oct 2026".
    - **Start the next one from this** opens Log a DDQ with the same organisation and contact as a Recertification; the new one says "Started from DDQ-n".

    My calls:
    - Viewers can read the sent record; the two "as sent" downloads need Manage DDQs.
    - Saying it went without a pack wins even if one was downloaded.
    - Any assignments still open are closed as "taken back" when sending (a safety net — Ready to send already rules them out).
    - CI note: one frontend test failed under load (the Q&A library list, untouched by this task) and passed on a re-run.
assignee: steve
label:
- feature
priority: high
task_status: review
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