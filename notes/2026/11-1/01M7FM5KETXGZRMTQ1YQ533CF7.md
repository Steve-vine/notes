---
id: 01M7FM5KETXGZRMTQ1YQ533CF7
created: 2026-11-15T12:50:59.674628Z
updated: 2026-11-16T23:03:22.924819Z
type: task
title: Workflow conditions can look things up in Compass — a document's list, Vulnerabilities, Inventory and Secrets — and compare the evidence against them ("every Standard change is on the Approved standard changes list")
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1853
sprint: s7nqsy0
blocked_by:
- 01M7FM4N91XA3VZEGW959VME00
- 01M7FM542TQJFW6X3AYZ5GWB6X
comments:
- id: 01M7G9RMK3187ACS7DXWDC40Y4
  author: Steve Vine
  at: 2026-11-15T19:08:23.523559Z
  text: |-
    Built and merged (PR #1849).

    What people get: a workflow's conditions can now look things up in what Compass already holds for that company:
    - A document's list: an entry in the latest published version of a list, by its reference, and a column's value. This is Steve's case, approved standard changes.
    - Vulnerabilities, Inventory (technology assets) and Secrets. Secrets are read by name and dates only.

    Each source asks for what it needs in plain pickers (which document, which list, which column, which asset). Each run records what it read, for example "Approved standard changes v7" or "Vulnerabilities as at 14:02". A source someone can't see on screen isn't offered to them. Nothing in it knows about any particular Collection service.

    Checks: CI fully green. Pre-UAT on staging follows once the whole sprint is in.
- id: 01M7GM26KN6GA938SRZ121KEZW
  author: Steve Vine
  at: 2026-11-15T22:08:22.644862Z
  text: |-
    Couldn't check: Steve's standard-changes case end to end (pre-UAT, 2026-11-15, build f8665615, E2E Test Company). The Inventory, Vulnerabilities and Secrets conditions passed.

    What blocked the standard-changes case:
    1. No check collects changes. E2E Test Company's only collected check, CHK-2, reads GitHub repositories (despite its name), and its Collection integration has been deleted, so it can't collect again. The testing rules also forbid adding a connection to E2E Test Company.
    2. No published list. "Approved Standard Changes" is published (v1) without a list, and the rules forbid publishing Playbook content on staging (see COM-1852).
    Polaris reached the same conclusion on its own (see COM-1857).

    What I checked, using Test on CHK-2's real captures (nothing changes):
    - Inventory: "every repository is a technology asset in Inventory (matched by name or host name)". Result: "8 of 8 repositories aren't technology assets in Inventory", naming each, e.g. "boysenberry-repo-1 — no technology asset in Inventory with name or host name 'boysenberry-repo-1'". It would set Non-compliant.
    - Vulnerabilities: "no open Critical vulnerability anywhere in the company" (at most 0). Result: "2 open Critical vulnerabilities … VUL-1 … on AST-33, VUL-8 … on AST-51".
    - Secrets: "no secret in the company is overdue for rotation". Result: "1 secret … SEC-2 · … was due for rotation on 2026-11-05". Names and dates only.
    - The pickers are plain: document, list and column; severity, status, fix-by date; which systems; and the item's field, chosen from CHK-2's real captured fields with a sample value.
    - The document picker lists only documents, and the list picker said "'Approved Standard Changes' v1 holds no list", so it reads the published version.
    - Vulnerabilities and Secrets respected a person's call: "Would judge it Non-compliant; it would stay Compliant, as set by E2E Admin A".

    For Steve on staging: once a check collects changes (e.g. Test Company's CHK-24/25, from FreshService) and "Approved Standard Changes" is published with a list, build "every change where type is Standard is on Approved standard changes (by reference)" and Test it against a capture. The run should name each change that isn't on the list and the list's version. The cross-company permissions test is in CI and not visible on screen.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1853/
assignee: steve
label:
- feature
priority: high
task_status: done
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