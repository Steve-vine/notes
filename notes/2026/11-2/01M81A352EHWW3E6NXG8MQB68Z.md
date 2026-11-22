---
id: 01M81A352EHWW3E6NXG8MQB68Z
created: 2026-11-22T09:41:13.422755Z
updated: 2026-11-22T09:41:13.422755Z
type: task
title: A workflow checks evidence against a register — a register lookup (is on, is not on, at least N are on), read once per run, with a warning before a field a workflow uses is changed
assignee: steve
label: feature
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2092
---
Sprint "Registers - Phase 2" (ADR 0167 §4, in COM-2087). Builds on the phase-1 registers (after COM-2084).

## What people see
- In a workflow's condition, **Look up ▸ A register** joins the document list, Inventory, Secrets and Vulnerabilities.
- Choose a register and one of its fields, then a test against each captured item's field:
  - **is on** — every item's value is among the register's values ("every supplier in this export is on Approved suppliers")
  - **is not on** — no item's value is among them ("no account is on the Leavers register")
  - **at least N are on**
- What it reads: the register's entries that aren't archived, as they stand when the run starts. A per-company register reads the run's company's entries. A shared register with a Company field offers **Only entries that apply to the company**.
- The run's inputs say what it read: "Approved suppliers (SUP), Supplier name, 42 entries, 22 Nov 10:14".
- Restricted registers aren't offered (a workflow's runs are seen by everyone who can see Workflows).
- Choosing a register needs *View registers*.
- **Protection**: removing or retyping a field a workflow reads, or archiving the register, warns first and names the workflows. The register's page lists "Read by workflows" with links.

## Implementation notes (technical)
- A new module under `core/workflows/lookups/`, shaped like `document_list.py`: `permission = registers_view`, read once per run, the three tests matching one captured field to the register field's values (Choice → value labels, Person → name/email, Company → name; Text compared case-insensitively, trimmed).
- Register a usage source, as `content_lists.register_usage_source` does, so field removal/retype and register archive can warn. Field-change and archive routes call it.
- No engine change; lookups are registered through `register_lookup()`.

## Done when
- A workflow with a register lookup gives the right verdict on test evidence for each test.
- The run records the register, field, count and time.
- Removing the field it reads warns and names the workflow.
- A Restricted register isn't offered.

Independent (no migration).