---
id: 01M75GJ0NZZC8J15H561PWQVWN
created: 2026-11-11T14:35:27.80773Z
updated: 2026-11-11T22:18:37.456483Z
type: task
title: A document with unpublished changes can't be reviewed; the reviewer publishes or discards the draft first, so a review is always of the version people read
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1733
comments:
- id: 01M75ZC08H9DDSN08J2PYJRPZD
  author: Steve Vine
  at: 2026-11-11T18:54:19.408952Z
  text: |-
    Done. PR #1730 (API change, no migration; ADR 0149, which amends ADR 0032).

    What you see:
    - **No review while there's a draft:** while a document has unpublished changes, Review isn't available, and the reason is given in your wording:
      - the Review… button is disabled, with the reason on hover;
      - an initiative's Record review is greyed out, with the reason under it;
      - the API refuses;
      - Polaris's `playbook_review_content` refuses with the same reason.
    - **Publishing still reviews:** publish with "Mark as reviewed" still works, and records the review against the version just published.
    - **Drafts are visible:** a published document with a draft reads "Published · draft changes" on the content list, the document header and Details, an initiative's content rows and Polaris's status. Its Actions row gets a "Draft changes" badge.
    - **Reviews name their version:** the Review record on the Read tab and the Document Review block (screen, PDF, Word, plain text and SharePoint copies) have a Version column.

    Calls I made:
    - **Discard a draft:** reverting to the currently published version now discards the draft properly. The document stays Published and can be reviewed straight away. Before, revert always left a Draft.
    - **Portal reviewers are not blocked:** the portal only shows them the published version, so their review is unambiguous.
    - **Old imports:** a document that was published by import and never through Compass counts as all-draft. It has to be published once before its next review.

    Checks: backend and frontend all pass locally, CI is green, and the drift check is OK.
- id: 01M76B230GGG9FN0KXRW1VKQRM
  author: Steve Vine
  at: 2026-11-11T22:18:37.456262Z
  text: |-
    Passed for what I could check; publishing with "Mark as reviewed" and the initiative row couldn't be checked (Claude's pre-UAT pass, staging fcaf1d13, as E2E Admin A). I published nothing and reviewed nothing.

    Passed:
    - **The draft shows:** Content list rows read "Published · draft changes" for AI Risk Assessment Standard and the Joiners, movers and leavers procedure; other documents read "Published". The document header reads the same, with an "Unpublished draft changes" banner on the Read tab.
    - **Review is blocked:** on the Edit tab, Review… is disabled. Hovering shows the reason word for word: "This document has unpublished changes. Publish them (and record the review there) or discard them, then review."
    - **The route Polaris uses is refused:**
      - I made my own never-published draft, "E2E preUAT COM-1733 draft", and asked to record a review on it the way the assistant's tool does.
      - It was refused with the same sentence. Nothing was recorded.
      - I deleted the draft afterwards.
    - **Reviews name their version:** the Read tab's Review record has a Version column (v2), and so does the Document Review block in the document (2).

    Couldn't check:
    - **Publish with "Mark as reviewed":** publishing shared Playbook content is off-limits to tests.
    - **The initiative's greyed-out Record review:** no E2E initiative holds a document with a draft. Adding one would raise a review action for the real Content library team.
    - **The "Draft changes" badge in Actions:** none of the current Content actions is for a document with a draft.

    What Steve should look at:
    1. Publish a drafted document with "Mark as reviewed" and check the review lands against the new version.
    2. Look at an initiative's content row for a drafted document.
    3. Ask Polaris to review AI Risk Assessment Standard: it should refuse with the sentence above.

    Screenshots: ~/compass-uat/sprint0-2026-11-11/COM-1733/ (content-list-draft-changes.png, review-disabled-with-reason.png, read-tab-review-version-column.png)
assignee: steve
label:
- improvement
priority: high
task_status: review
---
Steve, 2026-11-11, from the SOC2-2026 policy reviews. Sixteen policies had draft changes when the initiative asked him to review them. He reviewed each one, and the reviews were recorded against version 1, the published text. It isn't clear whether he read the published text or the draft. The status showed "Published" throughout, so nothing on screen said a draft existed. An auditor reading the review log can't tell what was reviewed either.

**Behaviour wanted**
- **Review is blocked while a draft exists.** When a document has unpublished changes, Review isn't available. The screen says why: "This document has unpublished changes. Publish them (and record the review there) or discard them, then review." That applies to the Review action, the Actions list item, the initiative's review item and the assistant (`playbook_review_content` refuses with the same reason).
- **Publishing still records a review.** Publish with "Mark as reviewed" stays the way to review a change. The review is then recorded against the version just published.
- **A draft is visible.** A document with unpublished changes shows it next to its status everywhere the status appears (e.g. "Published · draft changes"): the content list, the document header, the initiative's content rows and Actions. "Published" alone no longer hides a pending draft.
- **The review record names its version.** Each review in the log shows the version it was of. `content_version` already exists (COM-1494), so this is a matter of surfacing it on the Reviews tab and in the Document Review block.

**Done when:**
- A document with a draft can't be reviewed by any route, and gets the explanation above.
- Publish with "Mark as reviewed" still works.
- The status shows the draft.
- The Reviews tab shows the version reviewed.
- Tests cover the Review action, the initiative review item and the assistant tool.

Related: COM-1732 (correcting a review's comment).