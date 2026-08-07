---
id: 01KZDRN628KEFDC54PY17S94HK
created: 2026-08-07T09:25:21.096317Z
updated: 2026-08-07T20:14:48.137671Z
type: task
title: '"Ask Assist" contextual entry points — start a thread about this entity/system/incident'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 601
sprint: snk16ew
comments:
- id: 01KZEJ814N4XPSM1094Z5S2FKM
  author: Steve Vine
  at: 2026-08-07T16:52:33.045706Z
  text: |-
    Done — PR #526 (feature/ise-601-ask-assist-entry-points). Migration 0105.

    `assist_thread` gains subject_type + subject_id. Resolved at READ time every turn by a new `assist_subjects` module: preamble + label.

    Decisions worth keeping:
    - SUBJECT IS NOT A FOREIGN KEY, on purpose. A subject is where a conversation STARTED, not something it depends on — the entity can be retired and the incident reaped, and the transcript is still worth reading. An FK with a cascade would delete the conversation; one without would block the cleanup. When the subject has gone the preamble and label both return None and the thread behaves as a cold one. Tested explicitly.
    - THE PREAMBLE HANDS OVER THE ID, not just the name. Without it the agent's first move is a name search — the ISE-540 move that fails when the estate does not name things the way people do.
    - A retired entity says RETIRED (or the agent answers about something that no longer exists); a System carries its last_synced_at (feeds ISE-602's freshness hierarchy for free); an incident is told Assist is the READ-ONLY door and to leave acting to the incident's own surface.
    - DEPS SCOPING: System subject → system_id (Evidence defaults to it). Incident subject → issue_id (ranked signal search scopes to it). ENTITY subject → NEITHER, because an entity is not a system and guessing one would point live pulls at the wrong place. Neither widens anything — assist's tools come from the READ tier and nowhere else (ADR 0090). The test that asserts issue_id is set asserts the containment alongside it.
    - POST /threads 404s on a subject that does not exist. A silently-ignored subject would open a COLD thread that LOOKS bound — worst of both, because the operator then asks "is this production?" and the agent has no idea what "this" is.

    UI: "Ask Assist" on entity, System and incident detail. A <Link>, NOT a mutation — the URL IS the feature. /assist?entity=<id> can be pasted into a ticket or sent to on-call; a POST-then-navigate would give the same first screen, no shareable link, and an empty thread every time someone clicked and changed their mind. AssistPage consumes the param, opens the bound thread, then DROPS the param so a reload or the back button doesn't open a second conversation about the same thing. Header shows an "About <subject>" chip linking back — an operator returning a week later cannot otherwise tell a bound thread from a cold one.

    One query param per subject type (?entity=/?system=/?issue=) rather than type=/id= — these links get written by hand, so reading one shouldn't require knowing the schema.

    Tests: 12 backend + 4 frontend. Backend 735 unit + 21 assist integration, ruff, mypy strict green; frontend 672/672, tsc, eslint, prettier green.

    NOTE for the staging merge: this and ISE-604 both touch AssistPage.tsx — expect a conflict, and run `npm run build` after resolving it (nav.ts lesson: only the build catches a bad conflict resolution).
assignee: steve
label: null
priority: medium
task_status: done
---
Assist always starts cold: `AssistStore.system_id`/`issue_id`/`context` all return `None`, and no screen links into it. "What about *this* thing" should not require re-describing the thing.

- "Ask Assist" action on entity detail, system detail, and incident screens → opens `/assist` with a new thread bound to that subject.
- Thread carries the subject as context: the store's existing hooks get populated so the first turn's preamble includes the subject's investigation context (mirror issue-chat's preamble mechanism); subject shown as a chip on the thread header.
- Deep-linkable: `/assist?entity=…` (or equivalent) so links can be shared/bookmarked.
- Subject-bound threads remain read-only Assist threads — context changes what the agent sees first, never what it can do.

Screens: entity/system/incident pages gain the action; AssistPage renders the subject chip.