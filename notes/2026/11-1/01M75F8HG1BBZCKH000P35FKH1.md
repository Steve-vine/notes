---
id: 01M75F8HG1BBZCKH000P35FKH1
created: 2026-11-11T14:12:48.769398Z
updated: 2026-11-11T22:18:46.524024Z
type: task
title: A content review's comment can be corrected; the document shows only the corrected wording, and the original stays in the activity log
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1732
comments:
- id: 01M75ZC5FJENSPR8HGK2C8EXVJ
  author: Steve Vine
  at: 2026-11-11T18:54:24.754637Z
  text: |-
    Done. PR #1734 (no migration; stacked on COM-1733's PR; decision in ADR 0149).

    What you see:
    - **Correcting a comment:** each review on a document's Review record has **Correct…** for anyone who can review content, administrators included. You edit or empty the comment and must give a reason. The window says the original is kept in the activity log.
    - **What changes:** only the comment. The reviewer, date, outcome and version stay, and reviews still can't be deleted.
    - **Where the new wording shows:** everywhere the review appears, only the new wording shows, with no "corrected" mark. That covers the Document Review block on screen and in every export, the portal and Trust Centre copies, and Polaris's `playbook_list_content_reviews`.
    - **Activity log:** Admin → Activity gets one entry under the document with who, when, the original wording, the new wording and the reason. People without activity-log access can't see the original anywhere; tests check this.
    - **Polaris:** `playbook_correct_content_review` asks first, requires a reason, and confirms the original stays in the activity log. It leaves the same entry, marked as made via the assistant.

    Not built: portal reviewers can't correct their own reviews from the portal. It's a library action only, and could be a follow-up.

    Checks: all pass locally (3,880 frontend tests); the drift check is OK.
- id: 01M76B2BVW9734XA02XX98AWA7
  author: Steve Vine
  at: 2026-11-11T22:18:46.523821Z
  text: |-
    Couldn't check the correction itself; what was visible looked right (Claude's pre-UAT pass, staging fcaf1d13).

    Why: correcting a comment changes a review on shared Playbook content that no test created, which the browser-testing rules forbid. I can't make a review of my own either, because reviewing needs a published document and tests never publish.

    Seen, without saving anything:
    - **As E2E Admin A**, AI Risk Assessment Standard's Review record shows Correct… on Steve Vine's 4 Nov 2026 review. The window:
      - is titled "Correct the review's comment" and names the review ("Steve Vine's review of 4 Nov 2026, version 2");
      - offers the comment to edit, and says it can be left empty;
      - asks "Why it is being corrected", marked as required;
      - notes that only the corrected wording will appear, and that the original stays in the activity log for people who can see it.
    - "Correct comment" stays disabled with new wording but no reason. I cancelled, and the comment still reads "Reviewed".
    - **As E2E Viewer**, the same document shows the Review record and the Version column but no Correct…, and the activity log is refused.

    What Steve should look at, on a document whose review he's happy to change:
    1. Correct a comment with a reason.
    2. Check the Read tab, the PDF and Word exports, and the Trust Centre copy show only the new wording, with no "corrected" mark.
    3. Check Admin ▸ Activity has one entry under the document with the original wording, the new wording, who, when and why.
    4. Ask Polaris (playbook_correct_content_review) to correct one. It should ask first, need a reason, and leave the same entry marked via the assistant.

    Screenshots: ~/compass-uat/sprint0-2026-11-11/COM-1732/ (correct-dialog-reason-required.png, viewer-no-correct-button.png)
assignee: steve
label:
- feature
priority: medium
task_status: review
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