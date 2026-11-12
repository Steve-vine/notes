---
id: 01M76108D7PJPVAX7EXGWK93TC
created: 2026-11-11T19:22:51.687775Z
updated: 2026-11-12T12:33:00.467374Z
type: task
title: Any piece of evidence, wherever it was added, can be archived with a reason (a duplicate, the wrong file), and a single archived piece can be deleted for good, for when it should never have been uploaded
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1738
sprint: spsp226
comments:
- id: 01M76KMYM7E2SG090YE7VJ1VQR
  author: Steve Vine
  at: 2026-11-12T00:48:44.167628Z
  text: |-
    Done, merged in PR #1741 (migration 0821_archive_any_evidence).

    Archive works the same way everywhere:
    - Any file, link or vendor certificate can be archived with a reason: Duplicate (choose which piece it duplicates; the record's other evidence is offered first, then same-fingerprint or same-name matches), Wrong file uploaded, or Other in your own words.
    - Where: on the piece's page in Audit ▸ Evidence, and on each record's own evidence card. That covers assessments, risks, plan entries, incidents, data subject requests and their disclosures, trust centre documents, vendor certificates and vulnerability attachments. Audit request uploads and collected captures are covered through Audit ▸ Evidence.
    - Every old "Remove" is now this Archive.
    - What happens: the piece leaves the record and the current list, stops counting, and is left out of packs built from then on. It's listed under Archived with its reason, who and when. Incident and request timelines note it.
    - Who:
      - In Audit ▸ Evidence: Manage evidence.
      - On the record: whoever manages it. A plan entry's owner alone can't, and the owner's portal remove has gone.
      - Viewers see no option. Restricted incident and data subject request evidence stays out of reach for anyone who can't see the record.
    - Locked records take this archive and nothing else: a done plan entry, a closed incident or request, an incident triaged out, and a disclosure logged in error.
    - A done plan entry's last file asks "Why is there now no evidence?" and keeps the answer.
    - A current vendor certificate or trust centre document warns you before you confirm. Archiving a trust centre document takes it off the trust centre.
    - A pen test review's report: archived as a duplicate, the review moves to the remaining copy. Archived for any other reason, the review and its vulnerabilities stay, and the review says its report was archived.

    Delete permanently:
    - On an archived piece's page, for people with Delete archived evidence.
    - You give a reason and type the name; there's no download first.
    - The content goes from storage, and every download now answers "not found". The record still says a piece was there, and when and why it was deleted.
    - The deletion log names the audit packs that still hold it, and so does the confirmation ("Still in N audit packs built earlier: …").

    Audit packs: each built pack is stored as its own copy, so a pack built before a delete still downloads in full. Packs now also record what they hold, and that's how a delete can name them. A pack built afterwards leaves the piece out.

    Calls made:
    - A file on a data subject record under legal hold can't be deleted for good.
    - Single delete applies to incident and request files too. A sensitive wrong upload is the reason this exists.
    - Download-and-delete by date is unchanged.
    - An approved risk assessment's PDF and signed contracts aren't archivable. Compass makes or signs these; nobody uploads them.
    - Attestations hold no files (their evidence is signatures), so there's nothing to archive there.
    - Polaris can archive with "Wrong file" or "Other". Duplicates, current certificates, trust centre documents and a plan entry's last file stay on screen, and Polaris never deletes anything for good.
    - For packs built before today, "still holds it" is an estimate from the pack's period and build date.

    Decisions recorded as amendments to ADRs 0122, 0115, 0116, 0117 and 0118.

    Tests: integration tests cover:
    - archive on a finished plan entry and on a closed incident;
    - refusals for the owner alone, a read-only viewer and a restricted incident;
    - the last-file reason;
    - a single delete that leaves an earlier pack intact while a later pack leaves the piece out.

    Your real duplicate from testing can now be cleared from the plan entry with Archive → Duplicate. That's on production after a release, or on staging if you repeat it there.
- id: 01M77BN7E2WPE5F0QX1BM0XRZS
  author: Steve Vine
  at: 2026-11-12T07:48:19.010628Z
  text: |-
    Pre-UAT on staging (7ff9a75d), E2E Test Company, as E2E Admin A: Passed.

    Steps and what I saw:
    1. On SAP-70, uploaded the same PDF a second time, then marked the entry Done. It says "This entry is finished, so its evidence stays with the record. More can still be added, and a file archived with a reason." Both copies show an Archive button.
    2. Archive on the second copy: the window explains what archiving does and that audit packs already built keep it. I chose Duplicate; "The piece it duplicates" offered the other copy. I archived it.
       - "Evidence archived". The entry now shows one copy plus "1 archived", with the reason "Duplicate of E2E-pentest-report.pdf (Plan · E2E pre-UAT sprint 116 pen test)".
       - The history row records it, with the same reason.
    3. Audit ▸ Evidence ▸ Archived lists it with its reason. Its page has "Delete permanently…". The window asks for a reason and the file name typed again; there's no download step.
       - Deleted: "Deleted for good".
       - The entry's archived list now reads "Deleted for good 12 Nov 2026 by E2E Admin A — "E2E sprint 116 pre-UAT: duplicate copy". Only its record is kept."
    4. The pen test review stayed on the remaining copy ("Reviewed: 1 finding recorded").
    5. The Viewer can't open the plan.

    Not checked in the browser:
    - the "Still in N audit packs" wording (no pack had been built for this company);
    - incidents, data subject requests, vendor certificates and trust centre documents. Integration tests cover those, plus the earlier-pack case.

    Small things seen (not blocking; tell me if you want them logged):
    - After "Delete permanently" the page you're on shows "Not found", because the piece it was showing has gone. Going back to the Archived list would read better.
    - The entry's history labels the archive row "Deleted" and the earlier classification change as "Classification: — → 3". The words are right; the kind label and the number aren't.

    Screenshots: ~/compass-uat/spsp226/COM-1738/
assignee: steve
label:
- improvement
priority: medium
task_status: done
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