---
id: 01M76108D7PJPVAX7EXGWK93TC
created: 2026-11-11T19:22:51.687775Z
updated: 2026-11-11T22:58:29.936634Z
type: task
title: Any piece of evidence, wherever it was added, can be archived with a reason (a duplicate, the wrong file), and a single archived piece can be deleted for good, for when it should never have been uploaded
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1738
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Found by Steve while testing (2026-11-11). Follows COM-1737: uploading the same pen test report twice, once on the plan entry and once from Vulnerabilities, left the entry holding **two copies**.

**What happens today:** each module keeps its own rules for removing evidence, and several don't allow it at all. A finished Security Assurance Plan entry can't lose a file (ADR 0115 §4). Incidents, data subject requests and attestations also lock their evidence once the work is done. Audit ▸ Evidence's Archive only covers assessment and risk files, and ADR 0122 §9 leaves every other module to its own rules. So a duplicate stays for good, and so does the **wrong file uploaded by mistake**, even one holding sensitive information.

**Steve's calls (2026-11-11):**
- **Any file, not only exact duplicates.** People will upload the wrong file. A sensitive file that can't be removed is worse than a gap in the record.
- **Any evidence, not only the plan's.** One rule for every piece of evidence Compass holds.
- **Audit packs already built keep it.** A pack is a record of what was handed over at the time, and deleting evidence doesn't change it.

### Scope: everything in Audit ▸ Evidence's register

Files and links from assessments, risks, the plan, incidents, data subject requests, attestations, the trust centre, vendor certificates, audit requests, evidence added directly in the register, and collected evidence captures.

Not included:
- Published policies, standards and procedures. They have their own versions and history.
- Evidence of operation (signatures, reviews, handled incidents), which is worked out from records and not held as a file.

### 1. Archive any piece of evidence, with a reason

- **Where:** in Audit ▸ Evidence on the piece itself, and on the record it belongs to (the assessment, plan entry, incident, request, vendor…).
- **Who:**
  - In Audit ▸ Evidence: people with **Manage evidence**.
  - On the record: whoever manages that record. For example, people who manage the plan, or the incident's managers.
  - Not the record's owner alone, nor read-only viewers.
  - Evidence on a restricted incident or a data subject request can only be archived by someone who can also see that record (ADR 0122 §2).
- **Reason, required:** **Duplicate** (choose the piece it duplicates), **Wrong file uploaded**, or **Other** (free text).
- **What happens:** the piece leaves the record and the register's current list, stops counting, and is left out of evidence packs and audit packs built from then on. It shows under **Archived** with its reason, who and when. The record's history and Activity record it.
- **Locked records** (a finished plan entry, a closed incident or request, a completed attestation round) allow this archive and nothing else. They stay frozen otherwise.
- **The record's last piece of evidence:** where a record needs evidence or a reason (a finished plan entry, ADR 0115 §5), archiving its last piece asks for the reason there is none.
- **Before a record is finished,** each module's existing Remove becomes this same Archive, so there is one behaviour everywhere. Assessments and risks already work this way.
- **A file a pen test review came from** (COM-1737): archiving it as a duplicate moves the review to the remaining copy. Archiving it for any other reason leaves the review and the vulnerabilities it recorded as they are. The review then says its report was archived.
- **A vendor certificate or trust centre document** that is the current one: archiving it leaves the vendor or the trust centre without a current one, and the screen says so before you confirm.

### 2. Delete an archived piece for good, now

Today the only way to remove archived evidence's content is Archived ▸ Download and delete (ADR 0122 §13). That works by date, and it makes you **download first**, which is the wrong thing to ask of someone who has just uploaded something that should never have been in Compass.

- On a single archived piece: **Delete permanently…**, for people with **Delete archived evidence** (already marked dangerous). The restricted-record rule above applies here too.
- It asks for a reason and to confirm by typing the piece's name. **No download is required.**
- The content is removed from the record and from evidence storage: a file's bytes, or a link's address. The **deletion log** keeps its name, type, where it came from, its fingerprint, when it was added, archived and deleted, by whom and why, as it already does.
- The record still shows that a piece of evidence was here and was deleted, with the reason. Only the content goes.
- **Audit packs already built are not changed.** The confirmation says so: "Still in 2 audit packs built earlier: ISO 27001 2026, SOC 2 Q3". The deletion log records which packs still hold it. A pack built afterwards leaves it out.

Needs amendments to:
- ADR 0122 §9: one archive rule for all evidence, replacing "modules that lock their evidence keep their own rules".
- ADR 0122 §12 and §13: a single archived piece can be deleted without a download, and packs already built keep it.
- ADR 0115 §4, and the matching rules for incidents, data subject requests and attestations: finished records' evidence can be archived with a reason.

**Done when:**
- From Audit ▸ Evidence, and from the record itself, a permitted person can archive evidence with a reason. This works for an assessment, a finished plan entry, a closed incident, a closed data subject request, a vendor certificate and a trust centre document. The record no longer shows it, and Archived shows it with its reason.
- People who can't manage the record, and read-only viewers, see no archive option. Restricted incident and data subject request evidence stays out of reach for those who can't see the record.
- Archiving a finished plan entry's last file asks why there's no evidence.
- Someone with Delete archived evidence can permanently delete one archived piece without downloading it. The deletion log and the record both record it, and it can't be opened or downloaded from the record or the register.
- An audit pack built before the delete still contains the piece and still downloads in full. The delete confirmation and the deletion log name that pack, and a pack built afterwards leaves the piece out.
- Steve's real duplicate from this test can be cleared this way.