---
id: 01M81A3P9ZNH9RGYR8CHYF4TJK
created: 2026-11-22T09:41:31.071467Z
updated: 2026-11-23T14:59:15.239153Z
type: task
title: Provide a register to an audit request — as it stood on a chosen date (default the audit period's end), pinned like provided evidence, removed or withdrawn the same way
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2094
sprint: ssj8zkq
blocked_by:
- 01M81A2A2EEFTA9WNY3N38KG9B
comments:
- id: 01M846WH7CZJZG0B10GMSYMKP0
  author: Steve Vine
  at: 2026-11-23T12:42:54.060551Z
  text: |-
    Built and merged to main: PR #2095 (40d08cdee), with migration 0902_provided_registers.

    What people see:
    - On a request, Provide a register sits beside Add evidence. The person picks a register they can open, with those kept for the request's controls first, and a day. The day defaults to the end of the audit's period and can be any day up to today.
    - The request lists it as "Obligations (OBL), as at 31 Mar 2026, 48 entries". Opening it shows a read-only table as it stood then, with archived entries marked and fields removed since still shown.
    - If the register changes later, the request says "The register has changed since 31 Mar 2026" and offers Provide it again.
    - A Restricted register warns first that the audit's auditors will see it, and the server refuses it without that confirmation.
    - It can be taken off freely until the auditor opens it, then only withdrawn with a reason. Activity records all three.

    Decisions made while building, for Steve to check:
    1. A past day ends on the clock of the person providing it, as the register's own As at does. Today is the exact moment. Both are stored, so the date can't shift.
    2. A day before the register existed is refused, rather than showing an empty register as if it had been kept then.
    3. A provided register can't be deleted, even once withdrawn, because what the audit was given is read from it.
    4. People who can't open the register see only "A Restricted register" or "A register you can't open" on the request. A Restricted register's name also stays out of Activity and the request list's export.
    5. "Changed since" counts changes to entries only. A link or evidence added to an entry doesn't count, nor does an edit in another company's entries of a per-company register.
    6. The button reads Provide a register rather than a Provide menu, because the request has no such menu today.

    Important until COM-2095 lands: a request holding only a register can be marked Provided, but the auditor sees no evidence on it. This must not be released without COM-2095.

    Tested against real Postgres: provided as at period end, a past day and now; a later edit the same day changes nothing provided; removing before opening and withdrawing after (opening simulated, since the auditor's side is COM-2095); refusal of a register the person can't open; per-company entries; suggestions; date limits; the deletion guard; nothing reaching the auditor; the migration up and down on a populated table. CI and main build green.

    Not checked: an edit already in flight at the instant of providing (a fraction of a second) can count as before the moment. Not yet checked in a browser on staging: that comes with the sprint's pre-UAT pass.
- id: 01M84EP6N7YBG4F6J5WWPNYMN7
  author: Steve Vine
  at: 2026-11-23T14:59:15.23895Z
  text: |-
    Pre-UAT on staging e2248892e: PASSED on the company's side. The auditor's half of the last line COULDN'T be checked.

    Account: E2E Admin A, E2E Test Company. Audit AUD-5 "E2E UAT 122 Audit" (SOC 2 Type II, period ending 23 Nov), requests UAT-1 to UAT-4.

    - Provided as at the period end, a past day and now, each with the right entries and values: PASSED.
      - Period end: the day defaulted to 23 Nov, the audit's end. Listed as "E2E UAT 122 Obligations (UOB), as at 23 Nov 2026, 5 entries".
      - A past day: the shared register as at 23 Nov, "3 entries" (it has 4 now). A day before the register existed is refused: "This register was made on 23 Nov 2026. Choose that day or later."
      - Now: provided at 14:44. Opening it shows the entries as they stood, archived marked, and a since-removed field headed "Source (field removed)".
    - Editing afterwards doesn't change what's provided, and the request says so: PASSED. After I changed UOB-1, added and archived entries and removed a field, the provided view still shows UOB-1 as Met / 10. The request says "The register has changed since 23 Nov 2026" and offers Provide it again.
    - Before the auditor opens it, it can be removed: PASSED. Take off removed it from UAT-2. The request's History and the audit's Activity both record adding and taking off.
    - Afterwards only withdrawn with a reason: COULDN'T CHECK. No auditor can open it, because the Auditor portal is switched off on staging (see COM-2095).

    Also seen:
    - A Restricted register warns first: "The auditors of AUD-5 will see this register. Provide E2E UAT 122 Restricted?" with Provide it / Don't.
    - Registers kept for the request's controls are listed first, but that group includes archived registers, among them one marked Restricted · Archived. Steve may want those lower or hidden.

    Screenshots: ~/compass-uat/sprint-122/COM-2094/
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Registers - Phase 2" (ADR 0167 §6, in COM-2087). Builds on "An import that updates" in chain order. The auditor's side is the next task.

## What people see
- On an audit request, **Provide ▸ A register** sits beside providing evidence. Pick a register (only those the person can open), and a date it's shown as at:
  - default: the end of the audit's period (observation end, else planned end)
  - any day up to today. Today means the moment it's provided, so later edits today don't change it.
- Compass suggests registers kept for the request's controls first.
- A Restricted register shows the warning that the audit's auditors will see it.
- The request lists it like provided evidence: "Obligations (OBL), as at 31 Mar 2026, 48 entries", opening the internal as-at view.
- **Pinned**: what's provided doesn't change. If the register changed after that date, the request says "The register has changed since 31 Mar" and the owner may provide it again as at a later date.
- **Taking it off** (ADR 0133 §3): removed freely until the auditor opens it; after that, withdrawn with a reason and shown to the auditor as withdrawn.
- The audit's Activity records providing, removing and withdrawing it.
- Who: whoever can provide evidence to the audit, and can open the register.

## Implementation notes (technical)
- A new kind of provided item on a request: register id + as-at moment (timestamp; for a past date, end of that day in the company's time zone). Nothing copied; views render from revisions at that moment.
- "Changed since": any revision of the register's entries after the moment.
- Reuse the provided-evidence remove/withdraw/lock flags and the activity entries.

## Done when
- A register can be provided as at the period end, as at a past day and as at now; each shows the right entries and values.
- Editing an entry afterwards doesn't change what's provided, and the request says the register has changed.
- Before the auditor opens it, it can be removed; afterwards only withdrawn with a reason.

On the chain: migration + API.