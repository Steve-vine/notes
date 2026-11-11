---
id: 01M76108D7PJPVAX7EXGWK93TC
created: 2026-11-11T19:22:51.687775Z
updated: 2026-11-11T19:26:41.440489Z
type: task
title: Any file on a finished plan entry can be archived with a reason (a duplicate, the wrong file), and a single archived file can be deleted for good, for when it should never have been uploaded
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

**What happens today:** once a Security Assurance Plan entry is done, nobody can remove its evidence (ADR 0115 §4, "part of the record"). Audit ▸ Evidence can't help either. Its Archive applies to assessment and risk files, and ADR 0122 §9 says the plan keeps its own rules. So a duplicate on a finished entry stays there for good. Worse, so does the **wrong file uploaded by mistake**, even one holding sensitive information.

**Steve's call (2026-11-11): any file, not only exact duplicates.** People will upload the wrong file. A sensitive file that can't be removed is worse than a gap in the record.

### 1. Archive any file on a finished entry, with a reason

- **Where:** on the entry's evidence list, and on the file in Audit ▸ Evidence.
- **Who:** people who manage the plan. This matches who can remove evidence before an entry is done. It is not open to the entry's owner alone or to read-only viewers.
- **Reason, required:** **Duplicate** (choose the file it duplicates), **Wrong file uploaded**, or **Other** (free text).
- **What happens:** the file leaves the entry's evidence and Audit ▸ Evidence's current list, stops counting, and is left out of evidence packs and audit packs. It shows under **Archived** with its reason, who and when. The entry's history and Activity record it.
- **Archiving the entry's last file** asks for the reason there's no evidence, as completing without evidence already does (ADR 0115 §5). The entry then shows that reason.
- **A file a pen test review came from** (COM-1737): archiving it as a duplicate moves the review to the remaining copy. Archiving it for any other reason leaves the review and the vulnerabilities it recorded as they are. The review then says its report was archived.

### 2. Delete an archived file for good, now

Today the only way to remove an archived file's content is Archived ▸ Download and delete (ADR 0122 §13). That works by date, and it makes you **download first**, which is the wrong thing to ask of someone who has just uploaded a file that should never have been in Compass.

- On a single archived file: **Delete permanently…**, for people with **Delete archived evidence** (already marked dangerous).
- It asks for a reason and to confirm by typing the file's name. **No download is required.**
- The file's content is removed from storage. The **deletion log** keeps its name, type, where it came from, its fingerprint, when it was uploaded, archived and deleted, by whom and why, as it already does.
- The entry still shows that a file was here and was deleted, with the reason. Only the content goes.

Needs amendments to ADR 0115 §4 (finished-entry evidence can be archived with a reason) and ADR 0122 §13 (a single archived file can be deleted without a download, by Delete archived evidence).

**Done when:**
- On a finished entry, a plan manager can archive any file with a reason. The entry no longer shows it, and Archived shows it with its reason.
- The entry's owner who doesn't manage the plan, and a read-only viewer, see no archive option.
- Archiving the last file asks why there's no evidence.
- Someone with Delete archived evidence can permanently delete one archived file without downloading it. The deletion log and the entry both record it, and the file can no longer be downloaded anywhere.
- Steve's real duplicate from this test can be cleared this way.