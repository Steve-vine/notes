---
id: 01M5FT3DFZKPNA17KZJ3GD3F7T
created: 2026-10-21T18:03:15.839103Z
updated: 2026-10-21T18:03:23.909747Z
type: task
title: The PDF library is updated past four security advisories published today
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1196
sprint: ss8348q
assignee: steve
label:
- chore
priority: high
task_status: active
---
Found 21 Oct 2026 while shipping COM-1193: the dependency scan now fails every PR because four advisories were published against pypdf 6.19.0 (CVE-2026-113792, -113793, -113794, -113795; fixed in 6.20.0 / 6.20.1). Compass uses pypdf to read and assemble PDFs.

**Change:** raise pypdf to 6.20.1 or later. No behaviour change expected.

**Done when:** the dependency scan passes on main and open PRs can merge again.