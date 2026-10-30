---
id: 01M62B7CAZYNSEQBTTAMMN829S
created: 2026-10-28T22:48:51.295125Z
updated: 2026-10-30T08:16:01.315631Z
type: task
title: Start a contract review — upload the client's contract (Word or PDF), name the client and what kind of contract it is, and Polaris splits it into sections and clauses, each tagged with its topic
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1438
sprint: s2v7d6y
blocked_by:
- 01M62B706A3TQXW6KT1DJNCQYS
comments:
- id: 01M64SJH21DKXF5JC584AW5K0W
  author: Steve Vine
  at: 2026-10-29T21:38:05.504892Z
  text: |-
    Done — PR #1456 merged (c525b789), migration 0742.

    What's there:
    - **Contracts ▸ Reviews (now the first tab):** the register shows CR-n, client, title, kind, owner, status, due, flag counts and last activity. It can be sorted and filtered by status, client and owner.
    - **New review:** pick a client, or type a new name (a new name adds the client). Then title, kind, owner (you by default), due and received dates, and the file.
      - Compare against defaults to our standard contracts of the same kind, and follows the kind until you change it.
      - The file can be Word or a PDF with text. A scan is refused with "This PDF has no text. Ask the client for Word or a text PDF".
    - **Reading:** the contract is split into sections and clauses with its own numbering (12.2(a)(i)), from Word numbering and headings or from a PDF's text. Each clause is tagged with the topic whose words it uses most; its own heading counts most, and its section's heading breaks ties. A clause with no topic is "General".
    - **The review page:**
      - clauses grouped by section on the left; the chosen clause's panel on the right (`?clause=12.2` works);
      - change a clause's topic, merge it with the next clause, or split it where you put the cursor (optional new number);
      - Edit details, Abandon (reason required), and download the file as received.
    - **Restricted:** View contracts sees every review, and the review's owner sees their own. Anyone else gets "not found".

    My calls:
    - **Splitting is done by Compass, not Polaris.** Polaris only judges clauses (COM-1439). This is cheaper and gives the same result every time; Polaris can still correct a topic when it reviews.
    - **Topic tagging by words:** each topic carries tagging words (editable in Admin ▸ Rubrics ▸ Contract topics).

    To test on staging: upload a real client MSA (Word) and a PDF DPA, check the numbering and topics, and fix one wrongly split clause.
- id: 01M658J4S7D1GR9DQF2ES9ME66
  author: Steve Vine
  at: 2026-10-30T02:00:01.575241Z
  text: |-
    Pre-UAT pass (Claude, staging, E2E Test Company): **Passed**, with two defects (COM-1460, COM-1461).

    - CR-1, a Word MSA, kept its own numbering and compared against our MSA v2; 12.2 was tagged Breach notification.
    - CR-2, a text PDF DPA, split into sections 1–5.
    - Merge, Split (11.1A) and topic change all worked.
    - A PDF with no text was refused with the right message.
    - Someone not on the review gets "Review not found".

    Defects:
    - COM-1460: in the PDF, some section headings lost their title ("1" plus a separate "1 Subject matter" row).
    - COM-1461: DPA clauses under "Breach notification", "Subprocessors" and "Data location" were all tagged Data protection.

    Also noticed: in Split, positioning the cursor with the keyboard never enabled "Split here", but the mouse did (possibly the headless browser).

    Screenshots: ~/compass-uat/sprint-98/COM-1438/.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 98, Contract Review (ADR 0134, COM-1435).

## What people see

- **Contracts ▸ Reviews:** a table with reference (CR-7), client, contract, kind, owner, status, due date, flag counts ("3 conflicts · 5 outside positions"), last activity. Filters by status, client and owner. The table is sortable.
- **New review:**
  - **client** (pick, or add a new one);
  - **title** (e.g. "ACME MSA 2027");
  - **kind** (MSA, DPA, Service schedule, NDA, Order form, Other);
  - **compare against**: the standard contract(s) to use, defaulting by kind (an MSA compares with our MSA, and so on);
  - owner (defaults to the person starting it) and due date;
  - the file: Word or PDF. Scanned PDFs are refused with "This PDF has no text. Ask the client for Word or a text PDF".
- **Reading the contract:** Polaris splits it into **sections and clauses**, keeping the contract's own numbering (12.2(a)), and tags each clause with its **topic** from the Positions topics. Clauses with no topic are tagged "General".
- **The review page:**
  - the contract on the left as clauses, each with its number, text, topic chip and flag (COM-1439);
  - the clause's panel on the right (flags, decision, comments, assignment).
  - A person can **change a clause's topic**, **merge** two clauses or **split** one if Polaris cut it wrongly.
- **Status:** Draft → In review → Approved → Sent → Signed (COM-1443), or **Abandoned** with a reason.
- **Restricted:** a review is seen only by *View contracts* holders and the review's reviewers and assignees (COM-1440).

## Who can do what

- *Review contracts* starts a review and adjusts its clauses.
- *View contracts* reads.

## Notes (technical)

- Tables: `contract_reviews` (company-scoped, numbered by sequence, CR-n), `contract_review_versions(review_id, n, attachment_id, received_on)`, `contract_clauses(version_id, number, heading, text, topic_id, order)`.
- Splitting: use Word numbering and headings where present. Use the ADR 0125 layout reader (`core/ddq_layout.py`) for PDFs and messy Word files.
- The file goes into the attachment store (ADR 0074). The review is **not** listed in the Evidence register until it's signed.
- Contract text is data, never instructions (as `ddq_text`).

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve uploads a real client MSA (Word) and a PDF DPA. Each is split with the contract's own numbering and sensible topics, and he fixes one wrongly split clause.