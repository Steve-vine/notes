---
id: 01M4EDVNHF9HDF1D20RGKHR29N
created: 2026-10-08T18:54:22.767555Z
updated: 2026-10-08T18:54:26.291897Z
type: task
title: 'ADR: a framework can have levels and a company picks the one it is working towards — and a licensed framework ships as a skeleton'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 875
sprint: sfkkkex
assignee: steve
label:
- brief
priority: high
task_status: backlog
---
Part of sprint 66, HITRUST Framework. Scoped with Steve 2026-10-08. This record gates the rest of the sprint.

## What it settles

- **HITRUST CSF is one entry in the Frameworks list, with three levels:** e1, i1 and r2. Each level includes everything in the one below it.
- **Each control carries the lowest level that asks for it.**
- **A company picks the level it is working towards.** Its coverage, gaps and dashboard figure are measured against that level. Until someone picks, it is the highest level, i.e. everything.
- **A level is not a scope decision.** Controls above the chosen level stay visible but are not counted, either as gaps or as excluded. "This does not apply to us" is still said one way only: out of scope, with a reason.
- **r2 is everything, minus what the company rules out.** All controls are loaded. A company removes the ones that do not apply using what Compass already has: out of scope for that company with a reason, or disabled in the library for everyone.
- **Compass ships HITRUST's skeleton only:** the 14 categories, 49 objectives and 156 controls by reference and name, plus the names of the 19 domains. None of HITRUST's requirement statements or implementation text ships.
- **Readiness is therefore at control level.** Compass says "something covers *User Registration*", not "each thing the assessor checks under it is met".
- **Level and domain are Compass's reading.** Both are properties of HITRUST's licensed requirement statements, so each control's level and domain are assigned from public material, labelled as such on the page, and correctable by anyone who can edit the library.
- **Readiness is reported per domain.** Compass does not imitate HITRUST's own scoring (domain thresholds, or the policy / procedure / implemented / measured / managed scale).
- **CIS is unchanged.** Its Implementation Group stays a label and gets no picker (Steve, 2026-10-08).

## Notes (technical)

- **Write `decisions/0087-*.md`.** Amends ADR 0010 and 0028 (what ships for a licensed framework), ADR 0057 (a level is not applicability) and ADR 0058 (a level sits inside a version). Cites ADR 0071: releases publish public images, which is why licensed text cannot ship.
- **Why a level is not applicability.** A level is a property of the target, takes no justification, and moves many rows in one action. An exclusion is a claim someone made and must be challengeable (ADR 0057 §4). Folding them together would fill the "excluded" count with rows nobody ruled on.
- **Why the default is the highest level.** Same reasoning as ADR 0057 §2: assumed in scope fails visibly, assumed out of scope fails silently.
- **Storage to record:**
  - a generic `level` (small integer, cumulative) on `framework_requirements`;
  - the ordered level labels on `frameworks`;
  - `target_level` on `company_frameworks` (null = highest).
- **`implementation_group` stays where it is.** Say explicitly that folding CIS into the generic level is the path for when CIS gets a picker, so the two columns are not read as an accident.
- **Domain is `part`** (COM-420). HITRUST is the third caller, with nineteen parts in place of two.
- **The path to the full requirement set.** If licensed statements are loaded later, they become children of a control in the requirement tree (COM-421), and level and domain move down to them. Record the path; build nothing.
- **Licence.** State what was read: the HITRUST CSF License Agreement (effective 2025-04-14). Control reference names are widely reproduced in public (Microsoft, assessor guides); statements are not shipped. If reading the agreement suggests that even the skeleton is a problem, stop and raise it with Steve before the library task starts.
- **Non-goal, stated:** no HITRUST scoring. A predicted score would be a number Compass cannot stand behind.

**Done when:** ADR 0087 is merged.