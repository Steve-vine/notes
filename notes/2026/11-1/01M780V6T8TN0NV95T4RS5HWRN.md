---
id: 01M780V6T8TN0NV95T4RS5HWRN
created: 2026-11-12T13:58:35.08093Z
updated: 2026-11-12T14:32:01.28567Z
type: task
title: A technology asset records its form (Physical, Virtual, Container or Not applicable), and a physical one its make, model and serial number; the register can filter by form
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1757
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: active
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