---
id: 01M74948VE3JKVPHTDFZSFSXTG
created: 2026-11-11T03:06:22.958291Z
updated: 2026-11-11T03:06:26.404799Z
type: task
title: 'Pre-UAT fixes for collection capabilities: the Internal addresses trail, the Address hint, and the closing rule following "only what changed"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1718
sprint: sj4f1kj
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found in Claude's pre-UAT pass on staging (74c7156f), as E2E Admin A in E2E Test Company.

**Chain:** independent (frontend only)

1. **Admin ▸ Integrations ▸ Internal addresses** (COM-1711): the trail reads "Integrations › Integration". It should name the page: "Internal addresses".
2. **A Collection integration's Settings ▸ Address** (COM-1711): the hint still says "https only, and on the internet: Compass can't reach private or on-premises addresses." Internal addresses an administrator approved can now be reached, so the hint should say so.
3. **Feed editor** (COM-1709): typing an "Only what changed" value greys out "When a complete read no longer has it" and explains why. But if that option was already chosen, it stays chosen, and saving is then refused by the server. The rule should switch to "When the source says so" by itself.

## Done when
- Each of the three is fixed and covered by a screen test.