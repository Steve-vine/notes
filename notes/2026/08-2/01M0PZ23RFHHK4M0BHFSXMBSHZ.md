---
id: 01M0PZ23RFHHK4M0BHFSXMBSHZ
created: 2026-08-23T09:26:07.887669Z
updated: 2026-08-25T18:43:20.378196Z
type: task
title: 'Vendor detail layout: certifications join Assurance, contacts and engagements move up'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 384
sprint: sbph5q5
comments:
- id: 01M0Q1R7HYTW7QP3297A8KWJXG
  author: Steve Vine
  at: 2026-08-23T10:13:09.822736Z
  text: |-
    Done — PR #381, merged to main as 8296827.

    The Details tab stack is now Lifecycle · Details · **Contacts** · **Engagements** · **Assurance (incl. Certifications)** · Flags · Linked Risks · Transcript · Danger Zone, with COM-299's transcript-last and COM-350's danger-zone-truly-last untouched.

    `CertificationsCard` became `CertificationsSection`: same content, same hooks and endpoints, but no `Card` wrapper and the dimmed sub-heading its neighbours inside the Assurance card already use — so it reads as one block rather than a card trapped inside a card, which was the risk you flagged.

    One placement decision worth recording: the sub-section sits **below** the Save button, behind a divider, not above it. Certifications save themselves through their own modal, and above the button a reader could reasonably think "Save assurance profile" also covered the certificate they had just added.

    Beyond the brief but unavoidable: `PortalVendorDetailPage` rendered Assurance and Certifications adjacently too, so it loses its standalone card the same way. Its own card ordering is untouched.

    Tests: a card-order assertion (matched on the card each heading sits in — "Details" is also a tab label and "State" recurs below), and one pinning certifications inside the Assurance card. The existing add/read-only certification tests passed unchanged from the new home.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
Three layout changes on the vendor detail Details tab (`VendorDetailPage.tsx` stack, cards in `vendors/detail/cards.tsx`):

- [ ] **Certifications becomes a sub-section of Assurance profile** — inside the same card/block, not a separate `CertificationsCard`. Fold the certifications table + add/edit affordances into `AssuranceCard` under a sub-heading; retire the standalone card. Keep the certification hooks/endpoints as they are — this is presentation, not model.
- [ ] **Contacts moves up to sit immediately below Details.**
- [ ] **Engagements moves up to sit immediately below Contacts.**

Resulting stack: Lifecycle · Details · **Contacts** · **Engagements** · **Assurance (incl. Certifications)** · Flags · Linked Risks · Transcript · Danger Zone — the transcript-last (COM-299) and danger-zone-truly-last (COM-350) orderings are unchanged.

- [ ] Check the sub-section heading levels inside Assurance read as one block (certifications shouldn't look like a second card trapped inside).
- [ ] Tests: card order assertions updated; certifications functionality (add/edit/remove) still passes from its new home.