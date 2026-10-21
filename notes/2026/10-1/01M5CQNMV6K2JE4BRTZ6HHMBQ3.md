---
id: 01M5CQNMV6K2JE4BRTZ6HHMBQ3
created: 2026-10-20T13:23:04.166051Z
updated: 2026-10-21T20:16:50.680532Z
type: task
title: '"Kind of person" on a data subject request is called "Data entities", worded like Vendors'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1174
sprint: ss8348q
comments:
- id: 01M5EYX0QBRY3FP5RJEZB610YK
  author: Steve Vine
  at: 2026-10-21T10:07:54.603328Z
  text: |-
    Done — PR #1192, merged 21 Oct 11:07 BST.

    - On Log a request ▸ About the request, the field is now **Data entities**: "Which parts of the business have data in scope?", the same as the Vendors form. It's still one optional choice, and it still decides which systems Fulfil lists.
    - The Details card, Edit details and the close checklist say "Data entities". The timeline says "Details changed: data entities". Older timeline entries show the new wording too.
    - Disclosures ▸ About whom: the group picker is labelled "Data entities". Incidents' disclosure window shares this picker, so it changes there as well.
    - Fulfil says "No data entity is set on the request…" and "Inventory lists no system holding this data entity…".
    - Tell recipients suggests "disclosures about a group in the request's data entity", and the accounting reads "Disclosures about a group in {name}".
    - The assistant's descriptions and messages say "data entity".

    Under the hood the field keeps its old internal name, so nothing that connects to Compass breaks. "Kind of person" no longer appears anywhere on screen.
assignee: steve
label:
- improvement
priority: low
task_status: done
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