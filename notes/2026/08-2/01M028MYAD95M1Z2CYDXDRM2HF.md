---
id: 01M028MYAD95M1Z2CYDXDRM2HF
created: 2026-08-15T08:29:39.021029Z
updated: 2026-08-15T17:17:40.962585Z
type: task
title: Flag an incident for review — a tester's channel back to the person who owns ISE
project: 01KX671DATY39VW6GWK3M2T3DN
number: 731
sprint: sevhjex
comments:
- id: 01M028YDXT3TWC2075CG5PN4RM
  author: Steve Vine
  at: 2026-08-15T08:34:49.914808Z
  text: |-
    CORRECTION 2026-08-15 — placement. Not a Settings tab: a NEW TOP-LEVEL ITEM in the System nav section.

    So it lands in `components/nav.ts` under the section titled `System` (nav.ts:165), alongside its existing items — System status, Agent runs, Platform log, Audit, Settings — with its own path (`/flagged-for-review` or similar) and its own icon. It is a page in its own right, not a panel inside `SettingsPage.tsx`.

    That disposes of the placement caveat in the body below: there is no "if it becomes something looked at daily it should be promoted out of Settings later" — it starts where it belongs. It also puts it next to the other things that are about ISE itself rather than about the estate, which is exactly what a review flag is: feedback on the product, not a fact about the infrastructure. Same reasoning as keeping it off the incident timeline.

    Two consequences worth carrying into the build:
    - nav.ts is the one file where a bad merge resolution can cut straight through an object literal and still look plausible; only `npm run build` catches it. See [[ise-nav-conflict-cuts-through-object-literals]].
    - The System section carries no role gate of its own, so the item needs its own `requiresRole` — operator-and-above to read the list and close entries, while ANY signed-in user can still raise a flag from the incident. The two permissions are deliberately different.
- id: 01M02YZJ6078SKN8WHX7XNMH6W
  author: Steve Vine
  at: 2026-08-15T14:59:55.712183Z
  text: |-
    Done — PR #682, merged to main 2026-08-15. Built to your correction: a top-level item in the System nav section, not a Settings tab.

    **The flow as specified.** A muted "Flag for review" link at the bottom of the incident, below the conversation and out of the way of the working controls; a modal with a free-text box; the comment stored against the incident and NOT on the timeline; a **Flagged for review** page listing incident number (linking through), comment, who, when — newest first — with a close button.

    **The two permissions are genuinely different, and the tests prove it.** Any signed-in user can raise a flag; reading the list and closing entries is operator-and-above. A suite that logged in as an operator throughout would never notice if those quietly converged, so each test logs in as each role in turn — and one asserts a viewer gets a 403 from the list immediately after successfully flagging.

    **Off the timeline, but audited.** The audit row still names the **issue** — that is the right subject for "who flagged what" — so the exclusion is a filter at the read (`_OFF_TIMELINE_ACTIONS`) rather than auditing it against something else. A test asserts both halves at once: the audit row exists with the right actor and comment, and the action does not appear in the timeline.

    **On "worth confirming that is the intent rather than an archive" — yes, hard delete.** It shapes the whole design: the list is unpaged and shows the whole comment, because it only ever holds OPEN feedback and is bounded by what is waiting rather than by history. An archive would have made both of those wrong. Nothing references a flag, so nothing can break, and the audit row is where "who raised it, who cleared it" survives permanently.

    **No deduplication**, per your model note — no unique constraint at all. Worth recording the contrast: its neighbour `issue_affected_entity` HAS one, because there the pair *is* the claim and saying it twice adds nothing; here the second voice is new information.

    **The marker** shows `Flagged for review ×2` on the incident detail — detail read only, never the queue, where a feedback marker would compete with the incident's own state.

    Migration 0139. Nav entry with its own `requiresRole: 'operator'`, since the System section carries no gate of its own — and `npm run build` is green, which per your note is the only thing that catches a bad nav.ts edit.
assignee: steve
label:
- feature
priority: high
task_status: done
tech: null
---
Other people are about to start testing ISE. They need a way to say "this incident did not go as planned" at the moment they notice, and Steve needs a list of those to work through later. Requested 2026-08-15.

**The flow**
- A **Flag for review** button at the bottom of the incident.
- It opens a modal with a free-text comment box.
- The comment is stored against the incident number, **not** on the timeline.
- A new **Flagged for review** section under Settings lists: incident number (linking to the incident), the comment, and a close button that removes it from the list.

**Deliberately off the timeline.** A tester's "this looked wrong" is feedback about ISE, not a fact about the infrastructure. Putting it on the timeline would mix the two, and the timeline is the record an operator reads to understand the incident. Keep it separate. It should still be **audited** — who flagged what and when — because it is a user action, just not one that belongs in the incident's own narrative.

**Model.** A small table: issue id, comment, flagged_by, created_at. Several flags per incident should be allowed — two testers hitting the same problem is a stronger signal than one, and deduplicating would hide it.

**Scope**
- Any signed-in user can flag; testers will not be operators. Reading the Settings list and closing an entry should be operator-and-above.
- The button goes at the bottom of the incident page, out of the way of the working controls — it is not part of triage.
- The list needs enough to triage from without opening each one: incident number, comment, who flagged it, when. Sort newest first.
- **Show on the incident that it has been flagged.** Without it a tester who flags something has no confirmation it landed and may flag repeatedly, and an operator working the incident has no idea someone raised a concern about it. A quiet marker is enough; it must not look like an incident state.
- Close = removed from the list. A hard delete is defensible here — unlike a playbook (ISE-724) or a merge dismissal, this is ephemeral triage with nothing referencing it. Worth confirming that is the intent rather than an archive, since it is the one place in ISE where destroy is the natural verb.

**Placement.** Settings is where it was asked for and is fine to start. Note Settings is being deliberately slimmed — Groups was promoted out of it by ISE-678 — so if the list becomes something looked at daily it belongs in the left nav in its own right rather than behind a Settings tab. Not a reason to delay; a reason not to be surprised later.

Follows the CLAUDE.md rule that a new user-facing surface gets a nav entry: this is a Settings tab alongside Integrations / AI / Detection / Users, so `SettingsPage.tsx`'s tab list is the place, not `nav.ts`.