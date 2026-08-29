---
id: 01M153A4FWYVQM1K13X95AVXEX
created: 2026-08-28T21:09:47.132586Z
updated: 2026-08-29T14:11:32.925628Z
type: task
title: 'Who consented to what: the permissions apps actually hold'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 500
sprint: s5cyp1z
blocked_by:
- 01M1539868BE8QNCSYNQJYXNGF
assignee: steve
company: null
label:
- feature
priority: medium
task_status: active
---
**An application holding `Mail.ReadWrite` across the tenant is privileged access.** ADR 0061 built a gate around who may make somebody an administrator, and a consented app permission grants a comparable reach with no request, no approver and no ledger. Compass should at least be able to *see* it.

Mirror the grants against each service principal (COM-498):

- **Application permissions** — app role assignments, the ones that apply tenant-wide with no user involved. These are the ones that matter.
- **Delegated permissions** — OAuth2 grants, and crucially whether the consent was **tenant-wide** or one user's own.
- The **resource** each grant is against (Graph, Exchange, SharePoint) and the permission's name.
- **Who consented, and when**, where Graph reports it.

Then a **privileged permission set** in the catalogue, the same shape as the privileged directory roles the app already defines: the grants that read or write mail, files, directory objects, or that let an app act as any user. Curated and version-controlled, not inferred from the string — a permission list that guesses is one that quietly stops catching things when Microsoft renames something.

Seeded definitions: *Apps holding privileged permissions*, *Apps that can read all mail*, *Tenant-wide delegated consent*, *Apps granted permissions in the last 30 days*.

**Read-only, and deliberately so.** This task adds sight, not a gate. Whether an app permission should require an Access Admin's name the way a role assignment does is a real question and a bigger one — it would amend ADR 0061, and it needs deciding on its own rather than arriving as a side effect of a report.