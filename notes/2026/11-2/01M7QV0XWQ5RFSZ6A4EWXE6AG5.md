---
id: 01M7QV0XWQ5RFSZ6A4EWXE6AG5
created: 2026-11-18T17:24:42.007663Z
updated: 2026-11-18T22:55:31.643778Z
type: task
title: Every domain is a fixed folder in the Library that always holds that domain's documents
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1966
sprint: s2q1gxe
comments:
- id: 01M7RDYCJ1F9V5MY6K2F518TQ3
  author: Steve Vine
  at: 2026-11-18T22:55:21.664931Z
  text: |-
    Merged — PR #1965, squash 654c95e3 on main. Migration 0879_library_domain_folders (on COM-1962's 0878). ADR 0162 (amends ADR 0161 §3–§5); IA and feature briefs updated.

    What changed for a person:
    - Every domain has exactly one folder in the Library. A new domain gets one; renaming or redescribing a domain changes its folder; the folders keep the domains' order; deleting a domain removes its folder.
    - A domain folder always holds every published document in its domain, by itself. Publishing in a domain puts it there; changing a document's domain moves it at once. ("Test process" will appear in Information Security Governance.)
    - Nobody, Polaris included, can rename, recolour, move, reorder, delete, nest under or file into a domain folder. The API refuses with a clear message ("… is a domain folder: it follows its domain … Change the domain instead."), and Polaris explains the same.
    - Not in a folder = in no domain folder and no folder of people's own: decisions, and documents with no domain.
    - On a document's page, Folders lists its domain folder first, marked "Its domain", with no remove button.
    - On the Library page a domain folder card has no arranging menu and doesn't drag; inside one there's no New folder; Move to… and Add to another folder… don't offer domain folders.
    - On staging, the day-one folders became the domain folders (same address and look); any folder made inside one moved to the top (with " (2)" if the name was taken); filings into day-one folders were cleared.

    Assumptions for Steve to overturn:
    - A disabled domain's folder is hidden while the domain is disabled, and comes back with it.
    - A domain whose name matches one of people's own top-level folders gets its code added: "Access Control (ACC)".
    - Domain folders sit after people's own folders at the top; COM-1967 splits them into a Domains section.
assignee: steve
label:
- improvement
priority: high
task_status: review
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