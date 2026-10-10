---
id: 01M4EDYAT00SEPG5WBAMY9Y0M0
created: 2026-10-08T18:55:50.080418Z
updated: 2026-10-10T19:06:24.757845Z
type: task
title: Several requirements can be ruled out of scope at once, with one reason — on any framework
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 880
sprint: sfkkkex
comments:
- id: 01M4KKB1J7DY042NWH4CSCQNSA
  author: Steve Vine
  at: 2026-10-10T19:06:21.639794Z
  text: |-
    Merged to main as PR #904 (2026-10-10). Goes to staging with the rest of the sprint. Works on every framework, not only HITRUST.

    What is there
    - A framework's requirement list (the Coverage tab) has tick boxes.
    - Ticking a heading ticks everything beneath it. A heading with only some of its requirements ticked shows as half-ticked.
    - While anything is ticked, a bar shows how many are selected, with Rule out of scope, Bring back into scope and Clear.
    - Rule out of scope opens the same dialog as for one requirement and asks for one reason. It applies to the ticked requirements still in scope; ones already out are left alone.
    - Bring back into scope does the reverse for ticked requirements that are out of scope, and clears their reason.
    - Each ruling is its own record: one audit entry per requirement, the reason written on each, and each reversible on its own afterwards.
    - All or nothing. If one requirement cannot take the ruling, none are changed, and the message names it and says why.
    - Headings cannot be ruled on. A superseded version shows no tick boxes, and neither does anyone who cannot rule on a single requirement.
    - Ruling on one requirement is unchanged.

    Decisions I took
    - A domain heading (when the list is grouped by domain) has a tick box too, for everything under it.
    - Only what is on the page counts as selected. Narrowing the list to one domain does not rule on the requirements it hides.
    - At most 500 requirements in one ruling.

    Technical
    - PUT /api/v1/requirement-applicability (the collection): requirement_ids, applicable, one justification. One transaction. The single route's checks are shared, not copied.
    - All requirements must belong to one framework; an id named twice is ruled on once.
    - No audit code: the table is already in the audit set and the listener is per row. Asserted in the test.
    - Not a portal route, so the portal write-routes allowlist is untouched.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Part of sprint 66, HITRUST Framework. Tailoring HITRUST r2 to a company means going through 156 controls and ruling out the ones that do not apply. Today that is one control, one dialog, one typed reason at a time. This works on every framework, not only HITRUST, and does not depend on the other sprint tasks.

## What people see

- **A framework's requirement list gains tick boxes.**
- **Ticking a heading ticks everything beneath it,** for example the whole of HITRUST's Privacy Practices category.
- **With rows ticked, "Rule out of scope" asks for one reason** and applies it to each ticked requirement. The reason is required, as it is today.
- **"Bring back into scope" works the same way** on ticked requirements that are out of scope.
- **Each ruling is still its own record.** The audit trail shows one entry per requirement, each with the reason, and any one of them can be reversed on its own afterwards.
- **It is all or nothing.** If one ticked requirement cannot take the ruling, none are changed and the message says which one and why.
- **Headings themselves cannot be ruled on,** only what sits beneath them.
- **A superseded version of a framework shows no tick boxes.**
- **The same people who can rule one requirement out of scope can rule several.**
- **Ruling a single requirement out of scope is unchanged.**

## Notes (technical)

- **Endpoint.** A bulk companion to the single `PUT` in `api/v1/requirement_applicability.py`: a list of requirement ids, `applicable`, and one `justification`. ADR 0057 §3 and §6 anticipated it.
  - One transaction.
  - Reuse the single route's checks unchanged: not a grouping node, the framework version is assessable, a non-empty justification when `applicable` is false, and the justification cleared when a requirement comes back into scope.
  - All requirements must belong to one framework. Cap the list (500 is ample).
- **Audit.** The table is already in the ADR 0023 audit set, so each row is recorded with no endpoint code. Assert it in the test all the same.
- **Page.** Tick boxes in `FrameworkDetailPage.tsx`'s requirement list and a small action bar that appears while anything is ticked.
  - Every `Checkbox` needs `w="fit-content"` and an accessible name (the screen-conventions test).
  - The existing single "Rule out of scope" modal is reused for the reason.
- **Not a portal route,** so the portal write-routes allowlist is unaffected.
- **Tests.** Integration: a mixed batch applies; a batch containing a grouping node changes nothing; a superseded framework is refused; an audit row per requirement. Page: tick a heading, rule out, the excluded count and the out-of-scope section update.
- Regenerate `schema.d.ts`.

**Done when:** on staging, ticking a heading on a framework and ruling it out of scope with one reason moves every requirement beneath it to the out-of-scope section, the headline shows them as excluded, and the audit trail has an entry for each.