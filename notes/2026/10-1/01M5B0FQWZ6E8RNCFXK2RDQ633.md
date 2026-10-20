---
id: 01M5B0FQWZ6E8RNCFXK2RDQ633
created: 2026-10-19T21:18:39.007896Z
updated: 2026-10-20T18:05:46.092078Z
type: task
title: Fulfil lists the systems that hold this kind of person, from Inventory — the handler marks each searched, corrected, erased, restricted or not held, or kept because the law requires it, adds any Inventory misses, and records what was given to the person and how
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1137
sprint: ss8348q
blocked_by:
- 01M5B0F9ASA7XXNWZMPA3R97NY
comments:
- id: 01M5BF19VNRN2DV8366SG8M1KV
  author: Steve Vine
  at: 2026-10-20T01:32:54.517066Z
  text: |-
    Done — merged (PR #1132).

    - When the first part worked system by system is granted or partly granted, the Fulfil area lists the company's data assets that hold the request's kind of person. Each line shows the technology assets holding it (primary, then standby, then backup) and the data asset's owner, as who to ask. Decommissioned assets are left out.
    - Data held as a processor shows "Held for a customer: their request, not ours", unless the request came from a customer.
    - **Refresh from Inventory** adds new data assets and updates names, systems and owners. A line no longer in Inventory is dropped — unless something was recorded against it, in which case it stays, marked "No longer in Inventory".
    - **Add a system** takes a technology asset or a typed name, with a link suggesting adding it to Inventory. Added systems can be taken off; lines from Inventory can't (record Not held instead).
    - Each line records an outcome per granted part, from the task's table, with a note, who and when; each outcome asks for what it needs (a reason, a kept-until date, a backup's age-out date, or the reviewer and result). Progress shows, e.g. "1 of 2 systems recorded".
    - **What was provided** (access and portability): description, number of files, formats, how and when delivered; portability adds the machine-readable tick and "sent straight to another organisation"; HIPAA access adds the form and format asked for. No upload anywhere.
    - The **Erasure record** lists lines marked "Kept — the law requires it" or "Put beyond use", with their dates.

    My calls: Inventory doesn't record which customer a processor-held data asset belongs to, so any request forwarded by a customer clears the processor flag; an automated decision can also be "Not used here" (otherwise every system would need a reviewer); opt-out of sale uses the objection outcomes; a request with parts to work and an empty systems list doesn't count as complete for closing.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 79, Data Privacy (ADR in COM-1129). Steve decided the handler does the fulfilment themselves; no tasks go to system owners.

## What people see

A **Fulfil** card, for each granted or partly granted part.

**The systems list.** Compass finds the company's **data assets** whose data entities include the request's kind of person (e.g. Caller), and lists each with the **technology assets** that hold it (primary, standby, backup) and the data asset's owner, as a reference for who to ask. Data assets we hold **as a processor** for a customer are flagged: "held for a customer: their request, not ours", unless the request came from that customer.

For each line, the handler records an **outcome** for each part:

| Part | Outcomes |
|---|---|
| Access, portability | Searched, found · Searched, not held · Kept back (reason) |
| Correction | Corrected · Not held · Not corrected (reason) |
| Erasure | Erased · Not held · Kept, law requires it (reason and until when) · Put beyond use (a backup that will age out, with the date) |
| Restriction | Restricted · Not held |
| Objection, marketing opt-out | Stopped / suppressed · Not held |
| Automated decision | Reviewed by a person (who, and the result) |

Each outcome has a note, who recorded it and when. The handler can **Add a system** that Inventory doesn't know about: a typed name, or any technology asset. Compass suggests adding it to Inventory, with a link.

**What was provided** (access and portability):

- what was given: a description, the number of files and the formats;
- for portability, a tick for **structured, commonly used, machine-readable**, and whether it was sent straight to another organisation at the person's request;
- how it was delivered (secure link, encrypted email, post, collected in person) and when.

For HIPAA access, record the form and format the person asked for.

The card shows progress: "7 of 9 systems recorded".

## Rules

- **Compass doesn't keep the person's data.** There is no upload here for the response pack. Compass records what was sent, not a copy of it (ADR). The handler sends it from the privacy mailbox (Steve's decision on letters).
- Every line needs an outcome before the request can close (Close task).
- An erasure line marked Kept or Put beyond use shows in the request's **erasure record**: the deletion and retention evidence auditors ask for.

## Notes (technical)

- The list is built from `DataAsset.data_entities` → `DataAssetContainer` → technology assets; `processing_role` gives the processor flag. A snapshot of the list is taken when Fulfil opens, with **Refresh from Inventory** to pick up changes.
- Fulfilment line rows: data asset id or technology asset id or typed name, plus an outcome per part.

**Done when:** a request for a kind of person lists the matching data assets and their systems; the handler records outcomes per part, adds a missed system, and records what was provided; processor-held data is flagged.