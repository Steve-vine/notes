---
id: 01KXGWJN5DFYQJSY7MFFJPHANF
created: 2026-07-14T18:00:12.205752983Z
updated: 2026-07-19T21:30:29.299332047Z
type: task
title: 'Managed content: M365/SharePoint kind — resolve link, Open in M365'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 131
sprint: ssdk92z
blocked_by:
- 01KXGWGMXNSTRSN1JSF7K8SCXE
assignee: steve
task_status: done
priority: medium
---
The `managed` kind (M23, first half of ADR 0034's build): a content item backed by an M365/SharePoint document. Open/edit happens in Word/Excel Online; Compass stores the reference and the governance.

**Backend**

* Settings: `M365_TENANT_ID`, `M365_CLIENT_ID`, `M365_CLIENT_SECRET` (12-factor, like the S3 creds; chart secret plumbing included, disabled by default).
* Graph client (httpx): client-credentials token acquisition with caching/refresh, share-URL → driveItem resolution (`GET /shares/{encoded}/driveItem`) — lifted from the validated spike (`spikes/m365-pdf/`).
* Nullable columns on content: `m365_drive_id`, `m365_item_id`, `m365_web_url`. On create/update of a `managed` item the user pastes a SharePoint **Share → Copy link** URL; the API resolves it once via Graph and stores the ids + `webUrl` (clear 4xx if the app identity can't see it).

**Frontend**

* Create: choosing kind Managed gives a "SharePoint link" field with guidance (use Share → Copy link).
* List + detail: **Open in M365** action → `web_url` in a new tab; detail shows the document name/link, governance panel as for all kinds.

**Ops**

* Scripted `Sites.Selected` per-site grant (`scripts/m365/grant-site.py` using the Graph client) + README — the grant has no portal UI, so it must be a documented, repeatable operation. Replace the spike registration's tenant-wide `Sites.Read.All` with `Sites.Selected` + a grant on the ISMS site.

Blocked by <issue id="b485e441-4fea-4751-a073-e770fe3ab46d" href="https://linear.app/stevevine/issue/DEV-755/content-kinds-foundation-sourcekind-migration-kind-column-domain">DEV-755</issue>.

---
*Migrated from Linear [DEV-758](https://linear.app/stevevine/issue/DEV-758/managed-content-m365sharepoint-kind-resolve-link-open-in-m365) · created 2026-07-02 · completed 2026-07-02*  
*Related to (Linear): DEV-778*