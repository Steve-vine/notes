---
id: 01M7QV0XWQ5RFSZ6A4EWXE6AG5
created: 2026-11-18T17:24:42.007663Z
updated: 2026-11-18T17:24:45.154468Z
type: task
title: Every domain is a fixed folder in the Library that always holds that domain's documents
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1966
sprint: s2q1gxe
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Steve, testing the Library on staging (18 Nov): "Test process", published in Information Security Governance, was only under "Not in a folder". The day-one filing ran once (ADR 0161 §5). Steve's direction is that domains are fixed folders.

**What changes**
- **One folder per domain, always there.** Every domain has a folder in the Library. It can't be renamed, recoloured, moved, deleted or given subfolders, and it's never "arranged".
- **It follows its domain.** A new domain gets a folder. Renaming a domain renames its folder. Deleting a domain removes its folder.
- **Its contents are automatic.** A domain folder always shows every published document in that domain. Nobody files into it or takes anything out. When a document's domain changes, it moves to the new domain's folder at once.
- **People's own folders are separate.** People who can edit Content still make their own folders, nested as deep as they like, and file documents and decisions into them, as now. A document can be in its domain folder and any number of other folders.
- **"Not in a folder"** now means published documents and accepted decisions in neither a domain folder nor any of your own folders. In practice that's decisions (which have no domain) and documents with no domain, until someone files them. My call, for Steve to overturn.

**Choices, for Steve to overturn**
- Domain folders keep the look day one gave them: an icon and colour per domain. Their order follows the domains' own order.
- **The day-one folders go.** The Library isn't released, so this only affects staging. The folders day one made per domain are replaced by the fixed domain folders. Any subfolder someone made inside one becomes a top-level folder of its own. A document filed only into a day-one folder (not its own domain's) moves to "Not in a folder".
- Search treats a domain folder like any folder: folder chips, "a folder it's in" ranking, and "This folder" inside a domain folder.
- Inside a domain folder there's no New folder, Rename or Delete, and its card's "…" menu has no arranging actions.
- On a document, the Library folders field shows its domain folder as fixed (not removable), followed by the folders it's filed in.

**Done when**
- Every domain has exactly one folder, and creating, renaming and deleting domains keeps them in step. Tests cover each case.
- Publishing a document in a domain puts it in that domain's folder with no other step. "Test process" appears in Information Security Governance.
- Changing a document's domain moves it between domain folders.
- No one, including Polaris, can rename, move, delete, reorder, nest under or file into a domain folder. The API refuses with a clear message.
- "Not in a folder" lists only what's in no domain folder and no folder of your own.
- Polaris's Library tools browse domain folders and search within them. Asked to change one, they explain that domain folders follow the domains.
- ADR: a new ADR (next free number) amends ADR 0161 §3–§5 for fixed domain folders. Brief updated.
- The e2e journey that makes, renames and deletes an "E2E …" folder still passes, and the Browser smoke Library crawl passes.

On the chain: migration (replace day-one folders; how domain folders are held) and API changes (folder tree, filing, delete rules).