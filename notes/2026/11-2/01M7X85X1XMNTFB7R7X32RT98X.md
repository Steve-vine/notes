---
id: 01M7X85X1XMNTFB7R7X32RT98X
created: 2026-11-20T19:50:48.637702Z
updated: 2026-11-20T23:43:58.509693Z
type: task
title: One piece of evidence can be linked to many records; unlinking isn't archiving
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2040
sprint: s9hexqn
blocked_by:
- 01M7X85FCF2REWD1JJSYCYX9BY
assignee: steve
label:
- feature
priority: medium
task_status: active
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