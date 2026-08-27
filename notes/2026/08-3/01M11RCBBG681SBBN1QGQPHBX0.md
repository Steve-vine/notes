---
id: 01M11RCBBG681SBBN1QGQPHBX0
created: 2026-08-27T14:01:02.064925Z
updated: 2026-08-27T17:44:19.824171Z
type: task
title: Two controls can close a requirement between them, and someone can say so
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 461
sprint: s8cjs5n
comments:
- id: 01M1254ZZW3JVC8T13QR9Z40WD
  author: Steve Vine
  at: 2026-08-27T17:44:12.54008Z
  text: |-
    PR #451 opened — https://github.com/Steve-vine/compass/pull/451

    - The declaration is offered on the crosswalk alongside the controls carrying the requirement, and only where no single mapping is already equal or superset_of — those discharge it on their own and leave nothing to judge.
    - A declared requirement shows "Closed by the set" with the name of whoever declared it and the date, and a Withdraw button that returns it to partly covered and clears both.
    - A mapping can be re-graded in place — relationship, strength and note, opened on what the mapping already says.
    - A refused declaration renders the server's message rather than failing silently. The endpoint already returned a readable one.
    - Mapped control chips now carry their relationship, so the coverage answer reads off the row and the mapping worth correcting is identifiable.

    The one API change: `coverage_complete_by_name` on FrameworkRequirementOut. `coverage_complete_at` was already exposed; `coverage_complete_by` held a uuid, and a uuid is not an answer to "who decided two controls were enough here". Loaded via a selectin relationship, so a 325-row framework costs one extra query rather than one per declared requirement, and null where the account has since been deleted — the SET NULL foreign key already allowed for that.

    Everything gated on library write. Tests: backend covers the actor and date on declare, both cleared on withdraw, the name surviving a re-read, and the refusal message. Six new frontend tests cover the offer, the suppression where one control already discharges it, the signature and withdrawal, the refusal message, the in-place re-grade preserving the note, and a viewer seeing the state but none of the affordances.
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: review
---
A requirement reads partly covered when no single Core control satisfies it. Often
that is the right answer. It is also the answer given to the case where two
controls genuinely close it between them — and there is no way in the app to say
so.

The worked example: a requirement asks for antivirus **and** a firewall on every
workstation. One control covers antivirus, one covers the firewall. Neither is
"same as" or "does that and more", so both are honestly recorded as parts, and
the requirement sits at partly covered for ever. The only lever reachable from
the screen is to overstate one of the two controls — the app teaching people to
fudge, which is the exact failure COM-429 was built to stop.

The declaration already exists in the model. `PUT
/mappings/requirements/{id}/coverage-complete` records it with an actor and a
date, refuses it on a requirement with nothing mapped, and `derive_cover` already
honours it. The seed data uses it 85 times in ISO 27001 and 77 in SOC 2. There is
no button anywhere in the app that sets it.

The same is true of correcting a mapping. `PATCH /mappings/{id}` exists; the
crosswalk offers only add and remove. Fixing a relationship that was recorded too
modestly means unmapping and re-mapping from memory, losing the note that
explained it.

## What changes for the reader

**A partly-covered requirement can be declared closed.** On the requirement,
alongside the controls carrying it: *these controls close this requirement
between them*. Cover becomes fully covered and says which kind it is — closed by
the set, not by a single control.

**It reads as a decision, because it is one.** No arithmetic over strengths can
tell you that two partial controls leave no gap; a person decides that. The
declaration carries their name and the date, and an auditor asking "who decided
two controls were enough here" gets an answer. It can be withdrawn, which returns
the requirement to partly covered.

**A mapping can be corrected in place.** Change relationship and strength without
losing the note. This is what makes the other route — a mapping recorded too
modestly — reachable at all.

**Declaring it with nothing mapped is refused with a readable reason**, not a raw
422. "Complete" is a statement about a set, and the empty set closes nothing.

## Implementation

- Frontend, plus possibly one field. Both endpoints exist in
  `api/v1/mappings.py`, `derive_cover` already honours the flag, and
  `FrameworkRequirementOut` already carries `coverage_complete`. Check whether
  `coverage_complete_at` and `coverage_complete_by` reach the read schema — the
  signature is the whole point of the feature, and if they do not, exposing them
  is the one API change.
- Gate on library write, like every other crosswalk affordance.
- Withdrawing clears the actor and date (the endpoint already does this). A name
  left standing against a withdrawn declaration would be worse than no name.
- Immediate audience: five partly-covered requirements in PCI and 58 in ISO
  42001. The 42001 ones resolve when the AI Governance controls land (COM-431);
  PCI's need exactly the judgement this task makes possible. PCI 11.4.5 is the
  clearest case — segmentation design plus internal penetration testing do close
  it between them.

Tests: declaring on a requirement with two `subset_of` mappings flips cover to
fully covered; withdrawing returns it to partly; the actor and date render;
declaring with nothing mapped is refused with a readable message; editing a
relationship in place preserves the note.
