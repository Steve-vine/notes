---
id: 01M0Q67YJ52N1TR8GAVSX7V20E
created: 2026-08-23T11:31:39.205973Z
updated: 2026-08-23T11:31:39.205973Z
type: task
title: View Devices screen — searchable inventory, detail modal, Azure Portal link
label: feature
priority: medium
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 387
---
New **View Devices** tab in the Access section nav, directly after View Users (`AccessControlPage.tsx` tab list) — same format and interaction model as COM-255, over the device mirror.

* **API**: paginated `/directory/devices` list + `/directory/devices/{id}` detail, served from the mirror (no live Graph) — debounced free-text on display name, selects for Enabled, Managed, Compliant, and OS; sortable like the users list.
* **List**: table — **Display name, Enabled, OS (+ version), Managed, Compliant, Last sign-in**. Enabled as a status pill with the disabled row muted (matching View Users); Managed/Compliant as pills so an unmanaged or non-compliant device reads as such at a glance.
* **Detail modal** (click a row): identity header (display name, OS, enabled state), copyable **Object ID** and **Device ID**, trust type, registered on, approximate last sign-in; **Registered owners** as chips opening the View Users modal; **Groups** (direct memberships) as chips opening the shared `GroupDetailModal`. Vanished devices get the explicit gone alert, like users.
* **Azure Portal link**: "Open in Azure Portal" on row overflow + modal header — the Entra devices blade (`Microsoft_AAD_Devices/DeviceDetailsMenuBlade`, verify the exact blade path) — new tab, external-link affordance.
* Gated `RequireSection section="access"` / `require_access_read`; **read-only, no write affordances** — devices are inventory, not a governed surface. Remember the `App.tsx` placeholder-exclusion list.

Refs: COM-255 (the format twin — share the table/filter/modal scaffolding where it doesn't contort), ADR 0045, 0017.