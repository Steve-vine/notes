---
id: 01M5FT3DFZKPNA17KZJ3GD3F7T
created: 2026-10-21T18:03:15.839103Z
updated: 2026-10-21T20:16:50.878678Z
type: task
title: The PDF library is updated past four security advisories published today
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1196
sprint: ss8348q
comments:
- id: 01M5FW8DW3VZGTTE4GSFZK7SZE
  author: Steve Vine
  at: 2026-10-21T18:40:57.218909Z
  text: |-
    Done — PR #1212, merged 21 Oct 19:40 BST (shared with COM-1197).

    - The PDF library Compass uses (pypdf) is now 6.20.1, past the four security advisories published today against 6.19.0. The dependency scan passes again, so PRs can merge.
    - Nothing changes in how PDFs look or behave. The PDF tests all pass on the new version.

    My call: I pinned 6.20.1, the oldest release that fixes all four, rather than the newest (6.21.2), which had been out for about an hour. A release that fresh hasn't had time to be checked by anyone else.
assignee: steve
label:
- chore
priority: high
task_status: done
---
Found 21 Oct 2026 while shipping COM-1193: the dependency scan now fails every PR because four advisories were published against pypdf 6.19.0 (CVE-2026-113792, -113793, -113794, -113795; fixed in 6.20.0 / 6.20.1). Compass uses pypdf to read and assemble PDFs.

**Change:** raise pypdf to 6.20.1 or later. No behaviour change expected.

**Done when:** the dependency scan passes on main and open PRs can merge again.