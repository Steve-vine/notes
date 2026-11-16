---
id: 01M7JWM9AMRV0J6APDQW2Y2TT7
created: 2026-11-16T19:16:32.724698Z
updated: 2026-11-16T19:16:32.724698Z
type: task
title: 'Workflow builder wording: three phrases read wrongly'
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1872
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