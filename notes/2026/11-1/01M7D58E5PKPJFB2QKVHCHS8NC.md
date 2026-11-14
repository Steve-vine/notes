---
id: 01M7D58E5PKPJFB2QKVHCHS8NC
created: 2026-11-14T13:51:55.062098Z
updated: 2026-11-14T14:05:15.275064Z
type: task
title: A collected check shows once in a control's Automated collection, under Evidence Compass collects, with one state word, and its own "still needs" words read as a sentence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1823
sprint: spsp226
comments:
- id: 01M7D60QQ1D69N1P29FA4J68NN
  author: Steve Vine
  at: 2026-11-14T14:05:11.265479Z
  text: |-
    Built — PR #1817 (caa04ba4), auto-merge on. Frontend only.

    What you now see: on a control's Evidence tab, Checks Compass runs lists only Compass's own built-in checks; a collected check (CHK-n), even one with a pass/fail rule, appears once under Evidence Compass collects with one state word, and the heading pill counts it once. On ACC.13, CHK-2 shows once (Broken) under Evidence Compass collects and Checks Compass runs says "Compass runs no checks on this control." — matching the Checks ▸ Overview side panel. The gap sentence now reads "CHK-2 Entra ID … tests part of this control. Still needed: Someone has to map role definition IDs … The rest still needs evidence, collected by Compass or provided by a person." (with several checks: "Still needed for CHK-n: …"); the side panel uses the same wording. VUM.1 / IDM.14 / IDM.13 read as before.

    Choices: the check's ID stays in front of its name, as in the rest of the section; a check's own words keep their capital letter (lower-casing would break names like Microsoft/Entra); the assessment queue's Checks card still lists collected checks as before (only the Evidence tab's card changed).

    Tests: new tests for a collected check with a rule on the Evidence tab and the side panel (listed once, no Can't tell beside it, "Compass runs no checks…", pill, no brackets); full vitest 4,167 passed; eslint/tsc/prettier clean.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
## What happened

Found in Claude's pre-UAT pass of COM-1821 on staging 53965a3b (2026-11-14), E2E Test Company, as E2E Admin A.

On ACC.13's **Evidence** tab, CHK-2 (a collected check that has a pass/fail rule) is listed twice in Automated collection:
- under **Checks Compass runs · 1 check**, with the pill Can't tell; and
- again under **Evidence Compass collects**, with the pill Broken.

The **Checks ▸ Overview** side panel for ACC.13 instead says "Checks Compass runs — Compass runs no checks on this control" and lists CHK-2 only under Evidence Compass collects (Broken). The two places disagree, and one check carries two state words.

Also, ACC.13's gap sentence puts CHK-2's whole "still needs" text in brackets mid-sentence: "CHK-2 Entra ID … (Someone has to map role definition IDs … cycle) tests part of this control…", which reads clumsily.

Screenshots: ~/compass-uat/spsp226/COM-1821/.

## What people see

- **Checks Compass runs** lists Compass's own (built-in) checks only. A collected check (CHK-n) appears only under **Evidence Compass collects**, even when it has a pass/fail rule, with one state word. Where it has a rule, its pass/fail result is that state (Passing / Failing / Can't tell); where it can't read, the reason. The heading's single pill counts it once.
- The Evidence tab and the Checks ▸ Overview side panel say the same thing for the same control.
- The gap sentence names each partial check by name, then a collected check's own "still needs" words follow as their own sentence ("Entra ID (Microsoft 365) directory role assignments tests part of this control. Still needed: someone has to map role definition IDs … The rest still needs evidence…"), not in brackets mid-sentence. Keep it readable when there are several.

## Done when

- On ACC.13 the Evidence tab lists CHK-2 once, under Evidence Compass collects, with one state word, and Checks Compass runs says "Compass runs no checks on this control."; the Overview side panel matches.
- The gap sentence reads as sentences, with no mid-sentence brackets.
- Controls with built-in checks only (VUM.1, IDM.14, IDM.13) read as they do now.
- Vitest for the Evidence tab and the side panel covers a collected check with a rule.

**Independent** (front end only). Fix-forward from COM-1821.