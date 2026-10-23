---
id: 01M5JTGR4C7JKR0VA69QBAT6CZ
created: 2026-10-22T22:08:16.012406Z
updated: 2026-10-23T18:06:19.643257Z
type: task
title: The Q&A library — each company keeps approved answers to the questions it gets asked, with other wordings, a short response, the detail, a classification, sources and evidence, and an owner; nothing is reusable until it's approved
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1250
sprint: s5uw2fz
blocked_by:
- 01M5JTGGVJ0PSZRE40R1K3Y2W9
comments:
- id: 01M5M0RYAN84F0YVGBC57VWWCX
  author: Steve Vine
  at: 2026-10-23T09:16:50.388908Z
  text: |-
    Done — merged in #1266 (adb9448d, migration 0610_qa_library).

    - **DDQ ▸ Q&A library** lists the company's entries: question, tags, classification, status, owner, review due, last used. One search box covers questions, other wordings and answers, and tolerates typos ("encrpyt"); filters for status, tag and classification.
    - **Add an entry** (Manage DDQs): the question and other ways it's asked; short response (Yes / No / N/A / Partial) and answer; sources (a policy or standard, a control, an evidence file or link, a trust centre document); evidence to include; owner; tags. Gaps, risks and assessment results are refused as sources.
    - Classification follows the highest of its sources (unclassified counts as Internal), including evidence classified under COM-1248; it can be set lower only with a reason, kept in History.
    - Draft → Submit for approval → Approve, or Send back with a comment (Approve DDQ answers only). Editing an approved entry starts a new draft; the approved one stays in use until the new one is approved, then it's marked superseded. Every version can be read on the entry's page. An entry can be retired: kept, never suggested again.
    - Another company never sees it.

    My calls:
    - **Whoever drafted an entry may approve it** if they hold Approve DDQ answers, so a lone admin isn't blocked. Say if you want a second person.
    - Retiring is final; to bring an answer back, add it again.
    - The owner must be someone who can view DDQs; changing owner or tags doesn't start a new version.
    - A classification freezes when its version is approved; while a draft it follows its sources live.
    - An evidence file or link can be cited only if it's in the company's Evidence register as the person sees it; vendor certificates aren't offered as sources.
assignee: steve
label:
- feature
priority: high
task_status: done
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