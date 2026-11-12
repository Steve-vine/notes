---
id: 01M782CQMKP3MJEXFFXG1XPNK2
created: 2026-11-12T14:25:37.939858Z
updated: 2026-11-12T20:45:30.424384Z
type: task
title: A technology asset that can't be deleted says why, and a decommissioned one can still have its links removed and then be deleted
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1758
sprint: spsp226
comments:
- id: 01M7863MFKZZ9ETC5NXZDX5DGX
  author: Steve Vine
  at: 2026-11-12T15:30:34.098886Z
  text: |-
    Built — PR #1756 (auto-merge set), commit 19fb9c75. On the chain (API change); no migration — reasons, moves and duplicates are recorded in the activity log. ADR 0072 amended.

    What you'll see (technology, data and software assets alike):
    - Delete always shows for anyone who can edit the asset, live or decommissioned. When something's in the way it's disabled, and the hover gives the reason, e.g. "In use: depends on AST-2 MPATLHVHOST2, 1 linked risk — remove them first".
    - Under it, an "In the way" list groups each item (Depends on, Depended on by, Data assets it holds, Held in, Shared with, Installed on, Access, Risks, Decisions, Incidents, Risk assessments), each linking to where it can be removed, with a Remove button where it can come off the asset itself. Removing the last one turns Delete on. The page now asks Compass rather than guessing, so access, risks, decisions, incidents and risk assessments count too.
    - A decommissioned asset keeps its record as it was (Edit stays hidden, and Compass now refuses edits too), but its links can still be removed, each with a short reason recorded in the activity log. Then Delete becomes available.
    - Duplicates: the delete dialog has "It's a duplicate of …", and a blocked asset shows "Delete as a duplicate…". Before anything changes, the dialog lists each link as moving, dropped (the other asset has it already, or it would point at itself) or unable to move. Confirming moves the links and deletes in one go; both assets' activity logs show it.
    - Risk assessments and incidents never move or come off from here: an asset a risk assessment names stays undeletable and says so.
    - Polaris matches: delete takes "duplicate of"; on a decommissioned asset its tools only remove links, with a reason; refusals name what's in the way.

    Choices:
    - On a decommissioned asset the Risks and Access cards are read-only — clearing up happens from the Lifecycle card, so a reason is always asked for.
    - Up to three items are named in the reason; more are counted.
    - Software typed in can be removed; software found by discovery can't — it goes when discovery stops seeing it.
    - Removing a decision link needs Record decisions; removing access needs Manage access.
    - A decommissioned asset can't be picked as the one a duplicate merges into.
    - The refusal no longer says "decommission it instead".

    Checks: ruff, mypy, unit suite (2192 passed), integration suites for assets, links, risk assessments, incidents, access, portal and Polaris tools incl. 7 new deletion tests — all passed; eslint, tsc, prettier clean; full vitest suite passed; schema.d.ts regenerated. Checked the asset page in headless Chromium (light and dark, live and decommissioned, both dialogs), console clean. The real end-to-end check is on staging.
- id: 01M78APKP9ZK9EW1ZQP88BBQPQ
  author: Steve Vine
  at: 2026-11-12T16:50:50.185568Z
  text: |-
    Pre-UAT on staging (3175d2ad), 2026-11-12 — **Passed** on behaviour; one defect (console errors after a delete) being fixed forward.
    Live AST-43 depending on AST-42: Delete shown disabled, hover "In use: depends on AST-42 E2E pre-UAT 1758 host — remove them first"; "In the way" lists it with a link and Remove; removed (no reason asked, live), then deleted. Decommissioned AST-44: Edit and status actions gone, Delete and "Delete as a duplicate…" stay (disabled, same reason); Remove asks for a required reason, logged as "removed the dependency on AST-42 … (decommissioned) — <reason>"; then deleted. Duplicate AST-45 (dependency + risk R-76): dialog lists "Moves to AST-46: Depends on AST-42…; Risks: R-76…", "Move 2 links and delete"; AST-46 now has both; both activity logs show it. DAT-11 named by DPIA RA-3: Delete disabled, "risk assessments are never deleted, so neither is what they name", no duplicate option. Data asset DAT-12 and software SFT-25 followed the same rules. Dark checked.
    Defect: every delete (technology, data, software) leaves 3–5 404s in the console — the page asks again for the deleted asset. Logged as a new task and being fixed forward.
    For Steve: on a decommissioned asset, "Link a runbook" and the Decisions add/link are still live, while Risks and Access are read-only. Tell me if a decommissioned asset should take no new links at all.
    Screenshots ~/compass-uat/spsp226/COM-1758/.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Steve, in production (2026-11-12): he wanted to delete AST-152 "222Slave-newSlave", a duplicate.

**What happened:**
- There was no Delete button. The only reason was a dependency on its host, AST-2 MPATLHVHOST2. The page hides Delete whenever the asset is linked to anything, and says nothing about why.
- Steve decommissioned it, expecting to delete it after. Decommissioned is final: the page then hides Edit and every status action. That left no way to remove the dependency, and so no way to delete it.
- I removed the dependency and deleted AST-152 for him through Polaris (the activity log shows both as Steve via Polaris).

**What it should do:**
1. **Delete is always shown to someone who can edit the asset**, live or decommissioned. When something stops it, it's disabled, and its hover text (and the confirm dialog, if opened) says exactly what's in the way, in the words the API already uses:
   - "In use: depends on AST-2 MPATLHVHOST2, 1 linked risk — remove them first";
   - each item is a link to where it can be removed.
   - The page's check and the API's agree. Today the page checks only dependencies and data assets, while the API also refuses for access holders, linked risks, decisions, incidents and risk assessments. The page should ask the API rather than guess.
2. **A decommissioned asset is closed for change, but not for clearing up.** Its record stays as it was, but its links can be removed: dependencies in either direction, data assets held, risks, decisions and access entries. Removing a link from a decommissioned asset asks for a short reason, which is recorded in the activity log. Once nothing is left, Delete is available.
3. **Duplicates.** The delete dialog offers "It's a duplicate of …", where you pick the asset it duplicates. It's recorded with the deletion. Where the asset holds links, it offers to move them to the one it duplicates, then delete it. The moves are listed in the dialog before anything is changed.
4. Data and Software assets follow the same rules.
5. Polaris's tools match: delete and update work on a decommissioned asset in the same way, and a refused delete names what's in the way (it already does).

**Done when:**
- on a live asset with a dependency, Delete shows disabled with the reason, and removing the dependency enables it;
- on a decommissioned asset with a dependency, the dependency can be removed with a reason and the asset then deleted;
- "It's a duplicate of" with links moves them to the other asset, deletes this one, and the activity log shows both;
- an asset in a risk assessment stays undeletable, saying so (risk assessments are never deleted, so neither is what they name);
- the same works on Data and Software assets;
- light and dark mode are checked;
- there are no errors in the browser console.

On the chain: an API change adds a "why not deletable" read (the `_in_use_reasons` list as data) and lets link removal work on decommissioned assets. Amend ADR 0072 §6 (the guarded delete, and decommissioned as terminal). Frontend: `pages/ContainerDetailPage.tsx` `LifecyclePanel` (`deletable` checks only dependencies and data assets).