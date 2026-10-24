---
id: 01M5PYSB1SZVP0E9MEEPDBXKCA
created: 2026-10-24T12:39:49.561284Z
updated: 2026-10-24T12:39:54.091679Z
type: task
title: The assistant finds and words each DDQ answer itself — it reads everything Compass holds for the company, each item with whether it can be given on this DDQ, and Compass judges what it cites (ADR 0125 amendment)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1281
sprint: ssgnel8
assignee: steve
priority: medium
task_status: todo
---
Found running DDQ-3 through the assistant, 2026-10-24. For question 4 (recovery time objective), Compass's source finder offered the BC/DR policy and BCR.12, but also privileged admin access, change management and disabling unused services — it matches on shared words, not meaning.

**Steve's direction:** "the assistant needs to be responsible for finding the answer to the question and wording it as well, rather than Compass' built in logic again."

**Decision (ADR 0125 amendment):**
- The assistant decides what is relevant and writes the answer. To do that it can see everything Compass holds for the company that could answer a DDQ — library answers, policies and standards in full, controls, the company's control assessments, evidence and trust centre documents — each with its classification and whether it can be given on this DDQ.
- Compass still decides what can go out. The sharing rules, the NDA position, the answer's classification following its sources, held back, and release by an Admin only all stay as they are; the assistant can't get round them. Compass checks that every cited source exists and that the evidence is the company's own.
- Compass's word-matching finder stays on screen for people working without an assistant, not tuned further.