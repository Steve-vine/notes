---
id: 01M411JBTD8X35E8Q0AF5YFSGG
created: 2026-10-03T14:09:27.373785Z
updated: 2026-10-03T14:10:44.683074Z
type: task
title: Watcher behaves the same on inotify and ReadDirectoryChangesW; tests run on Linux
project: 01KY6W9951TW0904DT0GGJVGE7
number: 499
sprint: sw66q9v
assignee: steve
label:
- brief
- tech_debt
priority: high
task_status: backlog
tech: null
---
So that external edits to the vault (git-sync pulls, another editor, CrossSync copy-ins) are picked up on every platform. ADR 0016 carved the `test` job out to macOS because three watcher tests encode FSEvents semantics — recursive watching of not-yet-created subdirectories and one event per write — that don't hold under Linux inotify (DEV-676, never resolved). That is a runtime behaviour gap, not just a test one; the three-platform world has to close it.

**Draft — re-plan after NOT-498 reports.**

## Proposed work

- [ ] Characterise the three failing tests under inotify and under ReadDirectoryChangesW (Windows): which assumptions fail, and whether the app misbehaves the same way.
- [ ] Watcher contract: it is told about the vault root once and reports "this note's file changed" regardless of how many raw events, in what order, the OS emitted. Month-bucket folders (ADR 0041) that appear after the watcher started must be covered on all platforms — either watch recursively where the OS supports it or re-arm on directory creation.
- [ ] Tests assert outcomes (the index reflects the write) rather than event sequences, so one suite passes on all three.
- [ ] `ci.yml` `test` job moves to a three-leg matrix; the ADR 0016 carve-out comment goes.
- [ ] CrossSync's watcher on originals (NOT-494) gets the same treatment.

## Notes

The `notify` crate already abstracts the backends; the debouncer is `notify-debouncer-full`. The question is whether our event handling leans on macOS-only shapes, not whether the backend exists.