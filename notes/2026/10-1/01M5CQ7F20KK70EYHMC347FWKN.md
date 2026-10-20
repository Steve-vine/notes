---
id: 01M5CQ7F20KK70EYHMC347FWKN
created: 2026-10-20T13:15:19.488502Z
updated: 2026-10-20T20:49:00.275624Z
type: task
title: A visitor accepts the company's NDA before seeing restricted documents — once per wording, recorded with their name, the time and the exact wording, and asked again when the wording changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1163
sprint: sq3fav7
blocked_by:
- 01M5CQ74BZWHT0AQSAG1SS7NEE
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1162. The wording is kept in Settings (COM-1158).

## What people see

**On the portal:** if the company has NDA wording and the visitor has been given any restricted documents, those documents show as locked: "Accept the NDA to view". The visitor opens the NDA, reads it, ticks "I agree on behalf of Acme Ltd", types their name and accepts. The restricted documents unlock. Everyone-invited documents are never behind the NDA.

They can reopen what they accepted from the footer at any time.

When an admin saves new wording, everyone's restricted documents lock again until they accept the new version.

With no NDA wording set, restricted documents need only being given to the visitor.

**In the module:** each visitor shows "NDA accepted 20 Oct 2026, version 3", or "Not accepted". The acceptance can be downloaded as a one-page PDF: the wording, the visitor's name, email, organisation, typed name, date and time.

An acceptance is permanent; it can't be edited or deleted.

## Notes (technical)

- `trust_centre_nda_acceptances` (visitor, NDA version, typed name, organisation, accepted_at, IP and user agent). Insert-only. Audited.
- The document-access check from COM-1162 gains: restricted ⇒ (no current NDA) or (accepted the current version).
- The acceptance PDF through the ADR 0110 renderer.

**Done when:** a visitor must accept before opening a restricted document, a wording change asks again, and the acceptance PDF downloads from the visitor's row.