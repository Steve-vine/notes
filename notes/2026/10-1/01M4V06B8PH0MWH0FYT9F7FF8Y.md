---
id: 01M4V06B8PH0MWH0FYT9F7FF8Y
created: 2026-10-13T16:05:40.246975Z
updated: 2026-10-14T07:26:10.81901Z
type: task
title: Access Control ▸ Admin gains Role mappings — an alt title and a filter for each of the four role boxes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 941
sprint: s192kdq
comments:
- id: 01M4V2GRMD5WER0GRNMGHDV809
  author: Steve Vine
  at: 2026-10-13T16:46:18.765534Z
  text: |-
    Merged to main (PR #936, 2026-10-13). Not on staging until all four POC Tweaks tasks are in review.

    What to look at:
    - Access Control ▸ Admin ▸ Role mappings, the card after Joiner fields.
    - Four lines: Primary role, Additional role 1, Additional role 2, Additional role 3. Each has an Alt title box and a Filter box, and a "Roles offered" column.
    - Type a title and a filter on a couple of lines and press Save. One Save covers all four lines. Discard changes puts back what was saved.
    - After saving, each line with a filter says how many roles it matches ("12 of 40 roles"). A line with no filter says "Every role (40)". While a filter is being typed and not yet saved it says "Save to count".
    - Save a filter that matches nothing: the line says "No role matches". On Primary role it adds that a joiner can't be raised until one does.
    - Save a filter that is not a valid expression, for example [abc. It is refused with a message naming the line, and what you typed stays in the box.
    - Reload the page: the settings are still there. Switch company: the other company has its own.

    Different from the task text:
    - There is a Discard changes button beside Save.
    - The count is the saved filter's. It does not update as you type, because only the server reads a filter.

    How a filter matches: against the role's name, ignoring upper and lower case, anywhere in the name. ^Dept means "starts with Dept". Sales|Marketing means either word.

    This card changes nothing on the forms by itself. COM-942 makes the forms show the titles and COM-943 makes them use the filters.

    Technical: migration 0251 (role_field_mappings, company-scoped, one row per box that has something set). GET and PUT /api/v1/role-field-mappings under Access write. The filter is compiled and matched on the server only (Python re, case-insensitive search); pattern capped at 200 characters, title at 60. The table is audited. Not looked at in a real browser by me.
- id: 01M4V44P038V3H1JQ6SJ43YH94
  author: Steve Vine
  at: 2026-10-13T17:14:40.003032Z
  text: 'Update to the note above: since looked at in a real browser (headless Chromium, stubbed data). The four lines, the two boxes on each, the "Roles offered" column in its three states (a count, "No role matches", "Save to count") and the Save and Discard changes buttons all lay out as described.'
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Part of the POC Tweaks sprint. This is the settings card only: on its own it changes nothing on the forms. The two tasks after it make the forms use what is set here, so the three go to staging together. Independent of COM-940.

## What people see

- **Access Control ▸ Admin gains a "Role mappings" card**, below Joiner fields, for the current company.
- **Four lines, one for each role box on the joiner and mover forms:** Primary role, Additional role 1, Additional role 2, Additional role 3. The four lines are fixed: none can be added or removed.
- **Each line has two settings.**
  - **Alt title:** a name for that box, typed freely. Blank means the box keeps its standard title.
  - **Filter:** a regular expression that decides which roles that box offers. Blank means every role.
- **How a filter matches:** against the role's name, ignoring upper and lower case, anywhere in the name unless the expression is anchored (`^Dept` for "starts with Dept").
- **A filter that is not a valid expression is refused on save**, with a message saying so, and nothing is changed.
- **Each filter says how many roles it matches right now** ("12 of 40 roles"), so a filter that matches nothing is seen here and not found later on an empty box in the form. *(My addition, not in Steve's ask; cheap because the server already does the matching.)*
- **Everything is blank to begin with**, so until somebody fills this in the forms are exactly as they are today.
- **Who:** whoever can change the rest of this tab (Access write). Each change is in the activity record.

## Notes (technical)

- **Storage.** A new company-scoped table (`role_field_mappings`): one row per company and box, `field` one of `primary`, `additional_1`, `additional_2`, `additional_3`, with nullable `alt_title` and `filter_pattern`. Unique on (company, field). A string with a check constraint is enough for `field`; if it becomes a Postgres enum, create the type explicitly before the column references it. Next migration is 0251; keep the revision id to 32 characters.
- **API.** `/api/v1/role-field-mappings?company=`: a GET returning all four (blank ones included, so the screen never has to invent a row) and a PUT replacing them. `require_access_business_roles` and `require_writable_company`, the same as `joiner-fields`. Regenerate `schema.d.ts`.
- **The filter is evaluated on the server only.** Python `re`, `IGNORECASE`, `search`. Compile it on save to validate; a `re.error` is a 422 with a sentence a person can act on. Cap the pattern at 200 characters and the title at 60. Role names are short and only Access admins write patterns, which is what keeps a pathological expression from mattering; say so in a comment at the call.
- **No regular expression is built in the browser.** `new RegExp(variable)` fails the sast gate, and one engine means this card and the forms cannot disagree about what matches. The match count comes back on the GET (`matching_roles`, `total_roles`).
- **Audit.** The table joins `_AUDITED_TABLES`.
- **Screen.** `access/RoleMappingsSection.tsx`, added to `SECTIONS` in `AccessAdminPage.tsx` after Joiner fields, with a description line in the card like its neighbours. Save the way the Joiner fields card saves. If the four lines are a table it needs `SortableTh` or a no-sort comment for the screen-conventions test.
- **Tests.** Backend: valid and invalid patterns, case, anchors, company scoping, who may write. Front end: the card on `AccessAdminPage.test`, and the refusal message.

**Done when:** on staging an Access admin sets a title and a filter on each of the four lines, sees how many roles each filter matches, is refused an invalid expression, and finds the settings still there after a reload.