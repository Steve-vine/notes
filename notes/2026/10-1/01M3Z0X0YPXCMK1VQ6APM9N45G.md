---
id: 01M3Z0X0YPXCMK1VQ6APM9N45G
created: 2026-10-02T19:19:19.254081Z
updated: 2026-10-02T19:45:10.600981Z
type: task
title: CrossSync core engine, plus ADR
project: 01KY6W9951TW0904DT0GGJVGE7
number: 492
sprint: sx287fa
comments:
- id: 01M3Z2CBY8MV6G8R0BXV8EJSFE
  author: Steve Vine
  at: 2026-10-02T19:45:10.600479Z
  text: |-
    Built and merged as 374b92e (squash, PR #482), CI green. The branch is deleted.

    What landed:
    - ADR 0067 records the layout, the machine-local map, the sync rule and the security posture.
    - New xsync module in notuvia-core: entries at xsync/<id>/<filename> plus meta.yaml, links in .notuvia/xsync.json, and the three-way decide() rule over content hashes.
    - add, link, unlink, remove, list, sync and sync-all, exposed as xsync_* Tauri commands. Copy-in and remove ride the git-sync debounce.
    - Copy-out backs up a differing local file to .notuvia/xsync-backups/<id>/ (newest ten kept), writes through symlinks, keeps the existing mode, and gives a new file the mode recorded at add time.
    - Entry ids and the synced filename are validated as single path components; paths inside the vault are refused.

    Decided on the fly:
    - "~/" is expanded in paths, and linking creates missing parent folders.
    - A file itself named meta.yaml is stored as _meta.yaml.
    - The readable machine name is the hostname at add time (new gethostname dependency); there is no setting for it.
    - A vault copy that has gone missing while its folder remains is repaired from the original.

    Problem found by the tests: backups made within one second were pruned in the wrong order (a freed slot was reused by a newer backup). Fixed with a counter that continues from the highest in use.

    Verification: 17 new tests; cargo test --workspace passes (451 core), fmt and clippy clean. Not exercised in the running app, since there is no UI until NOT-493.
assignee: steve
label:
- feature
priority: high
task_status: done
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