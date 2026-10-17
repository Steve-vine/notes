---
id: 01M52FSABM0Z161GSGYGGA6ZBH
created: 2026-10-16T13:52:51.572644Z
updated: 2026-10-17T01:56:06.878204Z
type: task
title: The assistant can link assets to risks and decisions, and answer a finding — accept it with a reason, or raise a risk from it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1029
sprint: sfzoxya
blocked_by:
- 01M52FQBGZ8WV65TRK7VZPWZ63
- 01M52FQSCS4ZH4WYQ1J8W56770
- 01M52FR3FCHV0KR7CN5X51XM7M
comments:
- id: 01M53S5MHNTYH0AG5A9BGPQNRV
  author: Steve Vine
  at: 2026-10-17T01:56:06.8377Z
  text: |-
    Done — merged to main (PR #1027). Goes to staging with the rest of sprints 73 and 74.

    What the assistant can now do, for a named company:
    - Read what an asset (technology, data or software) is linked to: its risks, the decisions that apply to it, and — for a technology asset — its findings (open, accepted with who and why, or risk raised).
    - Link a risk to any asset, or unlink it (asks first).
    - Link a decision to an asset, or unlink it — through the existing decision tools, which now accept a technology, data or software asset (named by reference or name, with the company).
    - Accept an open finding with a reason, optionally under a decision ("accept the public-bucket finding on AST-12 under D-8").
    - Raise a risk from a finding — needs the right to manage risks as well as the register, as on screen. The finding becomes the risk's event and the asset's owner its owner.
    Tested with the fake AWS account: a public website bucket under AST-1 raises a finding; accepting it under D-1 is recorded in Activity via assistant; the risk raised from it appears in the register and on the asset.

    Finding text can quote cloud text, so it's flagged as possibly untrusted, like other discovery text.

    Note: choosing a risk to link reads the risk register, so it needs Posture's view right — the same as the risk picker on screen.

    My call: a finding is named by words from what it says or the resource it's about; only open findings can be accepted or turned into risks.
assignee: steve
label:
- feature
priority: medium
task_status: review
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