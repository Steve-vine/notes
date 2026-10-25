---
id: 01M5PF3AJNFN3Y7GKK28DGG3KT
created: 2026-10-24T08:05:39.541345Z
updated: 2026-10-25T16:24:23.609364Z
type: task
title: An Admin can delete a DDQ that was never sent — for test DDQs and ones logged by mistake — with a reason kept in Activity
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1276
sprint: shig2cj
comments:
- id: 01M5PZM2XM6FQSPHQFEJM3N432
  author: Steve Vine
  at: 2026-10-24T12:54:25.972575Z
  text: |-
    Done — merged in #1290.

    What changed: an Admin can now delete a DDQ that was never sent: Received, In progress, In review, Withdrawn or Declined.
    - On the DDQ's page, the ⋯ menu at the end of the header has Delete DDQ…. The window says exactly what will go ("DDQ-7 for Northwind Legal: 48 questions, 31 answers, 3 files, 1 evidence pack"), asks for a reason, and asks you to type DDQ-7 to confirm.
    - Afterwards you're back on the register and the DDQ is gone, with its questions, answers, assignments, evidence packs and stored files. Anyone who had a question assigned from it no longer sees it in Actions.
    - Admin ▸ Activity keeps every earlier line about it, plus "deleted DDQ-7 · Northwind Legal (48 questions, 31 answers): <reason>".
    - The Q&A library keeps every entry and version. Where an entry was used in the DDQ, its Used in now shows "DDQ-7 (deleted)" without a link.
    - A DDQ started from the deleted one carries on, but no longer shows "Started from". DDQ numbers aren't reused.
    - A sent DDQ can't be deleted. People without the permission don't see the menu. The assistant and API tokens are refused.
    - The new permission, Delete DDQs, is in Admin ▸ Roles ▸ DDQ, marked dangerous. Only the built-in Admin has it. ADR 0124 is amended.

    My calls:
    1. A new permission rather than reusing Release held-back information.
    2. Withdrawn and declined DDQs can be deleted too, because they were never sent.
    3. Delete is permanent. There's no bin and no undo; the reason in Activity is what remains.
    4. The typed reference ignores capital letters (ddq-7 works).
    5. In the window's count, "files" includes the questionnaire and any file taken off by mistake, and "answers" means questions that have an answer.
    6. A DDQ in an archived company can't be deleted, like any other change there.
    7. If one of the DDQ's files was linked to a control in Audit ▸ Evidence, that link is marked removed, the same way deleting evidence handles it.
    8. The ⋯ menu sits after the next-step button from COM-1274. It only appears for people who can delete, and never on a sent DDQ.

    To check on staging:
    - Delete a test DDQ that has a file, an answer taken from the library and an assigned question. It should be gone from the register, the assignee's Actions should be clear, Admin ▸ Activity should show the line with your reason, and the library entry's Used in should say "DDQ-n (deleted)".
    - A sent DDQ has no ⋯ menu.
    - A manager who isn't an Admin sees no ⋯ menu.
    - Admin ▸ Roles ▸ DDQ lists Delete DDQs as dangerous.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 85, DDQ-2. From Steve (2026-10-24): "Is there a way to delete a ddq completely?" → "Log it."

Today a DDQ can only be withdrawn or declined, so it stays in the register for good (ADR 0124 §6 and "Out of scope: deleting DDQs"). That's right for real client work, but test DDQs and ones logged by mistake clutter the register.

**Chain:** on the chain (API + a new permission; a migration if the permission needs granting to the built-in Admin)

## What people see

- **Delete DDQ** in the DDQ page's header menu, for people holding the new permission **Delete DDQs** (built-in Admin only, marked dangerous, in Admin ▸ Roles ▸ DDQ).
- Only for a DDQ that was **never sent**: Received, In progress, In review, Withdrawn or Declined. A Sent DDQ is the record of what went to a client and can't be deleted.
- A confirmation window says what goes ("DDQ-7 for Northwind Legal: 48 questions, 31 answers, 3 files, 1 evidence pack") and asks for a **reason**, plus typing the reference (DDQ-7) to confirm.
- Everything that belongs to the DDQ is removed, including the stored files. Open assignments disappear from the assignees' Actions.
- **Admin ▸ Activity** keeps a line: "deleted DDQ-7 · Northwind Legal (48 questions, 31 answers): <reason>". Earlier Activity lines about it stay, because the log is append-only.
- The Q&A library is untouched. An entry that was answered from, or added from, the deleted DDQ keeps its versions; its **Used in** shows "DDQ-7 (deleted)".
- A DDQ started from a deleted one loses the link; its Details card no longer shows "Started from".
- The DDQ number isn't reused.

## My calls (for Steve to confirm)

1. **A new permission rather than reusing Release held-back information.** Deleting is a different act, and some organisations may want one without the other.
2. **Withdrawn and declined DDQs can be deleted too.** They were never sent, so nothing went to the client.
3. **Delete is permanent.** There's no bin or undo, and the reason in Activity is what remains.

## Notes (technical)

- An ADR 0124 amendment: §6 "never deleted" becomes "never deleted once sent; an Admin may delete an unsent DDQ with a reason".
- Permission `ddq.delete` (dangerous). Grant it to the built-in Admin as 0590 did, and add a catalogue entry.
- Delete cascades: questions, answers and their versions and links, assignments, releases, packs and their stored zips, DDQ files and their storage objects (delete from the store after commit, as the evidence deletion run does), settings untouched. `ddqs.started_from_id` on later DDQs becomes NULL. Library `Used in` must cope with a missing DDQ (keep the label; mark it deleted).
- Actions: assignment, due and approval sources drop with the rows. Check nothing is left referencing the DDQ id.
- The assistant gets no delete tool, so the assistant token is refused, like release.

**Done when:** an Admin deletes an unsent test DDQ with a reason; it's gone from the register, its files are gone from storage, Activity has the line, the library keeps its entries with "DDQ-n (deleted)"; a Sent DDQ, a non-admin and the assistant are all refused.