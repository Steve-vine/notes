---
id: 01M1PJ63W7YYGB9M2YZS3YBN8S
created: 2026-09-04T15:56:49.415783Z
updated: 2026-09-04T17:13:52.622834Z
type: task
title: The Role column is authored somewhere else, and never says where
project: 01KX671DATY39VW6GWK3M2T3DN
number: 773
sprint: s7nj09w
assignee: steve
label:
- improvement
priority: medium
task_status: active
tech: null
---
Smoke finding, ISE-765 (#705), Business Application detail page.

The Members table has four columns: Resource, How, **Role**, Entity Context.
Three of them behave consistently; Role does not.

**What Role actually is.** It is not a member field, and there is no member-level
write for it anywhere — not in the UI, not in the API. It is a read-time
projection: the capability that names this member as a provider, plus that
provider's position — `capability_name · primary` or `· fallback N`
(`BusinessApplicationDetailPage.tsx:687-704`, fed by
`business_applications_api.py:212-215, 673-674` via
`business_capabilities.covering()`, first match wins). The only way to change it
is for an admin to author a Capability with an ordered provider list, from the
**Capabilities** section further up the page → *Edit capabilities* →
`PUT /api/v1/business-applications/{entity_id}/capabilities`. That is correct per
ADR 0109 §1 — capabilities are authored as structure, and nobody should type a
role onto a member.

**The defect is that the cell never says so.** When a member is not a provider
the Role cell renders inert italic dimmed text, "not described", with a grade
tooltip — no link, no button, no mention of capabilities. Directly beside it sits
Entity Context, whose empty state is a dashed "Describe what this does…" that
opens an editor in place. Two adjacent columns, both empty, both authorable — one
invites you, one reads as a field ISE has failed to populate. An operator
reasonably concludes Role is broken or unbuilt. `ui-brief.md:118` specifies the
column as "*not described*" and attaches "editable inline" to Entity Context
only, so the current render matches the brief; the brief is what is short, not
the code.

**A second asymmetry underneath it.** Entity Context is gated on `operator`
(`canDescribe`, line 136, with a comment explaining why: it is the desk's local
knowledge). *Edit capabilities* is gated on `admin` (`canManage`, lines 132, 445;
the endpoint takes `AdminUser`). So a non-admin operator sees a Role column they
can never fill, and gets no explanation for it.

**Proposed**

- Give the empty Role cell the affordance shape Entity Context already has: a
  dashed action that opens the capability editor, worded as the act rather than
  the field — e.g. "Name this in a capability…". Leave the
  `capability_name · primary` badge unchanged when set.
- When the viewer lacks `admin`, render dimmed explanatory text rather than a
  dead cell: "Not named in a capability — an admin declares these."
- Decide, and record, whether capability authoring stays admin-only or drops to
  operator alongside Entity Context. Declaring a capability is a stronger
  statement than describing a box, so admin may well be right — but ADR 0108 §4's
  argument for putting authoring on this page ("describing the parts of an
  application you are already looking at") applies to both acts equally, and the
  split currently exists only in code. If it stays, it belongs in ADR 0109's
  consequences.
- Update `ui-brief.md:118` to describe the Role column's empty state as an
  invitation, not a value.

No backend change; the API already returns everything the cell needs.
