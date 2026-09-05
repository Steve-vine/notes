---
id: 01M1RYVJWNE5XX66XCH6PJF5HW
created: 2026-09-05T14:16:44.693138Z
updated: 2026-09-05T14:31:37.617504Z
type: task
title: an action says which company it is for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 560
sprint: s2fcksg
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Found by Steve on staging, 2026-09-05.

The Actions queue reads across every company — turn **This company only** off and you get everyone's outstanding work in one list. Once it is off, **nothing on the row says which company the work belongs to.** Type, what, owner, due, status: five columns, none of which answers "whose is this?". The only company on the screen is the switcher at the top of the shell, and it is naming a company most of those rows have nothing to do with.

That makes the cross-company view close to unusable — you cannot triage it, you cannot tell two similarly-named gaps apart, and you cannot reconcile the total against the companies you can actually pick. It is the same failure COM-555 fixed for empty lists, one screen over: the answer is company-scoped and the screen never says which company.

It also cost real diagnostic time: this is what made COM-561 look like a deleted company still holding open work, when in fact it was 54 tenant-wide items that carry no company at all.

## What changes

- With **This company only** off, the table names the company on every row. Scoped to one company the column goes away — it would say the same thing on every line.
- **Rows with no company say what they are, never a blank.** Two kinds reach the queue with no company, and they are not the same thing:
  - out-of-band directory changes that are tenant-wide by design — a group or account created in the tenant belongs to no company's matrix (54 of these open on staging today);
  - content reviews, which are global playbook work.

  They want distinct wording — "Tenant-wide" and "Content library" — not one shared placeholder. A blank cell here is exactly the ambiguity that started this.
- Check what the **portal's** Actions list should do — it shares this table (`ActionsTable`, the `showOwner` precedent) and a portal reader can hold work in more than one company. If it should name the company too, it comes free; if not, it is one flag.

## Technical

`ActionOut` already carries `company_id` and the frontend ignores it. The **name** should come from the server rather than being resolved client-side against `/companies`: that list excludes archived companies, so exactly the rows whose company is hardest to identify are the ones a client-side lookup would fail on. Add the name to the schema, regenerate `schema.d.ts`.

## Related

- COM-561 — tenant-wide work vanishes from Actions as soon as you scope it to a company. Do them together: that one stops the rows disappearing, this one makes them legible.
- COM-555 — an empty list says which company it is empty for. Same class of bug.
- COM-562 — an archived company's work leaves the queue.
