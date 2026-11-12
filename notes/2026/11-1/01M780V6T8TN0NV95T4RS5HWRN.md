---
id: 01M780V6T8TN0NV95T4RS5HWRN
created: 2026-11-12T13:58:35.08093Z
updated: 2026-11-12T13:58:39.76922Z
type: task
title: A technology asset records its form (Physical, Virtual, Container or Not applicable), and the register can filter by it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1757
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Steve, testing on staging (2026-11-12): there's no way to say whether a technology asset is physical or virtual.

**Today:** the nearest things are:
- **Kind** (System, Application, Datastore);
- **Hosting** (Self-hosted, Cloud, SaaS, On-premises), where On-premises and Self-hosted can be either;
- free-text **Hosting detail**;
- End of support's **N/A**, whose hint reads "(a VM)" but records nothing about the asset's form.

**What it should do:**
- A technology asset gains **Form**, chosen from **Physical**, **Virtual**, **Container** or **Not applicable** (e.g. SaaS, or an application with no host of its own). Left blank, it reads **Not recorded**.
- It sits in the asset's form beside Kind and Hosting (FieldRow), and shows on the asset's page.
- The Technology assets register gets a **Form** filter, and Form can be shown as a column. The filter lives in the address like the others (COM-792).
- **Discovery fills it where its source says.** Cloud virtual machines (AWS, Azure, Google Cloud) are Virtual. Managed services such as databases are Not applicable. An on-premises server is Virtual or Physical only where what's read says so (e.g. a reported hypervisor or model); otherwise it's left Not recorded. A person's choice is never overwritten by discovery.
- **Collection feeds into Inventory** can set Form only through their configuration (a mapping), never through code that knows a service (ADR 0147 §9).
- The End of support N/A hint stops saying "(a VM)". Where an asset is Virtual, N/A is suggested.
- Polaris's Inventory tools (MCP) and the Inventory import read and set Form.
- Existing assets start as Not recorded. Discovered cloud VMs get Virtual at their next read.

**Done when:**
- Form can be set and changed on add and edit, and shows on the asset;
- the register filters by each value, including Not recorded;
- a cloud VM found by discovery reads Virtual;
- a manual choice survives the next discovery read;
- the MCP tools and the import handle Form;
- light and dark mode and a narrow window are checked;
- there are no errors in the browser console.

On the chain: a migration adds a `container_form` enum and a `containers.form` column, nullable. The API, OpenAPI and `schema.d.ts` change. Amend the Inventory ADR (0072) with the new property. Needs a check against the "no per-service logic" test (COM-1696) for the discovery mapping.