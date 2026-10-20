---
id: 01M54KDFX2H3EYXPBW99CRBV0F
created: 2026-10-17T09:34:47.20244Z
updated: 2026-10-20T12:24:28.020145Z
type: task
title: Other modules feed a control's Evidence of operation — vendor reviews, access recertifications, asset recertifications and content reviews
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1060
blocked_by:
- 01M54K7WXVGPCGPD43HMDK98PP
comments:
- id: 01M5CMAA4V3NZBGS3X5KQ3E7BG
  author: Steve Vine
  at: 2026-10-20T12:24:27.034824Z
  text: |-
    Split into four per-module tasks (2026-10-20), all in Backlog and unscheduled:
    - **COM-1153:** vendor reviews feed VEM.3, VEM.5 and VEM.12.
    - **COM-1154:** access recertifications feed ACC.4 and IDM.5, plus ACC.3 for directory-role schedules. Build after COM-837 (withdraw), which is in progress.
    - **COM-1155:** asset recertifications feed ASM.1, ASM.2, ACC.4 (asset access) and PDH.13 (data assets).
    - **COM-1156:** content reviews feed INS.15 and INS.6.

    **The control question:** fixed controls per module, the same for every company. That is the pattern Incidents, Attestations and DSR already follow. It is not set per schedule or in settings. I checked every control against the library by key.

    Each task says what "last done", "next due" and the warning mean in its module's terms, and what evidence it links to. Each also lists its own calls for you to confirm. The main one: a content review is not repeated on every control in the policy's domain (reasons in COM-1156).

    No code for this task.
assignee: steve
label:
- follow_up
priority: low
task_status: review
---
Follow-up from sprint 75 (ADR in COM-1041; Steve, G, 2026-10-17: "later"). Logged so it isn't lost; not scheduled. Split into one task per module when it is.

## Why

Sprint 75 makes **Evidence of operation** (COM-1051) the one place a control shows it's working, with SAP as its only source. Several things Compass already does also prove a control operates, but none of them show on the control today:

- **Vendor reviews:** the supplier-management controls (e.g. s42.VEM.7);
- **Access recertifications:** the access-review controls;
- **Asset recertifications:** the asset-inventory and asset-access controls;
- **Content reviews:** the policy-review controls, and the domain's policy for every company.

## What each would need settled (with Steve, per module)

- **Which control(s) it evidences.** It could be fixed per module, set per schedule (like SAP's links), or set once in the module's settings. This is the main question, because modules don't link to controls today.
- **What counts as "last done" and "next due"** in that module's own terms, such as a recertification run finishing or a review being recorded.
- **What evidence it offers:** a link to the run or review, and any files.

## Notes (technical)

- Each becomes a new source in COM-1051's registry; the contract is in the ADR.
- COM-1048's calendar adapters already read the recertification and content-review dates and should be reused.

**Done when:** split into per-module tasks with the control question answered for each.