---
id: 01M194EG5F6VGNR43SFJVWQWGT
created: 2026-08-30T10:46:36.463981Z
updated: 2026-08-30T12:53:27.406966Z
type: task
title: Extra fields on devices
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 532
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
comments:
- id: 01M19BPRFKMFCTP3G4RVYPP56G
  author: Steve Vine
  at: 2026-08-30T12:53:27.155416Z
  text: |-
    Shipped — PR #539, merged to main as 70789c0. Taken last, as you said, now the other four have earned their keep.

    Devices stay browse-only inventory — this does not move them onto the governable surface, and nothing acts on a device's fields.

    Your case against is real, so it shaped one decision: the device field set ships **empty**, for somebody to decide on, rather than seeded with anything. Intune already carries most device metadata, and a field defined by default is a second place to write it that nobody chose. The case *for* — the device that keeps appearing in a report and needs "known exception, signed off, see ticket X" against it — is what the test asserts.

    Wiring: `ExtraFieldsPanel` with `objectType="device"` on the device modal, no backend change, no migration.
assignee: steve
company: null
label:
- feature
priority: low
task_status: review
---
Extend extra fields to devices, on the machinery built for groups. Last of the five, and the weakest case — take it only once the others have earned their keep.

Devices are deliberately browse-only inventory (ADR 0045, 2026-08-23 amendment): they exist so a device-only security group stops reading as empty, and they sit outside the governable surface. Extra fields do not change that — a device's fields are notes about the device, and nothing acts on them.

The case for doing it at all is a device that keeps appearing in a report and needs a "known exception, signed off, see ticket X" note against it. The case against is that Intune already carries most device metadata, and a second place to write it invites drift.

Same rules as groups if it is built: an Access Manager or above defines the fields, anyone with Access read fills them in, values are Compass's own and untouched by sync, changes land in the activity log.