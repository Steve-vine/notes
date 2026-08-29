---
id: 01M153A4FWYVQM1K13X95AVXEX
created: 2026-08-28T21:09:47.132586Z
updated: 2026-08-29T17:03:36.633739Z
type: task
title: 'Who consented to what: the permissions apps actually hold'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 500
sprint: s5cyp1z
blocked_by:
- 01M1539868BE8QNCSYNQJYXNGF
comments:
- id: 01M16YY4ANS6VB0FGQBAHEAWZE
  author: Steve Vine
  at: 2026-08-29T14:31:48.309008Z
  text: |-
    Done — PR #510, merged to main (ac127aa).

    Compass can now see what applications are actually allowed to do here. Read-only, as the task said: whether an app permission should also require an Access Admin's name is a real question and a bigger one, and it would amend ADR 0061, so it is left to be decided on its own.

    Application permissions and delegated ones are never merged. One applies tenant-wide with nobody signed in; the other only ever acts for a signed-in user and is bounded by what they can do. "App can read all mail" and "app can read the mail of whoever is using it" are not the same finding and do not have the same fix. Delegated grants also carry whether the consent was tenant-wide or one person's own — the half an auditor asks about by name.

    One row per permission rather than per grant. Graph hands a delegated grant over as one object carrying a space-separated scope list; kept that way, every report would have to match inside a string, and "which apps can read mail" cannot be a substring test without also matching Mail.ReadBasic inside MailboxSettings.Read.

    Permissions are stored by name, resolved from the catalogue each resource publishes. A grant stored as two GUIDs answers no governance question. One whose role the resource does not publish keeps its id — a poor name and an honest one; dropping the row would hide a permission an application genuinely holds.

    **The privileged set is curated and version-controlled**, the same shape as the privileged directory roles ADR 0061 already defines, and deliberately not inferred from the permission's name. A rule matching "*.All" would look right, pass review, and quietly stop catching things the week Microsoft renamed something — and it would have caught Files.Read.All while missing full_access_as_app. Grouped, so "reaches mail", "reaches files", "reaches the directory" and "can act as somebody else" are each their own question.

    Four new reports: apps holding privileged permissions, apps that can read all mail, tenant-wide delegated consent, and apps granted permissions in the last 30 days. Undated grants are never treated as old — OAuth2 grants carry no creation time at all, so they read as unknown and can be asked for by name.

    **No new admin consent needed** — Application.Read.All (from COM-498) and the long-standing Directory.Read.All cover both reads.

    Smoke test: Access Control → Reports, the four new definitions.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
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