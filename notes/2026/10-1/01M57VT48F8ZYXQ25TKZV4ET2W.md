---
id: 01M57VT48F8ZYXQ25TKZV4ET2W
created: 2026-10-18T15:59:13.167045Z
updated: 2026-10-19T01:39:09.625379Z
type: task
title: Attestations ▸ Compliance shows who is up to date — by role, by content and by person — with a person's full history of what they were asked, what they signed and when
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1100
sprint: s7s7mn9
blocked_by:
- 01M57VSQSH1S16GRE5WP9ECNW4
comments:
- id: 01M58X013GJW06ZWBQZ0ZS6CHV
  author: Steve Vine
  at: 2026-10-19T01:39:09.552626Z
  text: |-
    Done: PR #1090, built on top of #1089, all checks green, waiting to be merged in order.

    - Attestations has a Compliance tab with a By role / By content / By person switch. The view, filters, search and sort stay in the address.
    - By role shows each role's people, % compliant ("1 of 3"), outstanding, overdue and number of documents. Clicking a role opens a grid of its people against its documents, with a tick, a clock or a red mark in each cell and the date signed or due. Overdue people come first.
    - By content shows each document's roles, people asked, % compliant, overdue and current version. Clicking one shows everyone asked, grouped by role, with the version and date they last signed.
    - By person puts overdue people first and can be searched by name. A "Show people who no longer hold a role" switch brings back people who have left, so their history can still be found.
    - A person's page has three parts: what this company asks of them now (status, due date, which roles), every signature they've ever made (document, version, when, on time or late, the name they typed), and every round they were in and how it ended.
    - Names on a round page now link to the person's page.

    Calls I made:
    - "Compliant" means up to date with every role that currently asks the person for that document. Their standing across the company is their worst role.
    - Anyone who can see Attestations can see every company's roles in a person's history. This matches how the company switcher already works: everyone who can read company data can see every company.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 78, Attestations (ADR in COM-1092). Builds on the module and Open tab (COM-1099).

## What "compliant" means

A person is **compliant** for a document when nothing is outstanding: every role that assigns it to them is satisfied by a signature that counts (COM-1094). **Overdue** means at least one deadline has passed unsigned. **Outstanding** means it's asked and not yet due. Compliance is **now**, not per round. Rounds are what Open is for.

## What people see

A **Compliance** tab with a **By role / By content / By person** switch:

- **By role**: each role with **People**, **Compliant** (% and count), **Outstanding**, **Overdue**, and the number of documents assigned. Click through to the role's people × documents grid, with a tick, a clock or a red mark in each cell.
- **By content**: each document with **Roles assigned**, **People asked**, **Compliant %**, **Overdue**, and the current version. Click through to everyone asked, grouped by role, with what they last signed.
- **By person**: each person who is asked anything, with **Roles**, **Documents**, **Compliant %**, **Overdue**. Search by name. Overdue people come first.
- **A person's page** (from any of the above, or from Open): every document they're asked, with status, due date and the roles asking, plus their **full history**: every signature ever (document, version, signed at, on time or late, typed name) and every round they were in and how it ended. It includes roles they no longer hold.

Filters (role, content, overdue only) are kept in the address. The company switcher scopes it as usual.

## Rules

- Content assigned in another company doesn't count here, but a signature made because of another company's role does (sign once).
- People who have left every role drop out of By role and By content. Their page and history are still reachable from search on By person.

## Notes (technical)

- Read-only endpoints under `/api/v1/attestations/compliance/…`. Compute in SQL, not by loading every row into Python, because a company can have thousands of people × dozens of documents.
- Unit-test the compliant/outstanding/overdue status against COM-1094's rule cases.

**Done when:** an admin can answer "is this role, this document or this person up to date, and if not who or what is missing" in two clicks, and see a person's complete history.