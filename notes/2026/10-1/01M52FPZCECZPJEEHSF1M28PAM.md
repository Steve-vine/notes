---
id: 01M52FPZCECZPJEEHSF1M28PAM
created: 2026-10-16T13:51:34.798261Z
updated: 2026-10-16T13:51:37.575982Z
type: task
title: 'ADR: the assistant reaches Inventory — the three registers, discovery and its settings, as the person, with cloud keys and secrets kept on screen'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1023
sprint: sfzoxya
assignee: steve
label:
- brief
priority: high
task_status: todo
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

**Done when:** the record is accepted and the tasks below match it.