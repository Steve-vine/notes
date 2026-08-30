---
id: 01M190TWJCDMC1MSQB0G5EH9QA
created: 2026-08-30T09:43:28.076838Z
updated: 2026-08-30T15:13:53.949602Z
type: task
title: An exception badge opens its request without losing your place
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 526
sprint: sz42uhw
comments:
- id: 01M1972B3CYM6RYB4NBKNYGWKX
  author: Steve Vine
  at: 2026-08-30T11:32:23.788024Z
  text: |-
    Shipped — PR #533, merged to main as bba10e6.

    The badge opens the request over whatever you were reading; closing it puts you back on the same account, same scroll position, nothing reloaded — the test counts the account reads rather than hoping. Same from a group's members and its nested groups.

    `RequestDetail` is exported and otherwise unforked, with the three things you named sorted out: the "← Requests" button lifted into the page, the amendment cross-links swapping the modal's request instead of navigating, and request actions now invalidating the directory reads as well as the request ones (worth doing rather than waiting for a pass, now that COM-525 puts a Compass write in the mirror straight away).

    **One choice worth flagging.** The opener arrives by React context rather than as a prop. The badges are three and four components down — an account's groups, a group's members, its nested groups — and threading an opener through each would have made "one badge, one behaviour, wherever it appears" a promise nobody could keep. Without the provider the badge is an ordinary link, which is the right answer on a page.

    The URL is untouched and the badge is still a real anchor: only the plain left-click is intercepted, with a test for the modifier-click.

    Convention written into `brief/information-architecture.md` → *Screen conventions*: two deep and the second is a leaf (a modal with links of its own swaps its content rather than stacking a third — anything wanting a third level is a page), Escape closes only the top, the one underneath keeps its state, and the link stays a link.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: done
---
Open an account, work down its groups, click the **Exception** badge to see who approved one — and the account you were reading is gone. You are on the request page, and getting back means navigating to the account again and finding your place in the list.

The badge is right to be clickable: "who asked for this, and why" is always the next question. It is the *leaving* that is wrong. Checking one line of someone's access should not cost you the rest of it.

## What changes

The badge opens the request in a modal over whatever you were reading. Close it and you are back on the same account, same scroll position, nothing reloaded.

Same for the two badges on a group — its members and its nested groups. One badge, one behaviour, wherever it appears.

## This is cheap

`RequestDetailPage` already separates the routing from the content: it reads the id from the URL, fetches, and hands a request object to `RequestDetail`, which renders it and knows nothing about routing. That component is the modal body. It only needs exporting.

Three things to sort out with it:

* **The "← Requests" back button** (`RequestDetailPage.tsx:82`) belongs to the page, not the body. Lift it into `RequestDetailPage`; in a modal the close button is the way back.
* **The amendment cross-links** (:112, :119 — "the original change", "a corrective request") sit *inside* the body and would navigate away, reintroducing the same defect one level down. In a modal they should swap which request the modal is showing. On the page they keep navigating.
* **Actions still work.** Approving or rejecting from inside the modal must refresh the account underneath, since the badge it was opened from may no longer say the same thing.

## Keep the URL working

`/access/requests/:id` stays exactly as it is. People paste request links to each other and follow them from notifications, and that has to keep landing on a readable page.

So the badge stays a real anchor with a real `href` — plain left-click is intercepted to open the modal, and ctrl/cmd-click, middle-click and "open in new tab" keep doing what they have always done. Turning it into a button would fix the reported problem and quietly remove opening a request in a second tab, which is the other way people avoid losing their place.

## A convention to set

This is the codebase's **first modal opened from a modal** — nothing stacks today, and `brief/information-architecture.md` → *Screen conventions* has nothing to say about it yet. Mantine has `Modal.Stack` for exactly this, so the mechanism is not the question; the convention is.

Worth settling here and writing into the brief, because the next one will copy it: how deep stacking may go (two, and no further, is the defensible answer), that Escape closes only the top modal, and that the one underneath keeps its state rather than remounting.

## Verifying

Open an account, click an exception badge, close it — assert the account is still open, still showing the same groups, and did not refetch. Then the same from a group's members and its nested groups. Then a modifier-click, asserting the anchor's `href` is intact and the modal did not open.
