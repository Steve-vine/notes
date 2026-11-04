---
id: 01M6H94K1QENF6X3X15WDPWBQX
created: 2026-11-03T18:00:59.191464Z
updated: 2026-11-04T07:46:09.270809Z
type: task
title: An advisory with no severity of its own is dropped by a watch list's minimum severity — Fortinet's and the NCSC's alerts about the critical PHP flaw were missed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1549
sprint: s6xh9g1
comments:
- id: 01M6HDP2XZ71VFFYYHGJN08PRV
  author: Steve Vine
  at: 2026-11-03T19:20:26.815353Z
  text: |-
    Done (PR #1560, merged 2026-11-03). Not on staging yet.

    What people see now: an advisory or alert that states no severity of its own takes the worst severity of the CVEs it covers, and their known-exploited mark. The NCSC's "Critical security issue affecting PHP" and Fortinet's FG-IR-26-186 now read Critical and known exploited, and match your "PHP" list (Medium minimum). If the CVE is only scored later, the advisory follows it. An item with no severity anywhere — nothing of its own and no CVE to borrow from — is no longer dropped as "too mild": it matches and shows "Severity not stated" (feed list, item page, watch list preview; the watch list form now says items without a severity are always included). A Low item like CVE-2026-6103 is still left out.

    Existing items are worked out again once, quietly, by the worker within ~10 minutes of the deploy, and every company with a watch list is then matched again. Expect some new matches (and actions for exploited/Critical ones), since unscored items now pass a minimum severity.

    Also seen in the task: CISA's VA-26-295-01 names "php-src" — that's fixed in COM-1547.

    Verified: integration test covering the borrowed severity and exploitation, following a later score, and a Medium-minimum list catching unscored items but not a Low one; screen test for "Severity not stated".
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found by Steve testing sprint 102 on staging (2026-11-03), in Test Company.

## What people see

Steve's watch list "PHP" (product PHP, any version, minimum severity Medium, known-exploited always included) matches 30 items. Two advisories about the critical PHP flaw CVE-2026-109618 aren't among them, although both name PHP:

- Fortinet FG-IR-26-186 (21 Oct)
- NCSC "Critical security issue affecting PHP" (21 Oct)

Expected: both match. An alert about a critical flaw shouldn't be filtered out as "too mild".

**Cause (technical):** both items have **no severity** (`severity` null). Polaris read their products from prose, and neither source states a score. `matching.passes` treats a missing severity as rank −1, so any list with a minimum severity drops the item. Neither is in CISA's known exploited list under its own key, so the KEV exemption doesn't apply. The CVE they cover *is* critical and known exploited.

## Fix

- An advisory without its own severity takes the highest severity (and known-exploited) of the CVEs it covers. NCSC's and Fortinet's would then be Critical / exploited.
- An item with no severity at all, and no linked CVE to borrow from, passes a minimum severity and shows as "Severity not stated". It isn't silently dropped.
- Rematch companies once on deploy.

**Done when:** in Test Company, FG-IR-26-186 and the NCSC PHP alert match the "PHP" list and show Critical; an item with no severity anywhere still matches a Medium-minimum list, marked "Severity not stated"; and a Low CVE (e.g. CVE-2026-6103) is still left out.

Also seen: CISA's VA-26-295-01 names the product "php-src", not "PHP", so it misses too. Added to COM-1547.