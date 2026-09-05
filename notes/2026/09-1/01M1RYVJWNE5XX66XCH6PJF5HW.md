---
id: 01M1RYVJWNE5XX66XCH6PJF5HW
created: 2026-09-05T14:16:44.693138Z
updated: 2026-09-05T14:16:44.693138Z
type: task
title: an action says which company it is for
task_status: backlog
label: bug
assignee: steve
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 560
---
Found by Steve on staging, 2026-09-05.

The Actions queue reads across every company — turn **This company only** off and you get everyone's outstanding work in one list. Once it is off, **nothing on the row says which company the work belongs to.** Type, what, owner, due, status: five columns, none of which answers "whose is this?". The only company on the screen is the switcher at the top of the shell, and it is naming a company most of those rows have nothing to do with.

That makes the cross-company view close to unusable — you cannot triage it, you cannot tell two similarly-named gaps apart, and you cannot reconcile the total against the companies you can actually pick. It is the same failure COM-555 fixed for empty lists, one screen over: the answer is company-scoped and the screen never says which company.

## What changes

- With **This company only** off, the table names the company on every row. Scoped to one company the column goes away — it would say the same thing on every line.
- Rows that genuinely have no company say so rather than showing a blank. Content reviews come from the global library and carry no company; they should read as the library, not as a missing value. This matters more than it sounds: those rows are part of why the all-companies total is larger than the per-company totals added up, and today nothing on screen explains the difference (see the sibling task on the counts).
- Check what the **portal's** Actions list should do — it shares this table (`ActionsTable`, the `showOwner` precedent) and a portal reader can hold work in more than one company. If it should name the company too, it comes free; if not, it is one flag.

## Technical

`ActionOut` already carries `company_id` and the frontend ignores it. The **name** should come from the server rather than being resolved client-side against `/companies`: that list excludes archived companies, so exactly the rows whose company you cannot identify are the rows a client-side lookup would fail on. Add the name to the schema, regenerate `schema.d.ts`.

## Related

- COM-555 — an empty list says which company it is empty for. Same class of bug.
- Sibling: the actions total counts work for companies that are not in the list.
- Sibling: an archived company's work leaves the queue.
