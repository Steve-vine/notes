---
id: 01M6M6GFFFGTK0VW50F9RWM1ZQ
created: 2026-11-04T21:12:46.319932Z
updated: 2026-11-04T21:12:50.276702Z
type: task
title: 'Add controls: list the domains in alphabetical order'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1583
sprint: srkxswe
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On an initiative's **Add controls** window, the Domain drop-down doesn't list domains alphabetically. Sort it A–Z by domain name. "Every domain" stays as the empty choice.

**Done when:** opening Add controls on an initiative shows every domain in the Domain drop-down sorted A–Z by name. Narrowing to a domain still shows only that domain's controls.

**Implementation:** `app/frontend/src/initiatives/AddControlsModal.tsx:63` builds `data` from `useDomains()` in API order. Sort it with `localeCompare` on `name`. Add a Vitest case asserting the order.

**Independent:** frontend only, no migration, no API change.

Found by Steve while testing Initiatives (2026-11-04).