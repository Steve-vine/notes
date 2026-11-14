---
id: 01M7CRW6KZ2Z28KSFVXVK23JJX
created: 2026-11-14T10:15:36.008211Z
updated: 2026-11-14T10:22:58.218786Z
type: task
title: 'A control''s Automated collection section says one thing once: the checks Compass runs, the evidence it collects, and what''s still not covered, in plain words'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1821
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
![CleanShot 2026-11-14 at 10.14.55@2x.png](attachments/2026/11/01M7CRW6KZ2Z28KSFVXVK23JJX/CleanShot-2026-11-14-at-10.14.55@2x.png)

## What happened

On 2026-11-14 Steve opened a control's **Evidence** tab ("Automated systems are in place to identify and deploy operating system patches…", screenshot above). The **Automated collection** section has:
- a **Checks** card: the built-in check "Software is in support", Failing, with its detail line; and
- below it, a **Collected by Compass** card: "Partly automated · Failing" (the same pill as the section heading), "Still needs a person: Compass tests part of this control itself; the rest needs evidence of its own", "A built-in check covers it. Compass doesn't collect evidence for it yet", then Ask Polaris to collect this and Mark as manual only.

He couldn't tell what the second card was telling him. It means: one built-in check tests part of the control and is failing, and no evidence is being collected for the rest. It reads badly because:
1. "Partly automated · failing" appears twice (section heading and card).
2. A card titled "Collected by Compass" says Compass collects nothing.
3. "Still needs a person…" is generic and doesn't say which part is tested and which isn't.
4. "Failing" reads like collection is broken, when it's the built-in check's result.

## What people see

One section with one status and two plainly named parts:

1. **Heading:** "Automated collection" with a single pill, spelled out: "Partly automated · a check is failing". Other combinations follow the same pattern ("Fully automated · all passing", "Partly automated · can't read", "Not automated"). The pill appears nowhere else in the section.
2. **Checks Compass runs:** today's Checks card, unchanged: each check with its state, detail line and Run now.
3. **Evidence Compass collects:** each collected check (CHK-n) for this control, as the lower card shows them today. With none, it reads "Nothing collected yet", followed by **Ask Polaris to collect this** and **Mark as manual only**. A control marked manual only shows its reason here.
4. **One sentence about the gap** (only when partly automated), naming the check: "Software is in support tests part of this control. The rest still needs evidence, collected by Compass or provided by a person." With several partial checks, it names them all. A check's own "still needs a person" words, where it has specific ones, follow its name.
5. The words "Collected by Compass" and "A built-in check covers it. Compass doesn't collect evidence for it yet" go.
6. The Checks ▸ Overview side panel for a control uses the same words and the same single pill.

## Done when

- On the screenshot's control, the section shows one pill ("Partly automated · a check is failing"), a Checks Compass runs part with Software is in support, an Evidence Compass collects part reading "Nothing collected yet" with Ask Polaris to collect this and Mark as manual only, and the one gap sentence naming the check.
- No status pill is repeated, and no "Collected by Compass" title is left on the Evidence tab.
- Fully automated, can't-read, manual-only and not-automated controls read correctly in the same layout.
- Vitest for the Evidence tab section covers those cases.

**Independent** (front end only: the words and layout in `control/EvidenceTab.tsx` and `collection/CollectionCard.tsx`, plus the Overview side panel in `checks/CoverageTab.tsx`).