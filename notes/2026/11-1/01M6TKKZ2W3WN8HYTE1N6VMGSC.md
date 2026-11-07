---
id: 01M6TKKZ2W3WN8HYTE1N6VMGSC
created: 2026-11-07T08:57:18.684856Z
updated: 2026-11-07T11:00:32.737165Z
type: task
title: A Collection integration can send fixed extra headers on every request (e.g. X-GitHub-Api-Version, Notion-Version) — Polaris fills them in from the docs and the person sees them on the form
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1624
sprint: s5khbev
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Raised by Steve while testing on staging (2026-11-06). Defining GitHub with Polaris, the review step said: "GitHub recommends sending an X-GitHub-Api-Version header (2026-03-10). Compass can't set extra headers, so GitHub will fall back to its default API version." Steve sees this as a miss in Compass, not something to tell the person.

## The problem

A Collection integration sends only its sign-in header and `Accept: application/json`. Many services want a fixed header as well:

- **Optional, but it pins behaviour:** GitHub's X-GitHub-Api-Version, Stripe-Version.
- **Required:** Notion-Version, without which Notion refuses the request; some Atlassian and vendor APIs.

Without it, collected evidence can change shape when the service moves its default version. That would hold captures for review for no reason (COM-1603), or fail outright.

## Done when

- An integration's definition can hold a short list of extra headers (name and value). They are sent on every request: the test read, samples, every collection, and every page. They are not secret, so they show in plain text and are kept with the definition. The key stays in the account, as now.
- Headers Compass sets itself can't be overridden: Host, Authorization, the sign-in key header, Accept, Cookie and Content-Length. Names and values are checked for valid characters.
- Polaris's define step fills in any header the docs require or recommend, with the version current at the time, and doesn't list it under "wasn't sure of". Polaris's explain-a-failed-test step can propose adding or changing one.
- The definition form shows them, so the person can add, edit or remove one, under the rule in COM-1623 for fields on one row.
- Changing the headers re-tests and re-reads each healthy account, as other definition changes do (COM-1620).
- Tests: the headers are sent on every page of a paged read; a reserved header is refused.
- On staging, re-defining GitHub sends X-GitHub-Api-Version and the test read passes.

## Notes

- This is on the chain: it adds a definition field (a migration) and changes the API.
- It relates to COM-1621 (what the "wasn't sure of" box shows). This example disappears once this task lands.
- Where: `core/collection/client.py` `_headers`, `core/collection/polaris_define.py` (`_DEFINITION_PROPERTIES`, DEFINE_SYSTEM), the collection integration model and schema, and `integrations/collection/DefinitionForm.tsx`.