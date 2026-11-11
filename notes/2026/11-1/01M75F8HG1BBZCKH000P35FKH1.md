---
id: 01M75F8HG1BBZCKH000P35FKH1
created: 2026-11-11T14:12:48.769398Z
updated: 2026-11-11T17:35:29.79112Z
type: task
title: A content review's comment can be corrected; the document shows only the corrected wording, and the original stays in the activity log
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1732
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Steve, 2026-11-11. Today a review record (policy published with "Mark as reviewed", or the Review action) can never be changed (ADR 0032, `models/content_review.py`: append-only, "never updated or deleted through the API"). If a reviewer puts something wrong or sensitive in the comment by accident, it is stuck there. That includes the document's **Document Review** block (`{{document-review}}`), which goes out with the document: the PDF, Word, the Read tab, the Trust Centre and anything sent to a client.

**Behaviour wanted**
- Someone who can review the content (or an administrator) can **correct** a review's comment. They give a reason, which is required.
- **Wherever the review is shown, only the corrected wording appears:**
  - the Document Review block in the document, PDF and Word exports;
  - the content's Reviews tab;
  - the Trust Centre and portal copies;
  - the assistant's tools, `playbook_list_content_reviews`.
  - The original wording, the correction and the reason are **never** shown on the document review record. A document sent to a client can't leak what was corrected away.
- **The audit trail keeps everything:** the original wording, the new wording, who corrected it, when and why. These go in the activity log (Admin → Activity), visible only to people who can see the activity log. Today `content_reviews` is deliberately not in the activity-log allowlist (`db/audit.py`), so a correction needs its own activity entry.
- **Out of scope:** the reviewer, review date, outcome and version stay as they were. A correction changes the comment only. Deleting a review is still not possible.
- **Assistant:** a matching tool (`playbook_correct_content_review`) so Polaris can make a correction when asked. It must state the reason, and confirm first that the original stays in the activity log.

**Decision:** this amends ADR 0032's "never updated" rule, so it needs a new ADR (append-only; supersede rather than rewrite). The new ADR records why: a document leaves the organisation, so the record must be correctable; the audit trail holds the original instead.

**Done when:**
- A review's comment is corrected on screen with a reason.
- The PDF, the Read tab and the Trust Centre copy show only the new wording.
- Admin → Activity shows the original, the new wording, who, when and why.
- A person without activity-log access can't see the original anywhere.
- The assistant tool works and leaves the same activity entry.