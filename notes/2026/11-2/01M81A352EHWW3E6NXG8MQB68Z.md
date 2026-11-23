---
id: 01M81A352EHWW3E6NXG8MQB68Z
created: 2026-11-22T09:41:13.422755Z
updated: 2026-11-23T19:36:29.429968Z
type: task
title: A workflow checks evidence against a register — a register lookup (is on, is not on, at least N are on), read once per run, with a warning before a field a workflow uses is changed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2092
sprint: ssj8zkq
blocked_by:
- 01M819YPE0MWZJFY6DYBVJRSQB
- 01M7ZM3A51AMEQBWY97NSMG751
comments:
- id: 01M83XF432RHHAM4F3K2X3WH8Q
  author: Steve Vine
  at: 2026-11-23T09:58:17.442075Z
  text: |-
    Built and merged to main: PR #2088 (309c9ad3b). No migration.

    What people see:
    - In a workflow's condition, Look up ▸ A register: choose a register and one of its fields, then is on, is not on, or at least N are on.
    - It reads entries that aren't archived, once per run. A per-company register reads only the run's company. A shared register with a Company field offers Only entries that apply to the company.
    - The run records what it read: register, field, number of entries and time.
    - Restricted registers aren't offered, even to administrators.
    - Removing or retyping a field a workflow reads, or archiving the register, warns first and names the workflows. The register's Settings tab lists Read by workflows, with links.

    Decisions made while building, for Steve to check:
    1. Deleting an empty register and making a register Restricted also warn, because both stop a workflow reading it.
    2. If someone goes ahead with removing the field, archiving, deleting or restricting, the workflow shows a problem and its next run fails saying why, leaving the evidence Unchecked. A register made Restricted isn't named in that message.
    3. Retyping a field warns but doesn't break anything: the workflow reads it as its new type.
    4. Only entries that apply to the company counts entries whose Company field names that company. An entry with that field blank doesn't count.
    5. Workflow names on Read by workflows are visible to anyone who can see the register, as on a document's page. Only people who can see Workflows get the link.
    6. A run reads at most 5,000 entries and says so if it stopped there, as the document list does.

    Not built: Polaris can't pick a register by name when drafting a workflow. A person chooses it on the canvas.

    Tested against real Postgres: the verdict for each test, what the run records, the warnings, Restricted registers, per-company reads, and how each kind of value matches. CI green.

    Not yet checked in a browser on staging: that comes with the sprint's pre-UAT pass.
- id: 01M84ENK78S6PBYMPTDBDD93XZ
  author: Steve Vine
  at: 2026-11-23T14:58:55.33657Z
  text: |-
    Pre-UAT on staging e2248892e: PASSED.

    Account: E2E Admin A, E2E Test Company. Workflow WFL-13 "E2E UAT 122 Register lookup", tested against CHC-2's capture of 6 Nov (8 captured items), matching each item's name to the Title of register E2E UAT 122 Lookup (ULK).

    - The right verdict for each test: PASSED, using Test on the workflow.
      - is on, all 8 on the register: Met, "All 8 items are on E2E UAT 122 Lookup (ULK)".
      - is on, after archiving ULK-8: Not met, "1 of 8 items isn't on…: test-repo1". An archived entry doesn't count.
      - is not on, all 8 on it: Not met, naming each item and its entry.
      - is not on, against a register holding none of them (UPA): Met.
      - at least 8: Met. At least 9: Not met.
    - The run records the register, field, count and time: PASSED, on one real run. I enabled WFL-13 limited to ACC.13 evidence becoming Compliant, set that capture to Compliant, and the run's "What it read" says "E2E UAT 122 Lookup (ULK), Title, 7 entries, 23 Nov 14:36". It did nothing further (conditions not met). I then disabled the workflow and put the capture back to Unchecked, so that capture's history has two extra lines from me.
    - Removing the field it reads warns and names the workflow: PASSED. "A workflow reads this: E2E UAT 122 Register lookup (E2E Test Company). If you go ahead, each one's next run fails until the workflow is changed." Archiving the register gives the same warning. I cancelled both. Settings ▸ Read by workflows lists it, with a link.
    - A Restricted register isn't offered: PASSED. E2E UAT 122 Restricted is missing from the workflow's register list, which says why.

    Not tried: Only entries that apply to the company, and retyping a field.

    Screenshots: ~/compass-uat/sprint-122/COM-2092/
assignee: steve
label:
- feature
priority: medium
task_status: done
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