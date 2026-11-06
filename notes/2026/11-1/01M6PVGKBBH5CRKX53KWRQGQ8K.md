---
id: 01M6PVGKBBH5CRKX53KWRQGQ8K
created: 2026-11-05T21:58:19.243891Z
updated: 2026-11-06T00:43:19.284218Z
type: task
title: Add a Collection integration with Polaris — name the service and paste its API documentation link; Polaris proposes the address, sign-in, paging, a test read and the logo, and says how to make a read-only key; you paste the key, Compass tests it, you save
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1600
sprint: s1jcke1
blocked_by:
- 01M6PVG4HWTS4HP87RS8JSKMPC
comments:
- id: 01M6Q4YP11XPNHSD3YB4YV365N
  author: Steve Vine
  at: 2026-11-06T00:43:17.921077Z
  text: |-
    Done: PR #1616 merged. No migration; it adds API routes.

    What's there:
    - **Admin ▸ Integrations ▸ Add with Polaris**, a wizard in three steps:
      1. **The service:** name and documentation link, with what it usually costs. Polaris then reads up to eight documentation pages, and its progress shows on the step.
      2. **Polaris's proposal**, filled into the same form as Add by hand, all editable:
         - address, sign-in, paging and test read;
         - **how to make a read-only key**, as numbered steps;
         - what it wasn't sure of;
         - the logo it found, with a tick to use it;
         - if the service signs in a way Compass can't do yet, it says so.
      3. **First account:** the key steps again, the account form, and **Test**.
    - **Saving from a proposal** marks it approved, records that Polaris helped, and keeps a cleaned copy of the logo (the lettered tile if the logo can't be fetched).
    - **A failed Test** offers **Ask Polaris why**. Polaris reads the error, the definition and the docs, and says why in plain words, what to change, and what to do in the service if the key is the problem. **Apply and test again** changes only those fields, checked as a Settings save, then re-tests every account.
    - **The key never reaches Polaris.** It sees only the test's answer; the tests assert this.
    - **Add by hand** stays.

    My call: everything Polaris fills in is cut back to Compass's fixed lists and checked (an https public address, a plain path) before it's even proposed.

    Tested: 3 integration tests with a fake provider (propose then save with logo; a failure explained and applied, with the key never in what Polaris saw; http docs and Polaris off refused), and 2 Vitest.

    Couldn't check: the real wizard on MongoDB Atlas and SendGrid needs Polaris's AI provider key on staging, and read-only keys from Steve.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Evidence Collection - Integrations" (ADR 0142, COM-1595). Builds on COM-1596 (the form), COM-1597 (icons) and COM-1599 (Polaris jobs).

## What people see

**Admin ▸ Integrations ▸ Add ▸ Collection integration ▸ With Polaris**, a wizard in four steps:

1. **Tell Polaris the service.** Its name ("MongoDB Atlas") and a link to its API documentation. Start shows the expected cost first. The job's progress shows on the step.
2. **Polaris's proposal**, filled into the COM-1596 form and editable:
   - address, sign-in method, paging style, and test read;
   - the **logo** it found, with "Use lettered tile" and "Upload" beside it;
   - **how to make a read-only key in this service**, as numbered steps with the exact role or scopes to tick (e.g. Atlas: "Organization Read Only"; SendGrid: a Restricted Access key with read on…);
   - anything it wasn't sure of, marked so.
   - If the documentation doesn't describe a sign-in method Compass supports, it says so and stops: "This service signs requests in a way Compass can't yet do."
3. **Your first account.** Name, company, and the key or password you made. **Test** runs the test read and shows what came back, so you can see it's the right service. If the test fails, "Ask Polaris why" starts a short job that reads the error and the documentation and suggests a fix.
4. **Save.** The tile appears under Collection, with its icon, and is in the activity log as "<person>, with Polaris".

- **The key never reaches Polaris.** Polaris proposes; Compass makes the test request. Polaris sees the test's answer, not the key.
- **"Add by hand"** stays available, for someone who prefers the plain form.

## Notes (technical)

- A job kind `define_integration` (COM-1599). Its tools are `read_page` (documentation and linked pages, a cap on page count) and the form tool `propose_definition`, which uses COM-1596's enums for sign-in and paging. No read tool before an account exists; step 3's "Ask Polaris why" is a second job kind with the failed response as input.
- The logo: Polaris proposes an image address (the service's brand or press page, its favicon or apple-touch icon). Compass fetches and cleans it through COM-1597. Polaris never supplies the bytes.
- Keep the documentation fetch on public addresses only, with redirects followed by hand (`core/assets.py`'s pattern).

**Chain:** on the chain (API).

**Done when:** on staging with Polaris's provider key, MongoDB Atlas (`https://cloud.mongodb.com/api/atlas/v2`, digest) and SendGrid are each added through the wizard. Polaris's proposals need at most small edits, the logos appear, the read-only key steps are right, and Test goes green with a real read-only key. Otherwise: Couldn't check, needs Polaris's AI provider and keys from Steve.