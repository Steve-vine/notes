---
id: 01M62B8EJP5EPEVMQB0KV8E1Z8
created: 2026-10-28T22:49:26.358063Z
updated: 2026-10-30T02:00:07.778056Z
type: task
title: Reviewers work it together — a reviewers list on each review, clauses and sections assigned to a person or Polaris with a due date, and internal comments on any clause with @mentions that reach the person in Actions and by email
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1440
sprint: s2v7d6y
blocked_by:
- 01M62B7Y0F46SBJ3ZJMRENSH1C
comments:
- id: 01M64VNEH79SRRFTPK5X60XP3H
  author: Steve Vine
  at: 2026-10-29T22:14:38.37524Z
  text: |-
    Done — PR #1458 merged (34eda1d6), migration 0744.

    What's there:
    - **Reviewers:** shown in the review header with the owner. Add reviewer takes anyone active in Compass, with a note; remove keeps their comments and decisions. A reviewer opens and works their review without View contracts. The Contracts menu shows to them, opening on Reviews only.
    - **Assign:** one clause, a whole section (from its heading) or several ticked clauses go to a person or to Polaris, with a due date and a note. Assigning someone not yet on the review adds them as a reviewer.
      - The clause list filters to All / Mine / With Polaris / Submitted / by person (`?show=mine` is the Actions link).
      - The assignee can Submit their clauses or Hand back with a note, which returns them to whoever gave them, or the owner.
    - **Comments:** threads on a clause (in its panel) or on a section (from its heading). Each shows author, time, "edited" and a Polaris badge where it applies. Reply, resolve or reopen (resolved threads fold away and nothing is deleted). Authors can edit for 15 minutes. The clause list shows open-thread counts.
    - **@mentions (built once, reusable):**
      - Typing @ offers people by name, using the keyboard. Mentions are stored by person, not by typed name.
      - Mentioning someone who can't open the review asks "Add X as a reviewer?". Yes adds them; No posts the comment and says they can't open it.
      - A mention reaches the person in Actions ("Steve mentioned you on CR-7, clause 12.1"), linking to the clause, plus an email. Opening the clause's comments clears it.
    - **Actions:** clauses assigned to me (grouped per review and due date), mentions I haven't opened, and reviews I own coming due.
    - **Comments are internal:** they never go into the client's file or the summary PDF.

    My calls:
    - **Clauses start with Polaris:** a clause with no assignment is with Polaris, so nothing is created per clause up front.
    - **Polaris's scope:** Polaris reviews only clauses still with Polaris, and its Can't tell passes the clause to the review's owner.
    - **The "Unassigned" filter** is "Submitted" here, since every clause is always with someone.

    To test on staging: add Mark as a reviewer and assign him section 12. Write "@mark can you check the cap here"; Mark gets the Actions item and the email, replies, and resolves the thread.
- id: 01M658JAV2TPKPPSAR3MSQSNPE
  author: Steve Vine
  at: 2026-10-30T02:00:07.777819Z
  text: |-
    Pre-UAT pass (Claude, staging, E2E Test Company): **Passed** on screen; **Couldn't check** the emails and the Word export.

    - Reviewers: E2E Assessor was added with a note.
    - Assignment: section 12 went to E2E Analyst, who was added as a reviewer automatically. It appears in Analyst's Actions, and Analyst sees Contracts with Reviews only, plus Mine and Submit all.
    - Mentions: an @mention of E2E Viewer offered "Add as a reviewer?". It reached Viewer's Actions and opened the clause. Viewer replied and resolved the thread, and the item left Actions.

    Couldn't check: the emails went to undeliverable test addresses. "No trace in the Word export" needs an approved review, which needs Polaris flags.

    Minor (COM-1462): when Viewer opens the review, a background request for topics is refused.

    Screenshots: ~/compass-uat/sprint-98/COM-1440/.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 98, Contract Review (ADR 0134, COM-1435). Steve, 2026-10-28: "it should be possible to add people to a reviewers list (a bit like owners works) and share internal comments, e.g. '@mark, can you review this section'."

## What people see

- **Reviewers** on the review's header: the owner plus the people added, as avatars with names on hover. **Add reviewer** picks anyone active in Compass, with an optional note ("Legal: liability and indemnity"). Being a reviewer lets someone open and work **this** review, even without *View contracts*. Removing a reviewer keeps their comments and decisions.
- **Assign**: one clause, a whole section, or several selected clauses go to a reviewer or **Polaris**, with a due date and a note. Every clause is always with someone: it starts with Polaris, as DDQ questions do.
  - The assignee sees it in **Actions** ("Review clauses 12–14 of ACME MSA 2027, due 5 Nov") with an email.
  - They **submit** their clauses when done, or **hand back** with a note.
  - The left-hand list filters to **Mine**, **Unassigned**, **With Polaris**, and by person.
- **Comments** on any clause or section: a thread with name, time and text.
  - Typing **@** offers people by name. Choosing one **mentions** them: they get an Actions item ("Steve mentioned you on CR-7 clause 12.2") and an email with the comment and a link straight to the clause.
  - Mentioning someone who isn't a reviewer asks "Add Mark as a reviewer?". Yes adds them; No posts the comment, but Mark can't open it, and the poster is told so.
  - **Resolve** a thread when it's settled; resolved threads fold away, and nothing is deleted. Comments can be edited for 15 minutes, then only followed up.
  - Comments are **internal**: they never appear in the Word file sent to the client, the summary PDF, or anything else that leaves.
- **My contract work** in Actions: assigned clauses, mentions not yet opened, reviews I own that are due.

## Who can do what

- The owner and anyone with *Review contracts* add reviewers and assign.
- Reviewers comment, mention and work clauses assigned to them.
- Only the clause's assignee changes its decision (COM-1441), as with DDQ answers.

## Notes (technical)

- Tables: `contract_review_reviewers(review_id, user_id, note, added_by)`, `contract_clause_assignments` (model them on `core/ddq_assignments.py`: Polaris is always an assignee, assign / submit / hand back), `contract_comments(review_id, clause_id | section_ref, author_id, body, resolved_at, edited_at)`, `comment_mentions(comment_kind, comment_id, user_id, seen_at)`.
- **@mentions are new in Compass. Build them once:**
  - a shared FE mention-input component (Mantine, keyboard-accessible, `aria` roles per memory "Mantine Menu jsdom quirks");
  - a core helper that parses and resolves mentions from stored tokens (`@[user:uuid]`), never from names;
  - one Actions source for mentions (ADR 0055).

  Other modules can adopt them later.
- Access: a reviewer or assignee gets read and work access to that review only, checked per review (the DDQ assignee pattern, which answers 404 to everyone else).

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve adds Mark as a reviewer and assigns him section 12. Steve writes "@mark can you check the cap here". Mark gets the Actions item and the email, opens the clause, replies, and resolves the thread. The Word export later has no trace of it.