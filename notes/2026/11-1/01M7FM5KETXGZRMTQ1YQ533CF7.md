---
id: 01M7FM5KETXGZRMTQ1YQ533CF7
created: 2026-11-15T12:50:59.674628Z
updated: 2026-11-15T12:52:18.974444Z
type: task
title: Workflow conditions can look things up in Compass — a document's list, Vulnerabilities, Inventory and Secrets — and compare the evidence against them ("every Standard change is on the Approved standard changes list")
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1853
sprint: s7nqsy0
blocked_by:
- 01M7FM4N91XA3VZEGW959VME00
- 01M7FM542TQJFW6X3AYZ5GWB6X
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Automation - Workflows" (ADR in COM-1848). Builds on COM-1851 (workflows) and COM-1852 (document lists).

## What people see

In a workflow's conditions, besides the evidence itself, a person (or Polaris) can use four Compass sources, all for the workflow's own company:

- **A document's list** (published version): "item's *change template* **is on** *Approved standard changes* (matched by *reference* / by *name*)", "**is not on**", and "the list has at least N entries".
- **Vulnerabilities**: e.g. "no open Critical vulnerability on the systems in this evidence is past its due date", "count of open High on *system* is at most 0". Filters: severity, status, overdue, system.
- **Inventory**: e.g. "every server in this capture is a technology asset in Inventory", "the asset has an owner", "its support is not End of life" (ADR 0150), "its recertification isn't overdue".
- **Secrets**: e.g. "no secret on this system is overdue for rotation", "every key in this capture is in the Secrets register".

How matching works: a condition says which field of the captured item to use and which field of the Compass record to match it against (reference, name, host name, serial and so on). Matching ignores case and surrounding spaces. Fuzzy matching is not in this task. If the item has no value to match on, the condition treats it as "not found", and the run says so.

**What a run records**: which source, which version or when it was read ("Approved standard changes v7", "Vulnerabilities as at 14:02"), and for a failing item what it looked for and didn't find ("CHG-2231 'Patch web01' — no entry on Approved standard changes with reference 'web-patch'").

**Permission**: a workflow only reads what its company holds. Someone building a workflow sees only the documents, systems and secrets they could already see. Secrets are read by name and dates only, as ADR 0141 (never a value).

## Notes for the builder

- Each source is a registered **lookup** in the condition registry from COM-1851: the next source (People, Vendors, Risks) is an addition, not a rewrite.
- Keep lookups bounded (a ceiling on records read per run, shown when hit). Read once per run, not once per item.
- No service-specific logic (ADR 0147 §9).

## Done when

- Steve's case works end to end on staging: a check collecting changes, a document with an Approved standard changes list, and a workflow that marks the capture Non-compliant when a Standard change isn't on the list, naming the change, and Compliant when all are.
- A Vulnerabilities, an Inventory and a Secrets condition each work in a workflow, with tests.
- Runs record the source version or time and the failing items.
- Permissions: there's a test that a workflow can't read another company's records.

**On the chain** (API).