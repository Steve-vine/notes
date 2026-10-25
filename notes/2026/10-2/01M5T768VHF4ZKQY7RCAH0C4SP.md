---
id: 01M5T768VHF4ZKQY7RCAH0C4SP
created: 2026-10-25T19:04:25.201316Z
updated: 2026-10-25T19:05:22.099696Z
type: task
title: 'DDQ: "Send via Trust Centre" — the contact (and colleagues) get a fresh visitor link by email, the completed file and evidence go into their own area, and the DDQ is marked sent'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1322
sprint: snfoon1
blocked_by:
- 01M5T75ASA5Q04YVFSBVFD2J8Y
assignee: steve
label:
- feature
priority: high
task_status: todo
---
## Behaviour

- **Where:** in the DDQ's Completed card, beside "Download completed file" and "Download evidence pack". It's there when:
  - the DDQ is **Ready to send**, or already **Sent**;
  - Questionnaires through the Trust Centre is on (COM-1318), and the portal is on and has its address;
  - the person can manage DDQs **and** manage Trust Centre visitors.

  Otherwise the button is greyed out with the reason ("The Trust Centre is switched off", "You can't invite Trust Centre visitors").
- **The window:**
  - **Who to send it to:** the DDQ's contact, pre-filled. **Add someone** takes a name and email. An address at a different domain from the contact's gets a warning, but isn't blocked.
    - Each person who is **already a visitor** of this company shows "Already a visitor — access until 24 Nov". They're reused, keeping their history and NDA acceptances.
    - Anyone else becomes a **new visitor**: organisation = the requester, reason "DDQ-12".
  - **Access until:** the company's usual link length. A visitor whose access already runs later keeps the later date.
  - **What they'll get:**
    - the completed file by name ("Acme DDQ 2026.xlsx");
    - the evidence files (count and names);
    - for an email or pasted questionnaire: "Questions and answers (spreadsheet)", the same record an Online DDQ produces;
    - how many items are held back and won't be included (as the pack summary says today).
  - **A note:** optional, added to the email.
  - On a DDQ that isn't sent yet: "This marks DDQ-12 as sent — it can't be changed afterwards."
- **On Send:**
  - **If it isn't sent yet, it's marked sent** exactly as Mark as sent does: the snapshot, the completed file and the evidence pack stored as they went. How: "Shared through the Trust Centre with jane@acme.com, bob@acme.com". The evidence pack is built and stored now, so nobody has to download it first.
  - **Each person gets a fresh link by email** from the company's Trust Centre sender: "Your completed questionnaire from Moneypenny is ready". The email includes the note, and says they'll be asked for a code. For an existing visitor, the new link replaces their old one, as Resend does today.
  - **Their Questionnaires area shows the DDQ as Completed** with its files (COM-1323 serves them). If the client sent this questionnaire in through the portal, it's the same entry, now Completed.
  - **History** on the DDQ: "Sent via the Trust Centre to Jane Smith, Bob Jones". Each visitor's row gets "Shared DDQ-12".
- **Sharing a sent DDQ again** (for example, another colleague asks) uses the same window. It adds people and doesn't touch the sent record.

## My calls (awaiting Steve)

- **Both permissions are needed**, because sending invites people from outside.
- **A different email domain is warned about, not blocked.** Clients sometimes use a parent company's address.
- **Email and pasted questionnaires go back as a questions-and-answers spreadsheet.** A file in the portal is more use to them than reply text.
- **Sending through the Trust Centre builds and stores the pack itself.** There's no "download it first" step, because what's shared is exactly what's stored.
- **An existing visitor's old link stops working** when they get the new one (one live link per visitor, ADR 0120 §5).

## Notes

- **On the chain:**
  - migration: `trust_centre_ddq_shares` (ddq_id, visitor_id, shared_at, shared_by_id/name, stopped_at, stopped_by…), unique (ddq, visitor) while live;
  - API: `POST /api/v1/ddqs/{id}/trust-centre/send` and a preview `GET …/trust-centre/send-preview`.
- Mark-sent goes through `core/ddq_sent` with a new `via_trust_centre` path that builds and stores the pack (`ddq_packs`) instead of requiring a downloaded one. For an email format, also build the online-style record as the `sent_copy`.
- Inviting and reusing go through `core/trust_centre_visitors` (one live link per visitor; Resend semantics for existing visitors). The email is a new template through the trust centre sender. Refuse while the host value is unset, as invitations do.
- Run the full DDQ file test set before pushing (memory: ~200 tests, ~5 min), since this touches sending.
