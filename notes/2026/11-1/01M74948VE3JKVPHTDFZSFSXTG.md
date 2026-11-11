---
id: 01M74948VE3JKVPHTDFZSFSXTG
created: 2026-11-11T03:06:22.958291Z
updated: 2026-11-11T11:49:43.426838Z
type: task
title: 'Pre-UAT fixes for collection capabilities: the Internal addresses trail, the Address hint, and the closing rule following "only what changed"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1718
sprint: sj4f1kj
comments:
- id: 01M74AA5N8HWHPGBB1X4VDTDBW
  author: Steve Vine
  at: 2026-11-11T03:27:04.871962Z
  text: |-
    Merged to main in #1714 (158f3e41).
    - The Internal addresses page names itself in the trail.
    - The Address hint now says "https only. An address on your own network works once an administrator approves it under Admin ▸ Integrations ▸ Internal addresses."
    - In the feed editor, entering "Only what changed" switches "When a complete read no longer has it" to "When the source says so" by itself.

    FeedsTab test extended. It reaches staging with the next deploy: main is taking sprint 115's merges now, and staging is on 74c7156f.
- id: 01M74B7Q6G4J19C6E14ETF9BGZ
  author: Steve Vine
  at: 2026-11-11T03:43:13.104295Z
  text: |-
    Pre-UAT on staging (305de68a, deployed by compass-c6 with sprint 115), as E2E Admin A: **Passed**.
    - The Internal addresses trail reads "Integrations › Internal addresses".
    - GitHub ▸ Settings ▸ Address hint: "https only. An address on your own network works once an administrator approves it under Admin ▸ Integrations ▸ Internal addresses."
    - Feed editor: I chose "When a complete read no longer has it", then entered updated_since under "Only what changed". The rule switched to "When the source says so", with the explanation. Nothing was saved.
assignee: steve
label:
- bug
priority: low
task_status: done
---
Found in Claude's pre-UAT pass on staging (74c7156f), as E2E Admin A in E2E Test Company.

**Chain:** independent (frontend only)

1. **Admin ▸ Integrations ▸ Internal addresses** (COM-1711): the trail reads "Integrations › Integration". It should name the page: "Internal addresses".
2. **A Collection integration's Settings ▸ Address** (COM-1711): the hint still says "https only, and on the internet: Compass can't reach private or on-premises addresses." Internal addresses an administrator approved can now be reached, so the hint should say so.
3. **Feed editor** (COM-1709): typing an "Only what changed" value greys out "When a complete read no longer has it" and explains why. But if that option was already chosen, it stays chosen, and saving is then refused by the server. The rule should switch to "When the source says so" by itself.

## Done when
- Each of the three is fixed and covered by a screen test.