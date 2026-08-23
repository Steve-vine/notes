---
id: 01M0PZ23RFHHK4M0BHFSXMBSHZ
created: 2026-08-23T09:26:07.887669Z
updated: 2026-08-23T10:06:51.996552Z
type: task
title: 'Vendor detail layout: certifications join Assurance, contacts and engagements move up'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 384
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Three layout changes on the vendor detail Details tab (`VendorDetailPage.tsx` stack, cards in `vendors/detail/cards.tsx`):

- [ ] **Certifications becomes a sub-section of Assurance profile** — inside the same card/block, not a separate `CertificationsCard`. Fold the certifications table + add/edit affordances into `AssuranceCard` under a sub-heading; retire the standalone card. Keep the certification hooks/endpoints as they are — this is presentation, not model.
- [ ] **Contacts moves up to sit immediately below Details.**
- [ ] **Engagements moves up to sit immediately below Contacts.**

Resulting stack: Lifecycle · Details · **Contacts** · **Engagements** · **Assurance (incl. Certifications)** · Flags · Linked Risks · Transcript · Danger Zone — the transcript-last (COM-299) and danger-zone-truly-last (COM-350) orderings are unchanged.

- [ ] Check the sub-section heading levels inside Assurance read as one block (certifications shouldn't look like a second card trapped inside).
- [ ] Tests: card order assertions updated; certifications functionality (add/edit/remove) still passes from its new home.