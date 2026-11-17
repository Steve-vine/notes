---
id: 01M7NPPTXZJT7HJVZ06M7AFM8F
created: 2026-11-17T21:30:48.127107Z
updated: 2026-11-17T21:51:08.486265Z
type: task
title: The dependency scan lets one known advisory through by its ID, with a reason and a date to look again
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1902
sprint: s7nqsy0
comments:
- id: 01M7NQW10FXV3GFSPT1WZEBENA
  author: Steve Vine
  at: 2026-11-17T21:51:06.767617Z
  text: |-
    Done — PR #1893, merged e7b4c4d3.
    The frontend dependency scan now reads an allow-list (app/frontend/audit-allowlist.json): each entry is an advisory's ID, the reason it's accepted, and a date to look at it again.
    GHSA-fc5q-39xc-vjpf (picomatch) is allowed until 17 Dec 2026. Any other high or critical advisory still fails the scan, as before.
    After its date, an entry fails the scan until someone looks again. If npm stops reporting an advisory on the list (once picomatch is fixed), the scan prints a note to remove it.
    Tested against today's real audit report, an empty list, an expired date, a registry error and a clean report.
    To check: nothing on staging; this is CI only. On 17 Dec, check whether picomatch has a fixed release.
assignee: steve
label:
- chore
priority: high
task_status: review
---
Steve, 2026-11-17: since about 21:00 GMT the dependency scan fails every PR on GHSA-fc5q-39xc-vjpf (picomatch ReDoS, high). No version of picomatch has a fix; it reaches Compass only through @parcel/watcher, an optional file-watcher of sass under Excalidraw, which is build tooling and not in what the browser loads. Steve chose to allow this one advisory by its ID, not to skip optional packages.

**What changes**
- The frontend dependency scan reads a short list of allowed advisories, each with its ID, a reason, and a date to look at it again.
- Any other high or critical advisory still fails the scan, as today.
- An allowed advisory past its look-again date fails the scan, saying what to do. An allowed advisory that no longer appears is reported, so it can be removed.

**Done when**
- PRs merge again with GHSA-fc5q-39xc-vjpf present, and a different high advisory would still fail.

Independent (CI only).