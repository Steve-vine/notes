---
id: 01M52FPZCECZPJEEHSF1M28PAM
created: 2026-10-16T13:51:34.798261Z
updated: 2026-10-16T23:58:36.831678Z
type: task
title: 'ADR: the assistant reaches Inventory — the three registers, discovery and its settings, as the person, with cloud keys and secrets kept on screen'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1023
sprint: sfzoxya
blocked_by:
- 01M52D91MBAZ225T7KZ5N06YNV
comments:
- id: 01M53JEFGZAB9H7F0DWMS946MQ
  author: Steve Vine
  at: 2026-10-16T23:58:36.575583Z
  text: |-
    Done — ADR 0113 "The assistant reaches Inventory" merged to main (PR #1021). It amends ADR 0109's scope (Inventory is in) and §5 (assets link to risks and decisions, and a finding can raise a risk). 0109's other sections stand.

    Recorded as written in this task, plus two clarifications:
    - What's flagged "ask first": deletes, applying a discovery rule to everything already found (it decides many resources at once), and taking a connection or account out of discovery. Discarding a discovered resource is an ordinary write because it can be restored, and starting a recertification review now is too — the same as Access Control.
    - The connection tools also don't call the setup pages that show the values a cloud admin pastes into their console (they carry the AWS external ID).

    My calls still awaiting your confirmation (all in the ADR): links into risks and decisions as on screen; no CSV import; recertification evidence as a link; tags, labels and AD descriptions returned marked as untrusted; switching an organisation account on with its own key stays on screen; no new grant; the Portal's Inventory tab and Compass's own AWS identity out; tools follow the screens as built today.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 74, MCP - Inventory. Scoped with Steve on 2026-10-16. This record is the first task, and the rest wait for it. It follows sprint 72's record for Access Control (COM-1012), which is written first and settles the shared rules for bringing a module in.

Sprint 70 (ADR 0109) connected an AI assistant to Overview, Playbook and Posture. Sprint 72 adds Access Control. This sprint adds **Inventory** under the same rules: the assistant acts as the person, does exactly what their role allows on screen, and every change is marked "via assistant".

## What Steve decided (2026-10-16)

- **Every Inventory tab is in scope:** Technology assets, Data assets, Software assets, Discovered (with its Rules), and Settings.
- **Connections: everything except secrets.** For each AWS account and organisation, Azure subscription and tenant, Google project and organisation, and on-premises directory server, the assistant can:
  - see it, when it was last read, and what was blocked;
  - test it;
  - read it now;
  - refresh an organisation's list of accounts;
  - switch an account on, or leave it off.

  Three things stay on screen: **adding a connection, replacing its key or secret, and removing one.** A key typed into a chat is kept in that chat's history, outside Compass.

## What the record has to settle (Claude's calls, not confirmed by Steve)

- **Links into other areas are made the same as on screen.** ADR 0109 §5 had the assistant read a module's links but not make them, because the modules were out of scope. Now that Inventory is in, the assistant can:
  - link an asset to a risk;
  - link a decision to an asset;
  - raise a risk from a finding, if the person can also manage risks.
- **No CSV import.** It is a file upload (ADR 0109). Creating assets one at a time is in scope, and the assistant can do several in a row.
- **Recertification evidence is a download link**, as reports are.
- **What discovery brings back is untrusted.** Cloud tags, Google labels and AD descriptions are written by whoever manages that cloud or domain. The assistant is told they are data, never instructions, and the tools label them as such.
- **Switching an organisation's account on with its own key stays on screen.** That is the key rule again. Switching one on to be read through the organisation's own sign-in is fine.
- **No new grant**, as in COM-1012. The Inventory permissions decide which Inventory tools a person gets.
- **Out:**
  - the asset owners' Inventory tab in the Compass Portal;
  - Compass's own AWS identity, which is on Admin ▸ Integrations;
  - the CSV templates.
- **The tools follow the screens as they are when built.** "Inventory discovery - Software" and "Inventory review and tidy-up" are planned but not built. Whichever lands later extends the tools.

## Notes (technical)

- Write the next free `decisions/NNNN-*.md`. It amends ADR 0109's scope and §5 for Inventory, and leaves §1–§4 standing. Use the `inventory_` prefix and one `update_` per object.
- Credential-bearing bodies are never wrapped:
  - `secret_access_key` and `access_key_id` (AWS);
  - `client_secret` (Azure);
  - `key_file` (Google).

  Connection tools also omit `external_id` (the AWS confused-deputy guard) from what they return. The PATCH tools send only the fields that carry no secret.
- Mark untrusted fields in tool results, for example under a `from_the_cloud` key, and add a line to the INSTRUCTIONS text in `instance.py`. Add an Inventory paragraph there too: technology asset → data held → software → discovered resources, AST refs, and the per-company scope.
- About 45–55 tools across 10 tasks.

Tasks:
- COM-1024 Technology assets (first);
- COM-1025 Data assets;
- COM-1026 Software assets;
- COM-1027 access on assets;
- COM-1028 asset recertification (after sprint 72's COM-1019);
- COM-1029 risks, decisions and findings;
- COM-1030 Discovered;
- COM-1031 Rules;
- COM-1032 Settings and connections.

**Done when:** the record is accepted and the tasks below match it.