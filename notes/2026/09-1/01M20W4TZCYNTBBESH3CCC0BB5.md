---
id: 01M20W4TZCYNTBBESH3CCC0BB5
created: 2026-09-08T16:03:17.612245Z
updated: 2026-09-08T16:07:49.011558Z
type: task
title: 'Headless docs: `Restart=on-failure` breaks self-update, and per-session `--git-sync` multiplies syncers'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 418
comments:
- id: 01M20WD0MZTC38A49KJSXZNXYK
  author: Steve Vine
  at: 2026-09-08T16:07:45.567196Z
  text: |-
    Done — merged as 07b4fb9 (squash, PR #415). CI green (lint, test, typecheck); branch deleted.

    All four checklist items landed in `docs/mcp-server.md`:

    - `Restart=always`, with the reason as a comment inside the unit block rather than prose above it — that is where the mistake gets made.
    - New "Who owns sync" section splitting guidance by machine shape, and step 3 of the one-time setup now points at it *before* handing over a registration command, instead of giving a recipe that is wrong for a multi-session box.
    - The interval-tick trade-off stated plainly, and the unit's `--sync-interval` dropped 60 → 30 to match.
    - "Keeping the clone fresh between sessions" renamed to "The sync daemon" and no longer describes itself as merely optional; the "What to expect" bullets are now scoped to the single-session shape they were written for.

    One deviation from the checklist: I did not cross-reference NOT-417 in the doc. `docs/mcp-server.md` cites ADRs and nothing else, and per CLAUDE.md work-tracking ids don't belong in durable user-facing docs. The "ten instances, seven fetching concurrently" fact stands without the citation, and the traceability lives here and in the commit message instead.

    Still not done by this change: the Linux box itself. It needs `~/notuvia-mcp` redeployed off 0.21.0, the orphaned syncers killed, the systemd unit checked for `Restart=on-failure`, and the MCP registration re-pointed without `--git-sync`.
assignee: steve
label:
- bug
- follow_up
priority: high
task_status: done
tech:
- docs
- git-sync
---
Two defects in `docs/mcp-server.md`, both found while reviewing NOT-416.

## 1. The systemd unit contradicts ADR 0044

`docs/mcp-server.md:200` specifies `Restart=on-failure`. ADR 0044 line 59 says
units for `--sync-only` **must** set `Restart=always`, because self-update
exits *cleanly* (exit 0) for the supervisor to restart it (DEV-1007). With
`on-failure` the sync daemon stops permanently the first time it self-updates,
and does so silently — the clone simply stops being fresh. Anyone who copied
that block has a time bomb.

## 2. The registration recipe doesn't scale past one session

`docs/mcp-server.md:157` tells you to register the per-session MCP server with
`--git-sync --sync-interval 60`. That is right for a single session and wrong
the moment there are several: the MCP server is spawned per client session, so
N concurrent agent sessions means N sync workers against one vault. On the
Linux box that was ten, seven fetching at once — the amplifier on NOT-416.

The `--sync-only` section further down calls itself optional ("it isn't
required for agent use"), which is true only in the single-session case it
assumes. On a multi-session box it's the correct shape, not an extra.

## Agreed work

- [ ] `Restart=always` in the unit, with a line saying why (a clean exit after
      self-update is expected, so `on-failure` will not restart it).
- [ ] Split the registration guidance in two: single-session boxes keep
      `--git-sync` on the MCP registration; multi-session boxes run one
      `--sync-only` daemon and register the MCP server **without** it.
- [ ] State the trade-off honestly: the daemon commits another process's writes
      on its interval tick, not via the ~4s debounce, since the watcher has no
      path to the sync worker. Nothing is lost — the file is written
      synchronously; only the commit waits.
- [ ] Cross-reference NOT-417, which makes the single-owner rule a mechanism
      rather than a convention.
