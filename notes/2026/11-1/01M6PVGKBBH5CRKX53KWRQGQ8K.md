---
id: 01M6PVGKBBH5CRKX53KWRQGQ8K
created: 2026-11-05T21:58:19.243891Z
updated: 2026-11-05T22:02:19.484058Z
type: task
title: Add a Collection integration with Polaris — name the service and paste its API documentation link; Polaris proposes the address, sign-in, paging, a test read and the logo, and says how to make a read-only key; you paste the key, Compass tests it, you save
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1600
sprint: s1jcke1
assignee: steve
label:
- feature
priority: high
task_status: todo
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