---
id: 01M411KBWR8JGZF8WWV84TA4FA
created: 2026-10-03T14:10:00.216508Z
updated: 2026-10-03T14:10:54.107659Z
type: task
title: 'Git-sync on Windows: Git for Windows detection, hidden console, SSH agent, CRLF'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 501
sprint: sw66q9v
assignee: steve
label:
- brief
- feature
priority: medium
task_status: backlog
tech: null
---
So that git-sync (ADR 0013: system `git` shelled out) works on Windows without a console window flashing on every sync and with a clear message when git isn't installed. Everything spawns through `git::command()` (NOT-?/DEV-922), so there is one place to fix.

**Draft — re-plan after NOT-498 reports.**

## Proposed work

- [ ] `git::command()` sets `CREATE_NO_WINDOW` on Windows so background syncs never raise a console.
- [ ] Preflight: if `git` isn't on `PATH`, Settings → Sync says "Install Git for Windows" with a link, instead of the sync failing with a spawn error. Same check on Linux ("install git with your package manager").
- [ ] SSH: `ssh_multiplex_options()` already returns `None` off unix. Verify Windows OpenSSH agent and `GIT_SSH_COMMAND` behave; the credentials-vs-network explanation (NOT-405) still matches Git for Windows' wording.
- [ ] `core.autocrlf`: the vault repo is initialised with `autocrlf=false` so note files are byte-identical across machines; frontmatter parsing tolerates `\r\n` for files edited elsewhere.
- [ ] Paths: vault-relative references (attachments, xsync meta) are always written with `/`; Windows paths in `.notuvia/xsync.json` round-trip.
- [ ] Case-insensitivity: confirm nothing in the index or sharding depends on case (IDs are ULIDs — expected fine; verify).
- [ ] Tests for the spawn flags and CRLF tolerance; the rest is hands-on on a Windows machine.

## Notes

The semantic merge runs `git merge-file` over temp files (DEV-1014) — check temp-dir handling on Windows while here.