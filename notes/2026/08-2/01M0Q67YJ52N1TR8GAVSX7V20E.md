---
id: 01M0Q67YJ52N1TR8GAVSX7V20E
created: 2026-08-23T11:31:39.205973Z
updated: 2026-08-25T15:27:41.623292Z
type: task
title: View Devices screen — searchable inventory, detail modal, Azure Portal link
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 387
sprint: s5gwx0s
blocked_by:
- 01M0Q67QE392HEGF8CPFXV4771
comments:
- id: 01M0QDVR2Q8FHQRCBKQDDRW7AD
  author: Steve Vine
  at: 2026-08-23T13:44:47.959073Z
  text: |-
    Done — PR #389 (feature/com-387-view-devices), stacked on #388 (COM-386).

    Backend, three endpoints, all wholly mirror-backed — unlike the user modal there is no live-Graph half, so nothing here can degrade and no panel needs an availability flag:
    - `GET /directory/devices` — paginated, server-side sorted, filters on free text, enabled, managed, compliant, OS. Free text covers the **device id as well as the display name**, since that's what a helpdesk ticket quotes. Vanished devices excluded, as vanished accounts are.
    - `GET /directory/devices/{id}` — identity, registered owners, direct group memberships. A vanished device still resolves by id, so a stale link and history keep working.
    - `GET /directory/devices/operating-systems` — the OS filter's options. This is a departure from the brief's "selects for … OS": I gave it its own endpoint rather than deriving the options from the page, because they are a property of the tenant and would otherwise shift as you filter. Declared before `/devices/{device_id}` so the literal path wins FastAPI's declaration-order match.

    Frontend:
    - View Devices tab after View Users; table is display name, enabled, OS (+ version), managed, compliant, last sign-in. Managed/Compliant as pills.
    - Detail modal: copyable Object ID and Device ID, trust type, registered on, last sign-in labelled **approximate** — Entra refreshes it every few hours and the UI must not imply otherwise. Registered owners open the user modal, groups open the shared GroupDetailModal, vanished devices get the gone alert.
    - Azure Portal blade verified as `Microsoft_AAD_Devices/DeviceDetailsMenuBlade/~/Properties/objectId/{id}` (the Properties leaf, keyed on object id — not deviceId).
    - `unmanaged` / `not_compliant` join the shared status colours in **orange, not red**: an unmanaged device is a gap to look at, not a failure of the app.

    Two brief items that needed no work: the `App.tsx` placeholder-exclusion list already excludes `/access` wholesale, so a new sub-route needs nothing there; and no "View in graph" entry point on the device modal yet — devices join the graph in COM-389, and the affordance lands with it rather than pointing at a canvas that cannot draw them.

    Read gate tested explicitly: a plain viewer gets 403 on all three endpoints.

    8 API tests, 6 page tests, plus the tab-shell test. Full frontend suite green (609); schema.d.ts regenerated.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
New **View Devices** tab in the Access section nav, directly after View Users (`AccessControlPage.tsx` tab list) — same format and interaction model as COM-255, over the device mirror.

* **API**: paginated `/directory/devices` list + `/directory/devices/{id}` detail, served from the mirror (no live Graph) — debounced free-text on display name, selects for Enabled, Managed, Compliant, and OS; sortable like the users list.
* **List**: table — **Display name, Enabled, OS (+ version), Managed, Compliant, Last sign-in**. Enabled as a status pill with the disabled row muted (matching View Users); Managed/Compliant as pills so an unmanaged or non-compliant device reads as such at a glance.
* **Detail modal** (click a row): identity header (display name, OS, enabled state), copyable **Object ID** and **Device ID**, trust type, registered on, approximate last sign-in; **Registered owners** as chips opening the View Users modal; **Groups** (direct memberships) as chips opening the shared `GroupDetailModal`. Vanished devices get the explicit gone alert, like users.
* **Azure Portal link**: "Open in Azure Portal" on row overflow + modal header — the Entra devices blade (`Microsoft_AAD_Devices/DeviceDetailsMenuBlade`, verify the exact blade path) — new tab, external-link affordance.
* Gated `RequireSection section="access"` / `require_access_read`; **read-only, no write affordances** — devices are inventory, not a governed surface. Remember the `App.tsx` placeholder-exclusion list.

Refs: COM-255 (the format twin — share the table/filter/modal scaffolding where it doesn't contort), ADR 0045, 0017.