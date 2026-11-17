---
id: 01M7JWM9AMRV0J6APDQW2Y2TT7
created: 2026-11-16T19:16:32.724698Z
updated: 2026-11-17T09:56:10.179924Z
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
assignee: steve
priority: medium
task_status: review
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