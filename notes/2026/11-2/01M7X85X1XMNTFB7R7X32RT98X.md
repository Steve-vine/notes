---
id: 01M7X85X1XMNTFB7R7X32RT98X
created: 2026-11-20T19:50:48.637702Z
updated: 2026-11-21T01:21:42.090797Z
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
assignee: steve
label:
- feature
priority: medium
task_status: review
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