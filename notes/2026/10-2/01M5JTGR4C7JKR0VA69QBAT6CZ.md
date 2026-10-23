---
id: 01M5JTGR4C7JKR0VA69QBAT6CZ
created: 2026-10-22T22:08:16.012406Z
updated: 2026-10-23T07:47:17.511055Z
type: task
title: The Q&A library — each company keeps approved answers to the questions it gets asked, with other wordings, a short response, the detail, a classification, sources and evidence, and an owner; nothing is reusable until it's approved
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1250
sprint: s5uw2fz
blocked_by:
- 01M5JTGGVJ0PSZRE40R1K3Y2W9
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — migration + API

## What people see

**DDQ ▸ Q&A library:** the company's entries. Columns: question, tags, classification, status, owner, review due, last used. Search over questions, other wordings and answers. Filters: status, tag, classification, due for review.

**An entry:**
- **Question**, plus **other wordings** ("Do you encrypt data at rest?" / "Is stored data encrypted?").
- **Short response** (optional: Yes / No / N/A / Partial) and **Answer** (the detail).
- **Classification** (COM-1245 call 7: defaults to the highest of its sources; set lower with a reason).
- **Sources:** a policy or standard, a control, an evidence item, a trust centre document. **Evidence** to attach when it's used.
- **Owner**, **tags**, and **Used in** (the DDQs it went into, once those exist).

**Lifecycle:** Draft → Awaiting approval → **Approved** → Retired. Editing an approved entry makes a new draft version; the approved one stays in use until the new version is approved. Only someone with *Approve DDQ answers* approves, and they can send it back with a comment. Every version is kept.

Manage DDQs can add and edit entries; View DDQs can read them.

## Notes (technical)

- Company-scoped tables: entry, versions (append-only), wordings, sources (polymorphic links like evidence links), evidence attachments.
- Gaps, risks and assessment results are not allowed as sources (COM-1245 call 8).
- Text search with pg_trgm / full-text across question + wordings + answer; this same search backs suggestions in the answering task.

**Done when:** an entry is drafted, sent back, corrected and approved; editing it leaves the approved version in use until the new one is approved; another company doesn't see it.