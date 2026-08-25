---
id: 01M0WVWWZ2JQAQ9H8JR616W17A
created: 2026-08-25T16:26:17.954234Z
updated: 2026-08-25T19:30:47.743443Z
type: task
title: '"Request an engagement" becomes "Request a new engagement"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 402
sprint: sbph5q5
comments:
- id: 01M0X6EGJN17V8A3HRVBKN4KA5
  author: Steve Vine
  at: 2026-08-25T19:30:40.853615Z
  text: |-
    Done — PR #404, merged to main.

    The button and the modal title it opens were renamed together (`vendors/detail/cards.tsx`, `vendors/RequestEngagementModal.tsx`), along with the four assertions that match on the label in `VendorDetailPage.test.tsx` and `PortalVendorDetailPage.test.tsx`. The card is shared, so the label changed on the internal vendor page and the portal at once, as intended.

    `KIND_LABELS` in `vendors/requestKinds.ts` was left alone.
assignee: steve
company: null
label:
- chore
priority: low
task_status: review
---
Copy change on the vendor detail page. "Request a new engagement" says what it does — the existing label reads as though it might amend one, which is the button directly above it.

- [ ] The button — `vendors/detail/cards.tsx:2056`.
- [ ] The modal it opens, whose title is the same phrase — `vendors/RequestEngagementModal.tsx:67` (`Request an engagement — {vendorName}`). Renaming one and not the other is the whole risk here.
- [ ] The three assertions that match on the label: `pages/VendorDetailPage.test.tsx:885`, `pages/PortalVendorDetailPage.test.tsx:498,524,534`.

One button, one surface: the card is shared, so this changes the label on both the internal vendor page and the portal at once. Intended.

**Leave `KIND_LABELS` alone** (`vendors/requestKinds.ts`). "New engagement" is the *kind* as it appears in request lists and filters, and it already reads correctly there — a request is not a button.