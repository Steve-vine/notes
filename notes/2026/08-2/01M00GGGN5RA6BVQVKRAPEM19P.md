---
id: 01M00GGGN5RA6BVQVKRAPEM19P
created: 2026-08-14T16:08:33.701321Z
updated: 2026-08-14T16:08:33.701321Z
type: task
title: Portal header title links back to the internal Vendors section
assignee: steve
task_status: active
priority: medium
label: improvement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 204
---
The portal is a dead end for internal users. An operator reaches `/portal` from the sidebar (ADR 0040 §2 gave it its own shell — no sidebar, no global search) and then has no way back into Compass short of editing the URL.

**Change**
* The portal header's brand cluster (compass mark + title) becomes a link to **`/vendors`**, the internal section the portal mirrors.
* A **portal-only** user who follows it is **redirected to `/portal`** rather than shown the "You need Vendors access" message inside the internal shell — today `RequireSection` renders that message wrapped in `AppLayout`, which is the internal chrome ADR 0040 §2 exists to keep away from portal accounts. The bounce goes in `RequireSection`, so it covers every internal section, not just Vendors.

Deliberately narrow: `RequireOverview` / `LandingRedirect` in `App.tsx` are left alone — they carry the documented post-login redirect fix and are implicated in [[COM-203]], so they should be changed there, with that bug's evidence, not here.

**Done when:** an operator can round-trip Compass → portal → Compass from the header; a portal-only user following the same link lands back on `/portal` and never sees internal navigation; existing portal-routing tests updated (the current one asserts the refusal message on `/vendors`) and new coverage for both paths.

Refs: ADR 0040 §2, 0039, 0026.