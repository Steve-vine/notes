---
id: 01M7MJ5MTZ3HM6CVMTD2X9DX2T
created: 2026-11-17T10:52:16.095228Z
updated: 2026-11-17T12:16:33.292919Z
type: task
title: 'Round 3 leftovers: Polaris''s tool descriptions use the new IDs, and small wording on check screens'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1894
sprint: s7nqsy0
comments:
- id: 01M7MJFYN7E6RT40J9C94EKRHC
  author: Steve Vine
  at: 2026-11-17T10:57:53.831183Z
  text: |-
    Added from the second pre-UAT tester (coordinator). These are part of this task's Done when:
    - A lookup's words on a check's Details use the field's own words, not its raw name ("the choices of Change type in Change form fields, read every capture", not "the choices of Change_type"). A lookup read from the service says "read every capture", not "read from the service" (COM-1874).
    - A count in a workflow sentence agrees with its number ("has at least 1 owner", not "1 owners") (COM-1872).
    - Polaris's coverage suggestion doesn't end with ".." (COM-1880).
- id: 01M7MM0PHH45167S8J4DV04NHK
  author: Steve Vine
  at: 2026-11-17T11:24:31.15299Z
  text: |-
    Done — PR #1889, merged 8671a69c.
    - Polaris's tool descriptions, examples and messages now use today's IDs: DEC-n, RAS-n and CHC-14, no longer D-n, RA-n or CHK-14. A test fails if an old ID comes back in a tool, the instructions or Polaris's other text. An old ID is still allowed where the sentence says it is old ("an old CHK ID…", "G-7 as it was").
    - A gap a built-in check raises names the check by ID in its description too: "Raised by Compass check CHB-12: Secrets are rotated on time. …"
    - A custom check's page shows "Fields it keeps" once.
    - On a built-in check's card, a Viewer's only menu item reads "Open the check". Anyone who can run the check still sees "Open the check to edit".
    - Lookup words name an entry in words ("the choices of Change type in Change form fields"). A list read from the service says "read every capture" on the review card, in history and on the column menu. The evidence page says "read with this capture".
    - Workflow counts agree with their number ("has at least 1 owner"), and Polaris's coverage suggestion no longer ends "..".
    Assumption: text already saved keeps its words. That covers gaps already raised, lookup words saved with past captures, and history lines. Only new ones read the new way, and nothing was rewritten.
    To check on staging: CHB-12's existing gap keeps its old description, and a gap raised after the deploy names the check by ID. Run a failing built-in check on a control with no open gap from it to see one. A custom check's Details shows lookup entries in words straight away. The review card shows the new lookup words after the check's next capture.
- id: 01M7MPZZGC7WGABFX801PDQ5DF
  author: Steve Vine
  at: 2026-11-17T12:16:33.292132Z
  text: |-
    Pre-UAT on staging 00a2eb16 — Couldn't check (one point: the new lookup words need a fresh capture from a real service; everything else Passed)
    - Polaris's tool text uses today's IDs: I read Polaris's tool text and instructions as deployed in 00a2eb16. Old IDs (CHK-14, RA-n, D-n, WF-n, G-n) appear only where the sentence says they're old ("an old CHK ID still names the check it was", "G-7 as it was"). Examples now say CHC-14, CHB-3, DEC-n and RAS-n. The PR adds a test that fails if an old one comes back. Note: my own assistant session had loaded Polaris's tools before this deploy, so it still showed "CHK-14". That is a stale copy, not the server. Passed.
    - A new gap names its check by ID: as E2E Admin A in E2E Test Company, I assessed IDM.18 as Partial and pressed Run now on CHB-12 (failing, with no open gap). It raised GAP-152, whose description reads "Raised by Compass check CHB-12: Secrets are rotated on time. 1 secret is past its rotation date. …". The older GAP-147 (CHB-6, raised before the deploy) keeps its old words, as the PR says. Passed.
    - "Fields it keeps" once: CHC-2's card on ACC.13 ▸ Evidence ▸ ⋮ ▸ Change the fields it keeps shows "Fields it keeps 102 of 102 ticked" exactly once. CHC-2's own page offers no Change the fields while the check is broken (its integration was deleted), so I could only open the editor from the card. Passed.
    - A Viewer's only card-menu item reads "Open the check": as E2E Viewer, IDM.6 ▸ Evidence ▸ CHB-4 ⋮ shows only "Open the check", which opens CHB-4's page. As Admin A the same menu shows Run now, Switch off and "Open the check to edit". Passed.
    - A workflow count of 1 is singular: I had Polaris draft a workflow without saving it, with "at least 1 topics" and "at most 3 owners". Compass read it back as "If every item has at least 1 topic and at most 3 owners". Passed.
    - Polaris's coverage suggestion has no "..": on Evidence Collection ▸ Review ▸ CHC-1 (E2E), Polaris's words end with a full stop. The line reads "…are not connected. Coverage is the control's…", with one stop and no "..". Passed.
    - Lookup words in plain words: COULDN'T CHECK. No check in E2E has a lookup. In Test Company, read only: CHC-24's live Details lists its names as fixed lists ("change.change_type: Change types, a fixed list …"), so the new words don't apply there yet. Its change waiting on Review still says "the choices of Change_type in Change form fields, read from the service". That sample was taken before the deploy, and the PR says saved words stay as they were until the next capture. Steve: once CHC-24's waiting change gets a new sample, or is approved and captures, check that it reads "the choices of Change type in Change form fields, read every capture".
    Screenshots: ~/compass-uat/s7nqsy0/COM-1894/
assignee: steve
priority: low
task_status: review
---
From the pre-UAT pass of round 3 (staging 44d15b9a). These are small leftovers from COM-1886, COM-1888, COM-1890 and COM-1877/1879.

**Done when**
- Polaris's tool descriptions and examples use the new IDs. Its answers already do. Places found so far:
  - "Record a decision" still says "next number (D-n)": assistant/tools/decisions.py, around line 304.
  - The risk-assessment tools still say "RA-n": assistant/tools/risk_assessments.py lines 5, 104, 441, 527 and 550, and risk_assessments_ai.py lines 233, 262 and 264.
  - assistant/tools/posture_collection.py around line 471 still gives "CHK-14" as an example.
  - Do a full sweep for any other old prefix (R-, G-, D-, CR-, RA-, WF-, CHK-) in Polaris's tool text and MCP instructions, and a test that fails if one comes back.
- A gap raised by a built-in check names it by ID in the gap's description too, e.g. "Raised by Compass check CHB-12: Secrets are rotated on time." The heading already does.
- The custom-check fields editor shows "Fields it keeps" once, not twice (CHC-2).
- A Viewer's only card-menu item doesn't say "edit". It reads "Open the check".