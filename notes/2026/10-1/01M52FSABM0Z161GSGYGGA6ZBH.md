---
id: 01M52FSABM0Z161GSGYGGA6ZBH
created: 2026-10-16T13:52:51.572644Z
updated: 2026-10-16T13:54:07.603284Z
type: task
title: The assistant can link assets to risks and decisions, and answer a finding — accept it with a reason, or raise a risk from it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1029
sprint: sfzoxya
blocked_by:
- 01M52FQBGZ8WV65TRK7VZPWZ63
- 01M52FQSCS4ZH4WYQ1J8W56770
- 01M52FR3FCHV0KR7CN5X51XM7M
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 74, MCP - Inventory (ADR in COM-1023). Built on COM-1024, COM-1025 and COM-1026.

ADR 0109 §5 had the assistant read these links but not make them. COM-1023 opens that up for Inventory: the links are made the same as on screen.

## What people can ask of it

- **Read:**
  - the risks linked to any technology, data or software asset;
  - the decisions linked to it;
  - a technology asset's **findings**: what discovery noticed (for example "a database with backups kept under a week"), which are open, and how each closed one was answered.
- **Write (whatever the person's role allows on screen):**
  - **link an asset to a risk**, or unlink it;
  - **link a decision to an asset**, or unlink it. This extends the assistant's existing decision-linking, which today covers controls, risks and content.
  - **accept a finding** with a reason, optionally citing the decision behind it;
  - **raise a risk from a finding.** As on screen, this needs Inventory's register grant and the right to manage risks. The new risk lands in that company's risk register, linked to the asset.
- **Example:** "Which open findings are on production assets? Accept the backup ones on AST-12 under decision D-8. Raise a risk for the public bucket."

## Notes (technical)

- Wraps:
  - `/{containers|data-assets|software-assets}/{id}/risks` GET, POST, DELETE (manage-register);
  - `findings.py` accept and raise-risk. raise-risk needs both manage-register and `posture.manage_risks`, so declare both.

  Findings are read from the technology asset's own payload; there is no list route.
- **Decisions:** widen `TargetKind` in `tools/decisions.py` to `technology_asset`, `data_asset` and `software_asset`, mapping to `container`, `data_asset` and `software_asset`. `POST /decisions/{number}/links` already accepts them. Resolve the target through `find_asset`.
- Risks resolve through `find_risk`, and decisions through the existing decision lookup.
- Unlinks are `destructive`. Accepting a finding is a write, not destructive. The tool's description says what accepting does, as the route defines it (ADR 0099 §10 as amended by COM-888).
- Finding text that quotes cloud tags is untrusted (COM-1023).
- New module `tools/inventory_links.py`, plus the `decisions.py` change.
- Tests:
  - raise-risk is hidden without manage-risks;
  - a decision links to a technology asset;
  - accept records the reason via assistant;
  - the raised risk appears on the asset's Risks section.

**Done when:** on staging, the assistant raises a risk from a finding, and the risk appears both in the Risk register and on the asset.