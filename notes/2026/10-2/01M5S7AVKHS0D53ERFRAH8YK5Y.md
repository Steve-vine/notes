---
id: 01M5S7AVKHS0D53ERFRAH8YK5Y
created: 2026-10-25T09:47:41.041102Z
updated: 2026-10-25T10:43:12.417232Z
type: task
title: 'DDQ: Polaris''s read of a DDQ doesn''t include its cover fields, so it can''t tell whether they''re filled in or approved'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1298
sprint: ssgnel8
comments:
- id: 01M5S9R5PQXM6JEMQX8SBTQKW7
  author: Steve Vine
  at: 2026-10-25T10:29:54.519128Z
  text: 'Another small one in Polaris''s reads, found on DDQ-4: `ddq_read_completed_placements` names each answer''s field by its kind ("Detail") rather than the client''s label ("Response"), although `ddq_get_question` shows "Response (detail) → Sheet1, C9". Use the field''s label in the read-back so it matches the client''s file. The file itself is unaffected, because only values are written.'
- id: 01M5SAGGX1XPQJJX0CQAAYAM95
  author: Steve Vine
  at: 2026-10-25T10:43:12.417008Z
  text: '**Changed by COM-1303:** cover fields become ordinary questions, so `ddq_get_ddq` reports them through its normal question counts and lists. The separate cover-field listing here isn''t needed if COM-1303 lands first. The "Detail" vs "Response" label fix in the placements read-back still stands.'
assignee: steve
priority: low
task_status: todo
---
## What happened

On DDQ-4, Steve had filled in the cover fields on screen ("Company Name": Moneypenny, "Completed by": Steve Vine). Polaris told him they were empty. Its read of the DDQ (`ddq_get_ddq`) says nothing about cover fields, and the only place that shows them is the completed-file read-back.

## Behaviour

- Polaris's read of a DDQ lists each cover field: its label, where it goes, what it says (or "not filled in"), and whether it is approved.
- Its "where it stands" summary counts them ("2 cover fields: 2 filled in, 0 approved"). When they're why the DDQ isn't ready to send, it says so: "Not ready to send: 29 answers and 2 cover fields still to approve."

## Implementation notes

- `assistant/tools/ddq.py` `ddq_get_ddq`: add `cover_fields` from `core/ddq_layout.cover_fields`, and the counts `ddq_review` already computes (`cover_fields`, `cover_fields_approved`) to `where_it_stands`.
- Update the tool description.
- Independent: tool output only, no API change.
