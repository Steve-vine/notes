---
id: 01M7JWM9AMRV0J6APDQW2Y2TT7
created: 2026-11-16T19:16:32.724698Z
updated: 2026-11-17T20:31:42.429472Z
type: task
title: 'Workflow builder wording: three phrases read wrongly'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1872
sprint: s7nqsy0
comments:
- id: 01M7MEYTATHHF5Y8P666NSF5GB
  author: Steve Vine
  at: 2026-11-17T09:56:06.61797Z
  text: |-
    Done — PR #1879, merged 44d15b9a.
    In the workflow builder, a new action you haven't chosen yet is titled "Choose an action", and an empty condition reads "If (choose a condition)". "Compass doesn't know…" now appears only for a block it genuinely doesn't recognise.
    The hint under "Name each … by" says "an item", "an account", "a policy".
    A captured-items rule reads as a sentence in every mode and test, for example "every repository has visibility that is public", "no repository has visibility that isn't public", "at most 1 role has admin that is true", "every group has at most 2 owners". Polaris's explanations use the same sentence.
    To check on staging: add a new action and condition to a workflow, and look at a captured-items rule's sentence on the canvas and in the sentence view.
- id: 01M7MGMT51VS0Z71XB6H831EAX
  author: Steve Vine
  at: 2026-11-17T10:25:35.905333Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Empty action or condition reads as a prompt to choose: Passed. As E2E Admin A in E2E Test Company I sent the builder a draft through the same reading the canvas uses (nothing saved). It held an empty condition, an empty action, and a condition and action of unknown kinds. They read "If (choose a condition)", "Choose an action", "If something Compass doesn't know" and "Do something Compass doesn't know", with the problems "Choose what to check" and "Choose what to do". So "Compass doesn't know…" now shows only for blocks it really doesn't recognise. Polaris's draft (staging MCP) reads the same. Blocks added from the palette always arrive with their kind, so on screen they're titled by what they do.
    - Item hint says "an" before a vowel: Passed. On WFL-2's builder I clicked the captured-items block and changed "One item is a" to each word in turn (not saved). The hint read "The field that names an item…", "…names an account…", "…names a policy…", "…names an event…", and "…names a role assignment…" as saved.
    - A rule's sentence reads as plain English in every mode and test: Passed. I read all 14 tests in each of every, none, at most 1 and at most 3, with and without "where". Examples: "every repository has visibility that is public", "no item has visibility that isn't public", "at most 1 account has grant that contains mfa", "at most 3 items where archived is false have state that is one of a or b", "every repository has owner that is filled in", "every account has admin that is true", "every repository has at most 2 owners". The canvas, the Sentences view and Polaris's posture_get_workflow for WFL-2 all read "If at most 10 role assignments have roleDefinitionId that is 62e90394-… (if no role assignments are found, it isn't met)".
    - Tests pin the wording: not re-run here (they're in the PR's CI).
    Small things (not defects): a count test with 1 reads "has at least 1 owners". In the sentence view, when Yes and Otherwise lead to the same action, "Otherwise:" shows with nothing under it.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1872/
assignee: steve
label: null
priority: medium
task_status: done
---
Found in the pre-UAT pass of round 2 (staging 43d03f09). Three bits of builder wording read badly.

1. **"Do something Compass doesn't know"** is the title a brand-new, empty action gets before you've chosen what it does. It sounds like an error. It should read as an invitation, e.g. "Choose an action". The same goes for an empty condition ("something Compass doesn't know").
2. **"a item"**: the hint under the field that names each item in a captured-items rule says "The field that names a item…". It needs "an" before a vowel.
3. **"has visibility is public"**: a captured-items rule written as a sentence reads e.g. "every repository has visibility is public". It should read "every repository has visibility public" or "every repository where… has visibility that is public". The "no…" and "at most…" forms have the same problem.

**Done when**
- An empty new action or condition is titled as a prompt to choose one, not as something Compass doesn't recognise. "Compass doesn't know…" is kept only for a block that genuinely isn't recognised.
- The item hint says "an" before a vowel ("an item", "an account", "a policy").
- A rule's sentence reads as plain English in every mode (every, none, at most) and for every test (is, is not, contains, exists, true/false, counts). Polaris's explanations, which use the same sentence, read the same.
- Tests pin the new wording.

**Where** (for the builder): core/workflows/definition.py (`do something Compass doesn't know`, `something Compass doesn't know`), core/workflows/conditions.py `rule_words` / `test_words`, frontend workflows/builder/RuleEditor.tsx (`names a ${noun}`).