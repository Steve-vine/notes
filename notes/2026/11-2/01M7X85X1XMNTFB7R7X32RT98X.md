---
id: 01M7X85X1XMNTFB7R7X32RT98X
created: 2026-11-20T19:50:48.637702Z
updated: 2026-11-22T08:13:22.11795Z
type: task
title: One piece of evidence can be linked to many records; unlinking isn't archiving
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2040
sprint: s9hexqn
blocked_by:
- 01M7X85FCF2REWD1JJSYCYX9BY
comments:
- id: 01M7XV3P2NNJY3S1ZZC4CPJVHE
  author: Steve Vine
  at: 2026-11-21T01:21:38.901746Z
  text: |-
    Done and merged to main (PR #2035, migration 0888).

    What changes:
    - One file or web address can be linked to any number of records: controls, schedule entries, incidents (the evidence, a timeline entry, a notification), risks, vulnerabilities, audit requests and a finding's closing evidence. It's the same piece everywhere, so its details read the same everywhere.
    - The evidence's page has a new "Used in" panel. It lists every record the piece is on, with a link to each. "Added here" marks where it was first added and "Finished" marks finished records. Take off removes it from that one record only, and that record's history says who did it.
    - Archiving a piece shows it archived on every record it's on.
    - A finished record (a done or cancelled schedule entry, an ended incident, a closed finding, an ended audit) can't have evidence taken off. Once it's reopened with a reason, it's open again. Deleting a piece for good is refused while a finished record relies on it, and the message names the records.
    - Linking a piece to a control runs that control's workflows. A restricted piece stays hidden wherever it's linked.
    - Nothing visible changed on day one. A migration test over a populated database shows every record lists the same pieces in the same order before and after.
    - Left over from COM-2039: the Automatic Collection rows on a control's assessment card now show their EVD ID.

    Calls for you to overturn:
    1. A piece's status (Compliant / Non-compliant / Unchecked) is one per piece, as it is today under ADR 0155. It isn't one per control, as the task assumed. Linking a piece to another control re-runs that control's workflows, but if the piece already has a status, it doesn't reset to Unchecked. Status per control would change how workflows judge evidence, so it would need its own task.
    2. A timeline entry's or notification's files can't be taken off, because those records are append-only.
    3. Linking evidence to a closed incident needs a reason, the same as uploading to one.
    4. Once a piece is deleted for good, only the record it was first added to lists it as deleted. Its other records stop showing it, and their history shows it being taken off.

    Still to come in later tasks: each area's own Remove button still archives. COM-2043 to COM-2045 switch them to taking off. The Take off button can also show for audit evidence the auditor has already seen; pressing it explains that it must be withdrawn on the audit with a reason. COM-2044 will hide it there.
- id: 01M7YNA8KHYY14B5CZRH07CX5T
  author: Steve Vine
  at: 2026-11-21T08:59:37.456824Z
  text: |-
    Failed (minor) (pre-UAT, staging 7e04d3f5e, E2E Admin A, E2E Test Company). Linking, "Used in", archiving and the server's refusal all work. Two things on screen don't match the task.

    What works:
    - One piece on many records: EVD-62 (a screenshot) is on RIM.9, AUD-1 request E2E-20261121-01, AUD-1-F2's closing evidence and VUL-3. Its "Used in" lists all four, each with a link and "linked 21 Nov 2026 by …". EVD-68 lists RIM.9 and "SAP-85 … FINISHED". EVD-69 marks SAP-85 "ADDED HERE · FINISHED".
    - Details are the piece's own: I changed EVD-62's "What it is" and "Covers to" once (Edit details). VUL-3 and RIM.9 then showed the new text and dates.
    - Take off: on EVD-66 (on RIM.8 and RIM.9), Take off RIM.9 asked "It is taken off RIM.9 only. It stays in the evidence register and wherever else it is used…". Afterwards RIM.9 no longer listed it, RIM.8 still did, and it stayed current in the register. A finished record (SAP-85) has no Take off.
    - Archive: archiving EVD-69 (on finished SAP-85 and on RIM.9) showed "1 archived" folded away on SAP-85, and it left RIM.9's current list.
    - Delete for good: an archived piece only on an open record (EVD-61, on RIM.9) offered "Delete permanently…", and deleting worked. For an archived piece a finished record relies on (EVD-70, on SAP-85), the server refuses: "Finished records rely on it, so it can't be deleted: SAP-85 E2E 20261121 Assess and renew cyber insurance".

    Defects:
    1. The refusal isn't shown on screen. On EVD-70's page the "Delete permanently…" button is just missing, with no text saying why or naming SAP-85. The page already receives that refusal text from the server; it isn't displayed. Expected: Compass says where it's used, naming the records. Screenshot: COM-2040/evd-70-after-archive.png
    2. The record's own History doesn't show the take-off. The confirmation says "RIM.9's history says you took it off". RIM.9 ▸ History has no line for it, and the earlier "linked from elsewhere" line for EVD-66 has gone too. The activity log does record it ("unlinked E2E 20261121 register Word file.docx from RIM.9"), and an incident's History does show "unlinked … from INC-125". Screenshot: COM-2040/rim9-history.png

    Not checked: that every record shows exactly what it did before the migration. Older E2E records (EVD-5 on the sprint 116 pen-test entry, EVD-12) still show as before.

    Screenshots: ~/compass-uat/s9hexqn/COM-2040/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Built to the ADR in COM-2038, after COM-2039. This is the foundation the Add evidence window (COM-2041, COM-2042) and its rollout stand on. There's no new screen of its own beyond "Used in".

**What changes for people**
- A piece of evidence (a file or a web address) can be linked to **any number of records**: controls, schedule entries, incidents (the evidence, a timeline entry, a notification), risks, vulnerabilities, audit requests and a finding's closing evidence. It's the same piece everywhere, never a copy.
- **Its details are its own.** The name, evidence type, classification, description and dates are held once. Changing them anywhere changes them everywhere, recorded once in the activity log.
- **"Used in"**: the evidence's details (from the register, or any row it appears on) list every record it's linked to, with a link to each, for example "RIM.9 · SAP-14 Renew cyber insurance · AUD-2 request 4.1".
- **Removing it from one record** only unlinks it there. It stays in the register and on its other records. The record's activity log says who removed it. Whoever may add evidence to that record may remove it.
- **Archiving it** (with a reason, COM-1738) archives it everywhere, and every record it's on shows it archived, folded away as today.
- **A finished record** (a done schedule entry, a closed incident, a closed finding, an ended audit) keeps what it was finished with. It can't be unlinked there; archiving is the one change, as today.
- **Deleting for good** (COM-1738) is refused while a finished record relies on the piece, and Compass names the records. A piece only on open records can be deleted for good once archived, and it leaves them all.
- **A piece's status on a control** (Compliant / Non-compliant / Unchecked) stays per control, as today. Linking a piece to another control starts it Unchecked there and runs that control's workflows, the same as adding it.
- **Who can see it:** linking doesn't widen who can see a piece. A restricted piece (a signed contract) stays restricted wherever it's linked.

**Implementation notes**
- Today evidence has one owner (owner_type/owner_id on files and web addresses), plus evidence_control_links for extra controls and the audit-side links (request evidence, closing evidence). Move to a piece-and-links model that keeps the piece's original place as its first link. Migrate every existing row so nothing visible changes on day one: same records, same order, same statuses, same classifications.
- Keep each area's own permission for adding to its records.
- The Evidence of operation and audit pack reads must still find SAP evidence as they do now.

**Done when**
- One piece can be linked to several records, and its details show the same everywhere.
- "Used in" lists every record a piece is on.
- Unlinking leaves it everywhere else. Archiving shows everywhere. Deleting for good is refused while a finished record relies on it, with the records named.
- After the migration, every record shows exactly the evidence it showed before.

On the chain: migration and API change.