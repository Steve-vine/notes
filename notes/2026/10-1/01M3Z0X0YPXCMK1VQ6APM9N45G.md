---
id: 01M3Z0X0YPXCMK1VQ6APM9N45G
created: 2026-10-02T19:19:19.254081Z
updated: 2026-10-02T19:19:31.088145Z
type: task
title: CrossSync core engine, plus ADR
project: 01KY6W9951TW0904DT0GGJVGE7
number: 492
sprint: sx287fa
assignee: steve
label:
- feature
priority: high
task_status: backlog
tech: null
---
So that Notuvia can keep files that live outside the vault (dotfiles, local config) in step across machines. This is the Tauri-free engine and its commands; the UI, watchers and git integration build on it.

## Agreed work

- [ ] ADR recording the CrossSync design: vault layout, the machine-local map, the three-way sync rule, the security posture (first link is explicit, later changes apply automatically with a backup), files only (no folders), and the deletion rules.
- [ ] Vault layout: `xsync/<id>/<filename>` plus `xsync/<id>/meta.yaml` (display name, original filename, the install id and a readable name of the machine that added it). One folder per file, so two machines adding files at once never conflict.
- [ ] Machine-local map in `<vault>/.notuvia/xsync.json` (ADR 0061): per file id, the local path on this machine and the sha256 at last sync. Never synced. Written atomically.
- [ ] New `xsync` module in `notuvia-core` with a pure sync-decision function over (local hash, vault hash, last-synced hash):
  - only local changed → copy in
  - only vault changed → copy out
  - both changed and different → conflict (no copy)
  - both changed to the same content → just record the hash
  - local file missing → "missing", never a deletion of the vault copy
- [ ] Operations: add (copy a picked file in and link it), link (set this machine's local path for an existing entry and copy out), unlink (forget the local path, leave both files), remove (delete the vault entry, never the local originals), list with per-file status, and sync one / sync all.
- [ ] Linking over an existing, different local file overwrites it, but first saves the old version under `.notuvia/xsync-backups/<id>/`.
- [ ] Copy-out writes through a symlink to its target, not over the link. It keeps the existing file's mode; a new file gets the mode recorded in `meta.yaml` (so `0600` survives), defaulting to `0644`.
- [ ] Copies go via a temp sibling and rename, as attachments do.
- [ ] Tauri commands wrapping the operations, async per ADR 0033.
- [ ] Tests: every branch of the decision function, add/link/unlink/remove on a temp vault, symlink and mode handling, and backup on overwrite.

## Notes

Decisions agreed on 2026-10-02: explicit first link then automatic; warn about secrets, no encryption in v1; single files only; removal never deletes local originals.

A machine with no local path for an entry simply lists it as "not linked here". There is no human-readable machine name today (only the check-in install id), so this task adds one for `meta.yaml`, defaulting to the hostname.