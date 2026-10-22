---
id: 01M5JTFQD2BJZX66XZ7CDYARXT
created: 2026-10-22T22:07:42.498427Z
updated: 2026-10-22T22:11:00.01535Z
type: task
title: 'ADR: Due diligence questionnaires — a company answers the questionnaires its clients send from what Compass already holds, with a Q&A library that learns from every approved answer, and nothing leaves above what its sensitivity allows'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1245
sprint: s5uw2fz
comments:
- id: 01M5JTNR9FJB42KQ5ZKM99AFR9
  author: Steve Vine
  at: 2026-10-22T22:11:00.015045Z
  text: |-
    Sprint plan, in build order (each blocked by the one before):

    1. COM-1245 — this ADR, 0124 (independent)
    2. COM-1246 — the Sensitive level, with existing classifications kept (chain: migration + API)
    3. COM-1247 — each level's DDQ sharing rule in the rubric (chain: migration + API)
    4. COM-1248 — classification on evidence and trust centre documents; bulk classify (chain: migration + API)
    5. COM-1249 — DDQ in the menu, permissions (chain: API)
    6. COM-1250 — the Q&A library (chain: migration + API)
    7. COM-1251 — import an answer bank from a spreadsheet (chain: API)
    8. COM-1252 — library review dates, DDQ Settings (chain: migration + API)
    9. COM-1253 — log a DDQ, the Requests register (chain: migration + API)
    10. COM-1254 — the NDA position (chain: migration + API)
    11. COM-1255 — questions from a spreadsheet (chain: migration + API)
    12. COM-1256 — questions from an email or online questionnaire (chain: API)
    13. COM-1257 — answer a question: suggestions, sources, evidence, sharing check (chain: migration + API)
    14. COM-1258 — assign a question (chain: migration + API)
    15. COM-1259 — review, held back, Admin release (chain: migration + API)
    16. COM-1260 — approved answers feed the library (chain: API)
    17. COM-1261 — the completed spreadsheet, email reply or online record (chain: API)
    18. COM-1262 — the evidence pack (chain: API)
    19. COM-1263 — mark as sent, frozen (chain: migration + API)
    20. COM-1264 — recertification starts from last year (chain: API)
    21. COM-1265 — keeping DDQs on track (chain: API)
    22. COM-1266 — the assistant (independent, built last)

    This chain starts after sprint 83's last on-chain task has merged. Spreadsheet tasks (COM-1251, 1255, 1261, 1264) need two or three real client questionnaires as test fixtures, which Steve is to supply.
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Sprint 84, DDQ-1. The decision record for the sprint: **ADR 0124** (or the next free number), plus the IA brief's Modules table, the permission catalogue and the rubrics brief. It amends **ADR 0042 §1** (the sensitivity scale is no longer four levels). Every other task builds on it.

**Chain:** independent

## Why (Steve, 2026-10-22)

Clients send due diligence questionnaires (DDQs) when they take us on and every year when they recertify their vendors. They arrive as spreadsheets, as emails, or in the client's own online system, and every one looks different. Most of the answers are already in Compass: policies, controls, how they're assessed, evidence, certificates. Today someone retypes them by hand each time, chases colleagues for the rest, and the answers they get are lost by next year.

## What Steve decided (2026-10-22)

1. **The person's own assistant does the reading and drafting** (ADR 0109). Compass holds the register, the questions, the answers and their sources, the library, assignments and approval. Nothing in Compass calls an AI provider this sprint. The design leaves room for Compass to read and draft by itself later: a draft records who drafted it and from what, whoever that is.
2. **The flow:** someone creates a DDQ request in Compass and uploads the spreadsheet or pastes the email. They work through it with their assistant. Once it's complete they download the completed file or copy the completed email, plus a zip of the evidence where appropriate.
3. **Online systems:** there's no standard platform and no integration. The person signs in themselves, and the assistant works in their browser.
4. **The Q&A library:** people can add answers by hand. Answers staff give in a DDQ are offered to the library, and **an answer is approved before it becomes reusable.**
5. **One library per company**, not shared.
6. **Questions nobody can answer are assigned to staff** to answer.
7. **Everything that can go out carries a sensitivity classification** from the rubric. Each level has a rule, set in the rubric, for when it can be given in a DDQ: Always, Only with an NDA in place, or Never.
8. **A new level, Sensitive**, between Internal and Confidential: Public → Internal → **Sensitive** → Confidential → Restricted.
9. **An NDA is in place** when it's ticked on the DDQ with the signing date and a copy of the signed NDA, or when Compass recognises that the client's organisation has accepted the trust centre NDA.
10. **An Admin can override any restriction**, for one item on one DDQ, with a reason that is recorded permanently.

## How it works

- **Modules ▸ DDQ.** Tabs: **Requests** (the register), **Q&A library**, and **Settings** (managers).
- **A DDQ** (`DDQ-7`) has a requester (organisation and contact), a kind (onboarding, recertification or other), a format (spreadsheet, email or online), a due date, an owner, and the NDA position.
- **Lifecycle:** Received → In progress → In review → **Sent** (frozen: what was said, and exactly which files went out). It can also be Withdrawn or Declined; it's kept either way and never deleted.
- **Questions** come from the spreadsheet's question column (Compass reads them itself once someone has said which columns to use), from the email, or are added one by one (by hand or by the assistant, for an online system).
- **Answers** have a short response (Yes/No/N/A, where the questionnaire asks for one) and the detail. They cite their **sources** (a library answer, a policy or standard, a control, an evidence item, a trust centre document) and may attach evidence. Compass suggests matching library answers itself by text similarity, with no AI involved.
- **Sharing:** an answer's classification and its evidence's classifications are checked against the rules and this DDQ's NDA position. Anything that may not be shared is **held back**: shown in Compass with the reason, and left out of the pack.
- **Out:** the completed spreadsheet (answers written into the client's own file), the email reply text, or a record of the online questionnaire. The **evidence pack** is a zip with an index, and every PDF is watermarked with who it was shared with.
- **Recertification** starts from the last DDQ for the same requester.

## My calls (for Steve to confirm)

1. **Place:** Modules ▸ DDQ, after Trust Centre (the two are the outward-facing modules). Path `/ddq`.
2. **Permissions:** View DDQs, Manage DDQs (create, work, assign, send), **Approve DDQ answers** (also approves library entries), **Release held-back information** (built-in Admin only). Built-in Admin holds them all; starter roles stay frozen.
3. **Numbering:** `DDQ-n`, one sequence across companies, like RA-, R- and INC-.
4. **Sensitive's definition:** "Information shared outside the company only with named parties under a non-disclosure agreement — security policies and procedures, audit and penetration-test summaries, architecture overviews." Steve edits the wording in the rubric.
5. **Starting sharing rules:** Public = Always, Internal = Never, Sensitive = Only with an NDA, Confidential = Never, Restricted = Never. Steve adjusts them in the rubric.
6. **Unclassified means Internal:** anything without a classification is treated as Internal, so it's never shared, until someone classifies it. The Evidence register gets bulk classification so this isn't a chore.
7. **An answer's classification** defaults to the highest of its sources. The drafter or approver may set it lower when the wording gives away less than the source does ("We have an incident response policy, reviewed yearly"), with a reason kept in its history. **Evidence files are always judged by their own classification**, never lowered for one DDQ (only an Admin release gets one out).
8. **Gaps, risks and assessment results are never sources** of an answer that goes out. The assistant can still read them, through the tools it already has, to tell the person where the company is weak.
9. **A person assigned a question** can open and answer that one question from their Actions, even without View DDQs. They don't see the rest of the DDQ.
10. **NDA recognised from the trust centre:** a trust centre visitor whose email domain matches the DDQ contact's, and who has accepted the company's **current** NDA wording.
11. **Library entries** have a question plus other wordings, a short response, the answer, a classification, sources and evidence, an owner, tags, and a review date (12 months by default, set in DDQ Settings). An out-of-date entry is still suggested but marked "due for review".
12. **Spreadsheets:** `.xlsx` (and `.csv`). An old `.xls` is refused with "save it as .xlsx first". If the file has things Compass can't carry through to the completed copy (macros, images, charts), Compass says so when the file is uploaded.
13. **The assistant can never release held-back information.** Otherwise it can do what the person can on screen (ADR 0109), including approving if the person holds the permission.
14. **The evidence pack** contains the evidence attached to approved answers, after the sharing rules. Policies and standards are rendered as PDFs in the company's house style. Each PDF is watermarked "Shared with <organisation> · DDQ-7 · <date>" (the trust centre stamp). There's an index of question → file, with each file's fingerprint.

## Not in this sprint

Compass reading or drafting by itself (in-app AI); integrations with any online DDQ platform; writing answers back into Word or PDF questionnaires; a register of clients; publishing library answers on the trust centre; deleting DDQs.

**Done when:** ADR 0124 is merged, ADR 0042 is marked amended by it, the IA brief has DDQ in the Modules table, the permission catalogue has its table, and the rubrics brief has the five-level scale and the sharing rule.