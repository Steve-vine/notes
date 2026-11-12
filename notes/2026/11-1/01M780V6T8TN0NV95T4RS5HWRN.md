---
id: 01M780V6T8TN0NV95T4RS5HWRN
created: 2026-11-12T13:58:35.08093Z
updated: 2026-11-12T15:50:49.079582Z
type: task
title: A technology asset records its form (Physical, Virtual, Container or Not applicable), and a physical one its make, model and serial number; the register can filter by form
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1757
sprint: spsp226
comments:
- id: 01M7878KXTVA6FZZK54C2VTG6T
  author: Steve Vine
  at: 2026-11-12T15:50:45.946745Z
  text: |-
    Built — PR #1757 (auto-merge set), commit 173d4f25, on top of COM-1758. On the chain: migration 0828_container_form (after 0825); ADR 0072 amended after COM-1758's amendment.

    What you'll see:
    - Form on a technology asset: Physical, Virtual, Container or Not applicable, on the add/edit form (Hosting | Form | Hosting detail) and on the asset's page. Blank reads "Not recorded" — where every existing asset starts.
    - Physical shows Make, Model and Serial number (on a row below). If Form changes they're kept but hidden.
    - Make suggests the makes already used in the company, each once as most often spelt.
    - A serial number already on another of the company's assets is flagged ("Also on AST-3 · Payroll DB") as you type and on the page; it still saves. Case and spaces ignored.
    - Register: a Form filter (each form plus Not recorded) and a Columns menu adding Form, Make, Model and Serial number — both kept in the address. The search (COM-1756) also matches make, model and serial number and says which matched.
    - Discovery fills these only where the field is blank, so a person's entry is never overwritten: cloud VMs read Virtual; container services (ECS, Container Apps, Cloud Run) read Container; other cloud services read Not applicable; a directory server reads Physical only when it's a Hyper-V host, otherwise stays Not recorded. Making an asset from a discovered resource starts with the same form. Decommissioned assets are left alone.
    - Collection feeds into Inventory can set all four through their mapping only (the no-service-names test passes).
    - End of support's N/A hint no longer says "(a VM)"; when Form is Virtual and nothing is recorded it offers "use N/A".
    - Polaris's Inventory tools, the CSV import (form, make, model, serial_number) and the owner's portal edit read and set all four.

    Choices:
    - "Never overwritten" means discovery fills blank fields only — so if someone clears a field back to Not recorded, the next read can fill it again.
    - With several discovered resources, the most specific form wins (Physical, then Virtual, Container, Not applicable).
    - In the owner's portal edit there are no Make suggestions and no live serial check (those need register access); the asset page still shows the flag.

    Not done: the built-in readers (AWS, Azure, GCP, directory) don't read a manufacturer, model or serial today — only a Collection feed's mapping can supply them for now.

    Checks: ruff, mypy strict, unit suite (2192 passed); integration incl. new asset-form and feed-mapping tests, discovery (AWS/Azure/GCP/directory), import, Polaris inventory, collection feeds — all passed after the final rebase; tsc, eslint, prettier clean; touched frontend suites pass (one unrelated load flake in the full run); OpenAPI drift OK. Checked in headless Chromium, light and dark, 1400px and 420px, console clean.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Steve, testing on staging (2026-11-12): there's no way to say whether a technology asset is physical or virtual. Added the same day: "For physical assets I need to be able to track the make and model as well", then "Add serial number as well."

**Today:** the nearest things are:
- **Kind** (System, Application, Datastore);
- **Hosting** (Self-hosted, Cloud, SaaS, On-premises), where On-premises and Self-hosted can be either;
- free-text **Hosting detail**;
- End of support's **N/A**, whose hint reads "(a VM)" but records nothing about the asset's form.

There's no make, model or serial number anywhere.

**What it should do:**
- A technology asset gains **Form**, chosen from **Physical**, **Virtual**, **Container** or **Not applicable** (e.g. SaaS, or an application with no host of its own). Left blank, it reads **Not recorded**.
- It sits in the asset's form beside Kind and Hosting (FieldRow), and shows on the asset's page.
- **Make, model and serial number (physical assets):** when Form is Physical, three more fields show: **Make** (the manufacturer, e.g. "Dell"), **Model** (e.g. "PowerEdge R750") and **Serial number** (e.g. the service tag). All are free text and optional, and they show on the asset's page.
  - They're kept if Form changes, but only shown while Form is Physical.
  - Make suggests from the makes already used in the company's register, so "Dell" and "Dell Inc." don't both creep in.
  - A serial number already on another of the company's assets is flagged when saving ("Also on AST-12 …"), but not refused: it may be a genuine re-use or a typo. Matching ignores case and spaces.
- The Technology assets register gets a **Form** filter, and Form, Make, Model and Serial number can each be shown as a column. The filter lives in the address like the others (COM-792). Make, Model and Serial number match in the register's search (COM-1756).
- **Discovery fills it where its source says.** Cloud virtual machines (AWS, Azure, Google Cloud) are Virtual. Managed services such as databases are Not applicable. An on-premises server is Virtual or Physical only where what's read says so (e.g. a reported hypervisor, or manufacturer and model); otherwise it's left Not recorded. Where a physical server's manufacturer, model or serial number is read, it fills the matching field. A person's entry is never overwritten by discovery.
- **Collection feeds into Inventory** can set Form, Make, Model and Serial number only through their configuration (a mapping), never through code that knows a service (ADR 0147 §9).
- The End of support N/A hint stops saying "(a VM)". Where an asset is Virtual, N/A is suggested.
- Polaris's Inventory tools (MCP) and the Inventory import read and set all four.
- Existing assets start as Not recorded with no make, model or serial number. Discovered cloud VMs get Virtual at their next read.

**Done when:**
- Form can be set and changed on add and edit, and shows on the asset;
- choosing Physical shows Make, Model and Serial number, which save and show on the asset's page; another Form hides them;
- Make suggests the makes already used;
- a serial number already used by another asset of the company is flagged with that asset's reference, and still saves;
- the register filters by each Form value, including Not recorded, and can show Form, Make, Model and Serial number as columns;
- a cloud VM found by discovery reads Virtual;
- a manual Form, Make, Model or Serial number survives the next discovery read;
- the MCP tools and the import handle all four;
- light and dark mode and a narrow window are checked;
- there are no errors in the browser console.

On the chain: a migration adds a `container_form` enum and the columns `containers.form`, `containers.make`, `containers.model` and `containers.serial_number`, all nullable, with an index on the company and the normalised serial for the duplicate check. The API, OpenAPI and `schema.d.ts` change. Amend the Inventory ADR (0072) with the new properties. Needs a check against the "no per-service logic" test (COM-1696) for the discovery mapping.