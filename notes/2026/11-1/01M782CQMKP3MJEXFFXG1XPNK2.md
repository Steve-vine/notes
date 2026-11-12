---
id: 01M782CQMKP3MJEXFFXG1XPNK2
created: 2026-11-12T14:25:37.939858Z
updated: 2026-11-12T14:25:37.939858Z
type: task
title: A technology asset that can't be deleted says why, and a decommissioned one can still have its links removed and then be deleted
label: bug
task_status: todo
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1758
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