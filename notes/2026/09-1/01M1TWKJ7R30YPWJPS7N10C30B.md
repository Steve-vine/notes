---
id: 01M1TWKJ7R30YPWJPS7N10C30B
created: 2026-09-06T08:15:53.592107Z
updated: 2026-09-06T11:28:10.318819Z
type: task
title: an admin screen listing every uploaded file
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 572
sprint: s2fcksg
comments:
- id: 01M1V16ADBTPXXDGBTMD9X0KCZ
  author: Steve Vine
  at: 2026-09-06T09:36:02.475675Z
  text: |-
    Done — PR #581, merged to main.

    A **Files** tab under Admin (`admin.manage_configuration`, so it sits with Review cadence rather than among the tabs that configure things — it reports, it changes nothing). Newest first: the file with its type and size, what it is attached to as a link, whose it is, and when and by whom. Filters by company and by what it is attached to, with the totals over the **whole filtered set** rather than the page — a total counting only the fifty rows on screen would answer a question nobody asked.

    Both boundaries you named are held by a test, not just by intent:

    - **No admin download.** `test_there_is_no_admin_download` asserts the endpoints do not exist, and a frontend test asserts no row links anywhere except at a record. The router returns metadata and a path; opening a file stays behind the checks that already exist.
    - **No report outputs.** The list is `attachments` only. Say the word if the question you want answered turns out to be "what is on the volume" rather than "what have people put in" — that is a second section.

    The two details from the related tickets both landed: a library file's company reads **Content library**, and the company filter can *name* that (`company=none`) rather than leaving it reachable only by clearing the filter; and a file whose record is gone is shown, saying so, rather than hidden.

    The existence check is a button over the filtered set — one storage call per row — capped at 500 with the cap reported, so "none missing" cannot be confused with "we stopped looking". It answers something nothing else in Compass asks: a row whose object has gone reads perfectly until somebody tries to download it.

    Small thing while I was there: `humanSize` gained GB. It now renders a total against a volume measured in gigabytes, and "2048.0 MB" is a number you have to convert before it means anything.

    7 new integration tests; backend 391 and frontend 1001 green. `schema.d.ts` regenerated and verified byte-stable against a second run, so no drift on the trunk.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Raised by Steve, 2026-09-06, after establishing where evidence files actually live (a 2 GiB volume on the g5 node, 116 KB used).

There is no way to see what Compass is holding. Files are only ever visible from the record they hang off — open an assessment, open a risk, open a content item — so nobody can answer "what have we got, whose is it, and how much of it is there" without walking the whole app. That is the question an administrator has, and it is also the question that comes first when the volume fills up or the storage moves.

## The screen

A **Files** tab under Admin, listing every uploaded file, newest first:

- **File** — its name, with its type and size.
- **Linked to** — the record it belongs to, as a link: the control for an assessment's evidence, the risk, the content item. Not an id.
- **Company** — derived through that record. Evidence and risk files carry their company; **library files carry none, and should say "Content library" rather than sit blank** — the COM-560 lesson, and the same distinction between "no company" and "missing".
- **Uploaded** — when, and by whom.

Filters by company and by what kind of thing it is attached to. **Show the total size**, since half the value of this screen is knowing how full the volume is getting.

## Two things to be careful about

**This must not become a second way to read evidence.** The temptation is an admin download endpoint that serves any file by id — which would quietly route around the per-record permissions that decide who may see a company's evidence today. The screen lists metadata and links to the record; opening the file stays where it already is, behind the checks that already exist. If a download from here is genuinely wanted, it needs the owning record's permission checked, not the admin tab's.

**Generated outputs are deliberately not in this list.** Report runs write their exports to the same storage but they are outputs on a retention clock, not things anybody uploaded, and mixing them in would make "what have we got" unanswerable. Worth a second section later if the question becomes "what is on the volume" rather than "what have people put in" — say so if that is what you actually want.

## Worth having, if it is cheap

A file whose bytes have gone missing from storage is exactly what a screen like this should be able to reveal. Checking existence costs a storage call per row, so do it on request — a "check" action over the filtered set — rather than on every page load.

## Related

- COM-573 — the purge leaves attachment rows behind. Those rows would show up here linked to nothing, so it is worth landing first.
- COM-560 — naming what has no company instead of leaving it blank.
