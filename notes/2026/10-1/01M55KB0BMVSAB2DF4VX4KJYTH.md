---
id: 01M55KB0BMVSAB2DF4VX4KJYTH
created: 2026-10-17T18:52:40.180628Z
updated: 2026-10-17T18:52:43.818306Z
type: task
title: The standard plan links each activity to the right control, by its library key, not a reference that has since been renumbered
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1062
sprint: sxflvhs
assignee: steve
label:
- bug
priority: high
task_status: active
---
Sprint 75 fix-forward (found after COM-1057 reached staging, before anyone used it).

## What was wrong

The standard plan names its controls by their stable library **key** (SEA.1, VUM.3, DBR.3…), but adding it looked them up by **reference**. Several controls were renumbered (ADR 0059), so some activities linked the wrong control or none:

- External penetration test → VUM.3 is now patch deployment; the pen-test control is **VUM.7**
- Vulnerability scan review → **VUM.5, VUM.6** (not VUM.1/2, now patching)
- Backup restore test → **BCR.15** (was DBR.3, linked nothing)
- DR / BCP exercise → **BCR.8**, BCR.3 (BCR.10 is now building evacuation)
- Incident response tabletop → **IMA.9** (IMA.11 is now incident categorisation)
- Access review → **ACC.4** (ACC.8 is now device lock)
- Policy review → **INS.15**; Supplier review → **VEM.12** (both linked nothing)
- Management review → **INS.6** (INS.13 is now executive accountability)

Unchanged: SEA.1, SEA.2, SEA.9, RIM.2, INA.2.

## Fix

- Look controls up by key; show and link the control's current reference.
- The test pins each key to its current reference, so a renumbering is caught.

**Done when:** every standard activity links the control its key names, and the window shows their current references.