---
id: 01M6M6GFFFGTK0VW50F9RWM1ZQ
created: 2026-11-04T21:12:46.319932Z
updated: 2026-11-05T00:57:19.678542Z
type: task
title: 'Add controls: list the domains in alphabetical order'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1583
sprint: srkxswe
comments:
- id: 01M6MCXWGH1QBT51MF7KD36J3V
  author: Steve Vine
  at: 2026-11-04T23:04:57.105554Z
  text: |-
    Done: PR #1602, merged to main as 2193d575.

    What changed: the Domain drop-down on an initiative's Add controls window now lists domains A–Z by name. "Every domain" is still the empty choice.

    Tested by InitiativeTabs.test.tsx, which serves the domains out of order and asserts the A–Z order. It fails without the fix. It goes to staging with the rest of the sprint.
- id: 01M6MKBN1Y1JFHVGBD1TSJTREF
  author: Steve Vine
  at: 2026-11-05T00:57:19.678419Z
  text: |-
    Pre-UAT: Passed (staging b69117dc, E2E Test Company, E2E Admin A).

    Steps: opened INI-1, then Add controls, then the Domain drop-down.

    Seen: all 24 domains A–Z, from Access Control, AI Governance, Asset & Configuration Management… to Threat Protection.

    Screenshot: ~/compass-uat/initiatives-improvements/COM-1583/domains-a-z.png
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
On an initiative's **Add controls** window, the Domain drop-down doesn't list domains alphabetically. Sort it A–Z by domain name. "Every domain" stays as the empty choice.

**Done when:** opening Add controls on an initiative shows every domain in the Domain drop-down sorted A–Z by name. Narrowing to a domain still shows only that domain's controls.

**Implementation:** `app/frontend/src/initiatives/AddControlsModal.tsx:63` builds `data` from `useDomains()` in API order. Sort it with `localeCompare` on `name`. Add a Vitest case asserting the order.

**Independent:** frontend only, no migration, no API change.

Found by Steve while testing Initiatives (2026-11-04).