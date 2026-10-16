---
id: 01M52GY5TNNT0MAM8EZMW8HSJW
created: 2026-10-16T14:12:59.349566Z
updated: 2026-10-16T21:11:36.924504Z
type: task
title: The assistant can read and change the vendor Register — each vendor's record, owners, flags and what's wrong with its compliance
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1034
sprint: shcfcmf
blocked_by:
- 01M52GXRD19J5YDMJYRRZYE8Y1
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 73, MCP - Vendor Management (ADR in COM-1033). **Do this one first.** Every other vendor task finds vendors through the lookup it adds.

## What people can ask of it

- **Read (for a named company):**
  - **the register**, filtered as on the tab:
    - Needs attention, Critical risk, High risk, Requested;
    - state, compliance, criticality, risk tier, access rung, flag, and name;
  - **a vendor in full**, as the top of its page shows it:
    - website, what it provides, notes and review cadence;
    - owner and co-owners;
    - state and compliance;
    - criticality and risk tier, and the engagement each comes from;
    - **what's breaking its compliance rules, and how to fix each**;
    - the assets it supplies, receives or publishes;
    - its history;
    - the conversation from its requests.
- **Write (whatever the person's role allows on screen):**
  - add a vendor;
  - edit one: name, website, description, notes, review cadence, owner and co-owners;
  - raise its criticality above what is worked out (admins, as on screen);
  - **transfer ownership** (the main owner, as on screen);
  - assign flags, and create, recolour or delete flags.
- **Example:** "Which critical vendors need attention, and why?" Then: "make Priya a co-owner of Acme Payroll."

## Notes (technical)

- Wraps `vendors.py`:
  - list, counts, get, assets, compliance-violations, revisions, messages, POST, PATCH, and transfer-ownership.

  Also wraps `vendor_flags.py`, and reads the shared rubrics (`/criticality-levels`, `/vendor-risk-tiers`, `/vendor-access-levels`) so values can be named.
- **Shared lookup in `tools/common.py`: `find_vendor(company, name_or_id)`.** Match the exact name first, then words. Refuse with up to 10 candidates rather than guessing. Every other vendor task reuses it.
- `criticality_override` is an admin-only field on the PATCH. Leave it in the update tool, and let the route refuse non-admins with its own message.
- Flag delete is `destructive`.
- Add a Vendor Management paragraph to INSTRUCTIONS:
  - vendor → engagements → criticality and risk tier;
  - compliance earned by review;
  - requests and approvals;
  - questionnaires go to the supplier's compliance contacts;
  - everything is per company.
- New module `tools/vendors_register.py`.
- Tests:
  - name lookup refuses ambiguity;
  - writes are hidden without manage-register;
  - transfer is refused for a non-owner;
  - an edit is recorded via assistant.

**Done when:** on staging, the assistant lists the vendors needing attention with the reason for each, and adds a co-owner to one. The vendor's History shows the change via assistant.