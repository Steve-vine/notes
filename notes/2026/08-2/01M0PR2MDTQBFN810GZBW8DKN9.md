---
id: 01M0PR2MDTQBFN810GZBW8DKN9
created: 2026-08-23T07:24:04.922861Z
updated: 2026-08-23T07:24:11.171996Z
type: task
title: 'Portal settings: the From address is settable — warning removed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 373
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
COM-370 shipped the safe variant of sender identity: custom display name on the platform From, custom address as Reply-To, with a deliverability warning about full custom From. Decided: promote the From address to a first-class setting and **remove the warning**.

- [ ] The Portal tab's sender-identity section gains the **From address** as a plain settable field (with the display name, rendering `Display Name <address>`); the deliverability warning copy goes.
- [ ] Vendor-portal emails (contact links, owner notifications) send **From** the configured address when set; fall back to the platform sender when unset. Decide whether Reply-To still mirrors the address or is dropped as redundant once From is real — recommend dropping it.
- [ ] Validation stays (well-formed address); nothing else second-guesses the operator — SPF/DKIM alignment for the chosen domain is deliberately the operator's responsibility now, which is the decision this task records. Worth one line in the mail-settings docs/ADR trail rather than in the UI.
- [ ] Tests: configured From lands on outgoing mail for both email kinds; unset falls back; display-name-only still works; invalid address rejected.