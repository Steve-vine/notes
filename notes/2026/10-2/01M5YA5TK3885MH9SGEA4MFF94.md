---
id: 01M5YA5TK3885MH9SGEA4MFF94
created: 2026-10-27T09:13:34.051631Z
updated: 2026-10-28T18:17:05.29734Z
type: task
title: Record a vulnerability by hand — what it is, how severe, which system it's on and where, who found it and when, and what to do about it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1364
sprint: s6wypy5
blocked_by:
- 01M5YA5FNN8E7S95BP3X56P1JR
comments:
- id: 01M5ZDJYFGBQ04ZH2R8RY57397
  author: Steve Vine
  at: 2026-10-27T19:32:24.175748Z
  text: |-
    Built and merged: PR #1379.

    **What's there**
    - Register ▸ **Record a vulnerability** opens a window laid out as people think about it: what it is, how severe, where, who found it, what to do. Choosing several systems records one vulnerability on each, and the window says so before saving.
    - A **CVSS 3.1 vector** fills in the score and severity. A 4.0 vector is recognised, but its score is typed in from the source.
    - **CVE IDs** are checked for shape. Recording the same CVE twice on one system is refused, because each issue gets one vulnerability per system.
    - **Fix-by** comes from the severity's target. The **owner** is the system's owner, or the company's default.
    - Window closes ask before throwing away what was filled in.

    **My calls**
    - **Attachments** (a pen-test report or screenshots) moved out to **COM-1388**. They should go through the Evidence register like every other file, not a second upload path, and that needs the vulnerability's page (COM-1366) first.
    - "Found by" is a person *or* a vendor (a pen-test firm), never both.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1363.

## What people see

- **Register ▸ Record a vulnerability** opens a window, laid out in the order it's thought about (IA brief: *A request is raised in a window*).
- **What it is:**
  - title;
  - kind (Software flaw, Misconfiguration, Code weakness, Exposed secret, Other);
  - description;
  - CVE IDs, optional, one or more. Each is checked for shape, `CVE-YYYY-NNNN…`.
- **How severe:**
  - severity (Critical to Informational);
  - optionally a CVSS score and vector. Entering a vector fills in the score, and the severity is suggested from the score.
- **Where:**
  - the system (a technology asset of this company);
  - and optionally where exactly: free text such as hosts, URLs, a repository or an image.
  - Choosing **several systems** records one vulnerability for each, and the window says "This records 3 vulnerabilities".
- **Found:**
  - found by: a person, or a vendor from the register, e.g. a pen-test firm;
  - found on: a date, defaulting to today;
  - attachments, such as screenshots or a report extract.
- **What to do:** a recommendation (free text).
- **On save:**
  - the vulnerability gets its `VUL-` reference;
  - the owner is the system's owner, or the Settings default;
  - the fix-by date comes from the rubric;
  - the source is shown as **Recorded by hand**.
- The window asks before throwing away what was filled in.

## Who can do what

Work vulnerabilities.

## Notes (technical)

- A hand-recorded item is a vulnerability with one "manual" sighting. Later tasks treat every source the same way.
- The CVSS 3.1 and 4.0 vector-to-score calculation is a small, tested function. No dependency unless a maintained one exists.
- Attachments use the attachment store, in the shape of risk attachments.

**Chain:** on the chain (API).

**Done when:**
- a vulnerability can be recorded with every field;
- several systems make several records;
- each appears in the register with the right fix-by date;
- the activity log has it.