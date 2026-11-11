---
id: 01M76108D7PJPVAX7EXGWK93TC
created: 2026-11-11T19:22:51.687775Z
updated: 2026-11-11T19:22:53.68607Z
type: task
title: A file on a finished plan entry that duplicates another file on that entry can be archived as a duplicate, so it leaves the entry and audit packs but is still on record
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1738
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Found by Steve while testing (2026-11-11). Follows COM-1737: uploading the same pen test report twice, once on the plan entry and once from Vulnerabilities, left the entry holding **two copies**.

**What happens today:** once a Security Assurance Plan entry is done, nobody can remove its evidence (ADR 0115 §4, "part of the record"). Audit ▸ Evidence can't help either. Its Archive applies to assessment and risk files, and ADR 0122 §9 says the plan keeps its own rules. So a duplicate on a finished entry stays there for good. It shows twice on the entry and in Audit ▸ Evidence, and it would go into an audit pack twice.

**Steve asked for a delete option on the Evidence page. Recommended instead: Archive as duplicate.** Deleting would break the promise that nothing disappears without a trace (ADR 0122 §9). Archiving keeps the record and still gets the duplicate out of the way.

- **Where:** on the entry's evidence list, and on the file in Audit ▸ Evidence.
- **When it's offered:** only when the **same file**, byte for byte, is already on that entry. Compass compares the two files and offers **Archive as duplicate** on the extra copy, saying which file it duplicates. A different file can't be archived this way, so nothing that was really evidence is lost.
- **Who:** people who manage the plan. This matches who can remove evidence before an entry is done. It is not open to the entry's owner alone.
- **What happens:** the copy leaves the entry's evidence and Audit ▸ Evidence's current list, stops counting, and is left out of evidence packs and audit packs. It shows under **Archived** as "Duplicate of <file>", with who archived it and when. The entry's history and Activity record it. The original keeps everything it supports: its controls and the pen test review that came from it.
- **Removed for good** only through the existing Archived ▸ Download and delete (ADR 0122 §13), which keeps the deletion log.
- A copy linked to a pen test review: if the archived copy is the one the review came from, the review moves to the remaining copy, so the Findings panel and its link keep working.

Needs an amendment to ADR 0115 §4: done evidence can't be removed, **except** an exact duplicate archived as above.

**Done when:**
- On a finished entry holding the same file twice, a plan manager can archive the extra copy as a duplicate. The entry then shows one copy, and Archived shows the other with its reason.
- A file that isn't an exact copy of another on the entry offers no archive.
- The entry's owner who doesn't manage the plan, and a read-only viewer, see no archive option.
- Steve's real duplicate from this test can be cleared this way.