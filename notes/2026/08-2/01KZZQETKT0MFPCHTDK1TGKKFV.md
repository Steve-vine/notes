---
id: 01KZZQETKT0MFPCHTDK1TGKKFV
created: 2026-08-14T08:50:43.962856Z
updated: 2026-08-14T08:50:43.962856Z
type: task
title: Impact is one box in every state — picker, subject and provenance inside it
task_status: backlog
label: improvement
priority: high
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 700
tech: null
---
The Impact area is currently two different boxes and a stray line, and which one you get depends on whether an entity is attached.

**Today** (verified against `origin/main` @ 75c57f6): `IncidentEntityPanel` (`IssueDetailPage.tsx:1667`) branches —

- **no entity** → `UnlinkedEntityPanel`, a **yellow** card titled "This incident names no estate entity", carrying the entity picker;
- **entity attached** → `AttachedEntityPanel`, which renders `<Stack gap="xs">` containing `ImpactPanel` (a plain bordered card titled "Impact") and then, **as a sibling below the card**, a `<Group>` holding *"Attached by …"* / *"Resolved automatically from the signal"* plus the change/clear controls (`IssueDetailPage.tsx:1703-1712`).

So the section changes title, colour and identity with its own contents, and its provenance line sits outside the box it describes.

**Wanted:** one box, one title ("Impact"), one colour, in every state. The picker, the subject, the provenance line and the change/clear controls all live inside it.

**Scope**
- Collapse `UnlinkedEntityPanel` / `AttachedEntityPanel` into a single component with one card. State changes the *contents*, never the title, the colour or the identity of the box.
- Move the "Attached by …" / "Resolved automatically from the signal" line **inside** the card, with the change and clear controls it belongs to.
- Adopt the section shell from ISE-699 (fixed title, top-right collapse, single-line collapsed state).
- Keep the yellow-card *message* where it earns its place. ISE-639's wording explains WHICH gap — "the signal names X, which matches nothing in the estate" versus "raised by hand, so there is no signal" — and that distinction is load-bearing (58 of 60 DataDog alerts were the second kind and read as the first). It becomes content within the one box, not a different box.

**The trap: "Impact (No data)" must not hide the picker.** An incident with no entity is exactly when the operator most needs the control, and ISE-699's rule would collapse that state to a single dead line. Either Impact's empty state is *not* "(No data)" but an actionable "No entity attached" that still offers the picker on expand, or Impact is exempt from auto-collapsing when empty. Decide explicitly — getting this wrong removes the only route to attaching an entity.

**Do not undo ISE-698 or ISE-696.** #647 fixed an un-removable row in this panel and a search that required you to already know the answer; #643 made the picker say *which* entity, not just its name. Both live in this code.

Depends on ISE-699 for the shell. Sibling: ISE-701.