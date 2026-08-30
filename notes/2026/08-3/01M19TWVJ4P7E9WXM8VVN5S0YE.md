---
id: 01M19TWVJ4P7E9WXM8VVN5S0YE
created: 2026-08-30T17:18:55.556982Z
updated: 2026-08-30T17:42:22.287219Z
type: task
title: Every toggle in the app has the same tight hit area, and the convention is written down
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 542
sprint: s2fcksg
blocked_by:
- 01M19TQ8W4JBKKK1N69HE454QT
assignee: steve
company: null
label:
- improvement
priority: low
task_status: todo
---
Follows COM-541, which fixes the "Applicable (in scope)" toggle on the Assessment panel. The same oversized hit area exists wherever a switch is laid out as a full-width row: the whole line is clickable, so a stray click in empty space changes a setting the person never aimed at. Sweep the rest and write the rule down so new screens inherit it.

**The rule** — a toggle is operated by its switch and its label text. The empty space beside it does nothing.

**Scope** — 37 `<Switch>` uses across 31 files. Roughly half already sit inside a `<Group>` and shrink to their content; those are correct and need no change. The ones to fix are those rendered as a block row — Domains, Domain detail, Controls, Frameworks, Gaps, Risks, Risk detail, Actions, Portal actions, Assessments queue, Activity, Notifications, Roles, Groups, Recert, Access graph, Report wizard, Report schedule, Extra fields, Integrations, Email, Companies, mail preferences, vendor form builder, vendor assessments, onboarding requests, question fields.

**Implementation**
- Constrain each offending switch root to its content (`w="fit-content"`), the same fix COM-541 applies. Check each site in the running UI rather than by grep alone — the container decides, and a `Group` ancestor already handles it.
- Check `Checkbox` and `Radio` label rows in the same pass; Mantine builds them the same way, so any laid out as a full-width block row have the identical problem. Fix where it's the same bug, don't redesign the screens.
- Add the rule to `brief/information-architecture.md` → *Screen conventions*, next to the pill/truncation guidance, so the next screen gets it for free. This is the durable half of the task — without it the sweep decays.
- Don't introduce a shared toggle wrapper for this; a one-property fix at each site plus the written convention is less churn than a new component every screen has to adopt.
