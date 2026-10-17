---
id: 01M52GY5TNNT0MAM8EZMW8HSJW
created: 2026-10-16T14:12:59.349566Z
updated: 2026-10-17T07:52:16.217764Z
type: task
title: The assistant can read and change the vendor Register — each vendor's record, owners, flags and what's wrong with its compliance
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1034
sprint: shcfcmf
blocked_by:
- 01M52GXRD19J5YDMJYRRZYE8Y1
comments:
- id: 01M53AGCKJ2NXR94JM6KV3FR3D
  author: Steve Vine
  at: 2026-10-16T21:39:50.514063Z
  text: |-
    Done — merged to main (PR #1013). Not on staging yet: the whole of sprints 73 and 74 go to staging together at the end.

    What the assistant can now do, for a named company:
    - List the Register with the same quick filters (All, Needs attention, Critical risk, High risk, Requested) and filters as the tab, with the count behind each chip. Every vendor that needs attention says why — e.g. "compliance is Not assessed", "SOC 2 expires soon", "review overdue since 2026-09-01".
    - Read a vendor in full: details, owner and co-owners, state and compliance, criticality and risk tier and where each comes from, live engagements, the compliance rules it breaks with what to record to fix each, certification standing, next review, flags, and the assets it supplies, receives or publishes.
    - Read its History (each save says whether it came through the assistant) and the conversation from its requests.
    - Add a vendor; edit its details, main owner, co-owners and flags; raise its criticality (admins only, as on screen); hand over the main ownership (the main owner only); create, recolour and delete flags (delete asks first).
    - Read the shared rubrics (criticality, access, risk tiers) so it can pick the right word. It can't change them.

    A vendor's History now shows "· via assistant" beside the name on a save made through the assistant.

    Found while building, for you to decide (not changed):
    - Adding or removing a co-owner (or a flag) writes nothing to the vendor's History and nothing to Activity — that's how the screen has always worked. So the "Done when" check of "add a co-owner, see it in History via assistant" can't pass as written: the co-owner change is saved but leaves no trace. An edit such as notes or review cadence does show in History via assistant. If you want co-owner changes recorded, that's a small follow-up task.

    My calls: a vendor is found by its name (exact, then words), and an offboarded vendor only when nothing live matches; a new vendor shows "waiting for approval (Requested)" as a needs-attention reason, because a new vendor starts as Requested.
assignee: steve
label:
- feature
priority: high
task_status: done
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