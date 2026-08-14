---
id: 01KZZQETKT0MFPCHTDK1TGKKFV
created: 2026-08-14T08:50:43.962856Z
updated: 2026-08-14T12:53:15.946541Z
type: task
title: Impact is one box in every state — picker, subject and provenance inside it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 700
sprint: sevhjex
comments:
- id: 01KZZR6DGTM7875QS2KK67QREF
  author: Steve Vine
  at: 2026-08-14T09:03:36.986717Z
  text: |-
    DECIDED 2026-08-14.

    COLOUR — Impact is YELLOW, fixed in every state. It currently shows yellow only when unlinked and a plain bordered Card once an entity is attached; the yellow becomes the section's permanent identity rather than a signal that something is missing. Note LearningPanel holds yellow today and must move (allocation is owned by ISE-699).

    THE PICKER — agreed: Impact's empty state stays actionable. It is never a dead one-line "(No data)". Under ISE-699's always-show rule the box is on screen with no entity attached, and the picker must remain reachable from that state — collapsing it to a line that cannot be acted on would remove the only route to attaching an entity, which is the one thing the operator is there to do.
- id: 01KZZV4NSXP23NHN7R4WYAEV43
  author: Steve Vine
  at: 2026-08-14T09:55:05.660969Z
  text: |-
    BUILT + MERGED 2026-08-14 — PR #649 (squashed to main as 531362f), CI green.

    ONE BOX, in every state. `UnlinkedEntityPanel` and `AttachedEntityPanel` are gone; `IncidentEntityPanel` is a single `IncidentSection` — title "Impact", colour yellow, fixed — and the state decides only what is inside it.

    - The "Attached by …" / "Resolved automatically from the signal" line and the Change/Clear controls are now INSIDE the card. They used to render as siblings BELOW it, so the provenance sat outside the box it described.
    - The subject moved into the section header beside the title it qualifies. Collapsed, Impact reads "Impact · mpwxdatawh (host) · 3 affected", or "no known dependents" — the entity, not a bare count.
    - `useEntityImpact` is exported from ImpactPanel so the header and the body render from ONE fetch. Same query key, so React Query serves both from a single request.
    - `ImpactPanel bare` renders the answer with no card, title or collapse of its own — the section owns all three. A card inside a card was the shape being removed. The entity page's what-if view is untouched.

    THE PICKER TRAP — resolved your way, and stated in code. Impact is NEVER `empty` in the shell's sense, in either state, so it never collapses to a dead "(No data)" line. With no entity attached its collapsed line reads "No entity attached" and expanding gives the explanation plus the picker. The comment in `IncidentSection.tsx` says a section whose empty state can be ACTED on is not empty, so the next section built doesn't rediscover this.

    PRESERVED, deliberately: ISE-639's WHICH-gap wording (manual / unnamed / unresolved, verbatim), ISE-698's de-duplicated rows, per-row Remove spinner and relevance-sorted search, ISE-696's disambiguated picker labels. One improvement on the way past: an incident with no recorded `entity_link_reason` at all used to fall through to `unnamed`'s sentence, which asserts a signal that may not exist — it now gets an honest generic line.

    TESTS assert CONTAINMENT, not presence (`within(getByTestId('section-impact'))`). The provenance line and the controls existed before and after; what changed is where they sit, so a presence test passes against the old layout — the same trap ISE-693 called out.

    One incidental fix: `src/test/setup.ts` now clears localStorage between tests. jsdom keeps one store per test file, so the section-collapse persistence meant a test that collapsed a section left it collapsed for every test after it, which read as "the panel stopped rendering its rows".
assignee: steve
label:
- improvement
priority: high
task_status: done
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