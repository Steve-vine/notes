---
id: 01M5PYC6K8BW378MTHCTAN2KMY
created: 2026-10-24T12:32:39.01654Z
updated: 2026-10-24T12:34:08.990458Z
type: task
title: 'ADR 0125: the assistant reads a DDQ''s layout — each question carries whatever the client''s form has (their guidance, the answers they allow, an evidence list, other fields) and the questionnaire''s own cover fields, each written back to its place'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1280
sprint: ssgnel8
comments:
- id: 01M5PYEYEYKX7ZV284THBN6FEE
  author: Steve Vine
  at: 2026-10-24T12:34:08.990122Z
  text: 'ADR 0125 written: decisions/0125-the-assistant-reads-a-ddqs-layout.md, PR #1291 (auto-merge on). ADR 0124''s header points to it. Seven calls listed in the ADR for Steve to confirm: column set-up stays; fields approved together; evidence list filled by Compass and never names held-back evidence; guidance never written back and shown to assignees; cover fields approved and required before sending; existing questions migrate to Response/Detail fields; draft completed file from set-up onwards.'
assignee: steve
priority: medium
task_status: todo
---
Found running DDQ-3 (Test 3, Test Company) through the assistant, 2026-10-24.

**What happened.** The client's spreadsheet has a reference column, the question, a Response column, a column of their own guidance notes for each question, and a "List of Evidence Attached" column, plus "Company Name" and "Completed by" at the top. Compass's column set-up guessed the guidance column as the place for our answers (it would have written over the client's text), had nowhere to keep the guidance, no place for the evidence list, and no place for the cover fields. A question the assistant adds by hand can't say where its answer goes at all.

**Steve's direction.** Built-in logic to interpret questionnaires will never be perfect — tuning it to this file just moves the problem to the next one. Rely on the AI to decide what the questions are, what answers are allowed, what guidance there is and what other fields there are. Improve the assistant's tools (Claude Code over the MCP for now; a built-in agent later uses the same tools) and make a DDQ open enough to hold what the AI finds.

**Decision — ADR 0125** (amends ADR 0124 §7, §9, §12, §16):
- The assistant reads the layout and tells Compass each question, its section, the client's guidance, the allowed answers and every field and where it goes. Compass checks each place is writable and records it. The on-screen column set-up stays for people working without an assistant.
- A question has any number of fields, each with the client's label, a kind (response, detail, evidence list, other) and its place in their file.
- The client's guidance is shown to whoever answers (assignees too) and never written back.
- An evidence list field is filled by Compass from the evidence going out with the answer — only what can be given.
- Cover fields ("Company Name", "Completed by") belong to the DDQ, each with its place, approved like an answer.
- The assistant can correct its own set-up and read back the completed file before anything is sent.

The build is split into tasks once the DDQ-3 walk-through is finished, so it covers everything found on the way.