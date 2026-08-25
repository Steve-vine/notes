---
id: 01M0DA3XJRR3XC1RG1SH24KHMG
created: 2026-08-19T15:26:57.112036Z
updated: 2026-08-25T18:43:00.05885Z
type: task
title: The Engagements box relaid out — a titled block per engagement, and the portal's request buttons move in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 288
sprint: sbph5q5
blocked_by:
- 01M0DA29KCKMVPBKK5ZQW05JZR
- 01M0DA3E0T61TNAKYPTRBPV9GW
comments:
- id: 01M0DYJZJQW5RWXZH9GW00B22K
  author: Steve Vine
  at: 2026-08-19T21:24:42.198931Z
  text: |-
    Shipped in PR #286, merged to main as b6c6452.

    `EngagementsCard` relaid out as a titled block per engagement: title as the heading with the status and criticality pills beside it, scope on its own line below, and labelled rows for Data Entities / Data Types / Data Residency — each omitted when it has no values (an empty row reads as "we know this is nothing" when it means "nobody has said"). Data types keep the `name · sensitivity` rendering. Divider between engagements, none after the last.

    The portal's separate "Request a change" card (`RequestsCard`) is deleted along with its duplicate scope list. "Request an amendment" sits opposite each engagement's title, "Request an engagement" bottom-right of the card. Its three conditions came across: no `canSubmitVendorRequest` → no buttons at all; an offboarded vendor gets none and the card says why; an ended engagement gets no amendment button. Its "No engagements to amend yet" message is gone — the existing "No engagements recorded." covers it now the empty state lives in one box.

    `EngagementsCard` learns it is on the portal from an explicit `portal` prop rather than the route, so the internal surface cannot accidentally grow request buttons.

    Tests on both surfaces: block layout with the omitted-when-empty rows; internal shows Edit + Add and neither request button; portal shows both request buttons and no Edit; an ended engagement gets no amendment button while its live sibling does; offboarded; and a reader without submit permission sees neither.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
Follows COM-286/COM-287. `EngagementsCard` (`vendors/detail/cards.tsx`) is rendered by **both** the internal vendor form and the portal one — the portal passes `canEdit={false}` — so this lands once and both surfaces get it.

Today an engagement is a single line of scope followed by an undifferentiated row of badges, and the portal keeps its request buttons in a **separate "Request a change" card** sitting directly beneath. Two boxes describing the same list. The new layout:

```
[Title]                          (Status) (Criticality)      [Request an amendment]
[Scope]
Data Entities:  (entities)
Data Types:     (data types)
Data Residency: (residency)
────────────────────────────────────────────────────────────
[next engagement]
                                                  [Request an engagement]
```

- [ ] **Title is the heading**, with the status and criticality pills beside it; scope drops to its own line below. Labelled rows for Data Entities / Data Types / Data Residency — a row with no values is omitted rather than shown empty.
- [ ] Data types keep the `name · sensitivity` rendering — the sensitivity is what decides which approvals an amendment would need (ADR 0042 §4).
- [ ] **A divider between engagements**, none after the last.
- [ ] **Internal**: "Add engagement" stays in the card header; the per-engagement **Edit** button sits opposite the title.
- [ ] **Portal**: **"Request an amendment"** right-aligned opposite each engagement's title; **"Request an engagement"** bottom-right of the card. The **"Request a change" card is deleted** (`RequestsCard` in `PortalVendorDetailPage.tsx`) along with its duplicate scope list.
- [ ] Porting that card's three conditions into `cards.tsx`, which is currently portal-agnostic: `canSubmitVendorRequest` hides the buttons entirely; an **offboarded** vendor gets no buttons and the card says why (the API refuses it too); an **ended** engagement gets no amendment button. Its "No engagements to amend yet" message is redundant once the empty-state lives in one box — the existing "No engagements recorded." covers it.
- [ ] Both modals (`RequestEngagementModal`, `AmendEngagementModal`) move with the buttons.
- [ ] Decide how `EngagementsCard` learns it is on the portal — an explicit prop rather than reaching for the route, so the internal surface cannot accidentally grow request buttons.
- [ ] Tests on both surfaces: the block layout and its dividers; internal shows Edit and no request buttons; portal shows the request buttons and no Edit; offboarded and ended cases; a user without submit permission sees neither button.