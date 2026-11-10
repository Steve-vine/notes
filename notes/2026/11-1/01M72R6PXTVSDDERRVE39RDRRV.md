---
id: 01M72R6PXTVSDDERRVE39RDRRV
created: 2026-11-10T12:51:22.682605Z
updated: 2026-11-10T12:52:32.139372Z
type: task
title: SOC 2 audit working notes — an audit/ folder in the repo, and CLAUDE.md points sessions to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1668
assignee: steve
label:
- chore
priority: medium
task_status: review
---
Moneypenny is working towards SOC 2 Type 2: Carbide (CarbideSecure) for readiness, A-LIGN (A-SCEND) as the auditor. Claude Code sessions need one place to find how to reach both and what's been done.

**Independent** (no migration, no API change). Docs and a script only.

- `audit/README.md`: who's who, how to reach CarbideSecure (claude.ai connector) and A-SCEND (REST API: token audience `https://heimdall/`, capital-B Bearer, `strict=False` JSON, page past the wrong `count`), the three-step evidence upload, the engagement (id 5639750625642030369), and a dated log. No credentials, only where they live (`~/creds/a-scend.txt`).
- `audit/a-scend.py`: read-only helper that lists engagements/requests.
- `CLAUDE.md`: "Where to read first" points anything about the real audit to `audit/README.md`.

**Done when:** merged to main. A new session reading CLAUDE.md is sent to `audit/`, and `python3 audit/a-scend.py requests` lists the engagement's requests.