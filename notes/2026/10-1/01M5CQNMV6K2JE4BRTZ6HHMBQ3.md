---
id: 01M5CQNMV6K2JE4BRTZ6HHMBQ3
created: 2026-10-20T13:23:04.166051Z
updated: 2026-10-20T13:23:04.166051Z
type: task
title: '"Kind of person" on a data subject request is called "Data entities", worded like Vendors'
label: improvement
assignee: steve
task_status: todo
priority: low
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1174
---
Steve's request while smoke-testing sprint 79.

**Change:** on Log a request ▸ About the request, rename the "Kind of person" field to match the Vendors form:
- Label: **Data entities**
- Description: **Which parts of the business have data in scope?**

It's the same list in both places: the data entities in the data rubric. Using the same name makes that clear.

**Follow it through** so the module says the same thing everywhere the field shows up:
- the request's Details card (and Edit details)
- the group picker under Disclosures ▸ About whom
- the Fulfil messages ("No kind of person is set on the request…", "Inventory lists no system holding this kind of person…")
- the accounting of disclosures and the Tell recipients suggestions ("disclosures about a group of their kind of person")
- the request timeline and the close checklist
- the assistant's tool descriptions

Behaviour doesn't change: it's still one optional choice per request, and it still decides which systems Fulfil lists.

**Done when:** "Kind of person" no longer appears anywhere in Data Subject Requests, and the field on Log a request reads "Data entities" / "Which parts of the business have data in scope?".