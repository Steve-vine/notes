---
id: 01KY72GJYZHVECCE953FK2TGFN
created: 2026-07-23T08:47:13.375111Z
updated: 2026-07-23T08:53:23.102906Z
type: task
title: File storage
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 292
comments:
- id: 01KY72GVSMNMDG6PNNQDMDDRV8
  author: Steve Vine
  at: 2026-07-23T08:47:22.420472Z
  text: |-
    Steve Vine · 2026-07-12:

    Built on `steve/dev-945-file-storage` → PR [#287](https://github.com/Steve-vine/notuvia/pull/287).

    **What was done**

    - Notes now live at `notes/YYYY/MM-k/<id>.md` — creation month from the ULID's timestamp (UTC), `-k` buckets capped at 500 files, spilling to `-k+1` as agreed. The month stays derivable from the ID; the bucket is found by probing the month's few folders. Notes never move after creation.
    - Imports mint IDs backdated to each note's resolved `created` (frontmatter → the earlier of birthtime and mtime → now), so bulk imports scatter across their real months and sort correctly by ID.
    - An idempotent sweep at every vault open migrates the hex tree into month buckets (cap-aware, ID-ordered) and prunes emptied dirs. It also self-heals strays written by a stale build later.
    - Note history spans the migration: git logs run over both the current and legacy pathspecs, and content reads fall back to the hex path for pre-migration revisions.
    - ADR 0041 written, ADR 0004 marked superseded, `brief/storage-architecture.md` and CLAUDE.md brought current.

    **Decisions made on the fly**

    - Kept `shard_path`/`shard_rel`'s call shape as `note_path`/`note_rel` (resolve-against-disk instead of pure hash) so ~40 call sites kept their structure — big diff-risk reduction.
    - The migration sweep is **non-fatal**: if it errors mid-way the vault still opens and unmigrated notes resolve via the legacy-path probe.
    - Bucket enumeration reads the year directory rather than counting `-1, -2, …` upward, so a pruned/never-cloned empty bucket can't hide later ones (git doesn't track empty dirs).

    **Problems encountered:** none — the layout knowledge was fully contained behind the `note.rs` functions.

    **Checks:** 346 Rust tests (incl. new spill / migration / backdating / legacy-fallback tests), clippy + fmt clean, frontend untouched and green.

    ⚠️ **After merging: rebuild notuvia-mcp immediately** — a stale build writes new notes into the hex layout. The sweep adopts them at next open, but best to avoid the window. Your live vault migrates on first app launch; it lands in git as one rename-detected commit.
label: null
---
Currently files are stored in a folder until until a threshold is hit an then starts to add a second file to each folder and so on.  The downside of this is that someone with 100 notes would also have 100 folders.

Is there a better way to manage this like filling up one folder before creating another one, or something else?

---

## Agreed work (2026-07-12)

**Correction to the premise:** there's no threshold-then-spill today. ADR 0004 hex-shards on a hash of the note ID — a deliberately random spread over 65,536 leaf dirs — so at small scale nearly every note gets its own `aa/bb` folder chain (~2 dirs per note).

**Agreed layout: month folders with a 500-file cap.**

* Notes live at `notes/YYYY/MM-k/<id>.md`, e.g. `notes/2026/07-1/`. The month comes from the ULID's embedded timestamp (UTC), so a note's *month* is still a pure function of its ID.
* `-k` is the overflow suffix, starting at `-1`: a folder never exceeds **500 files** — note 501 of a month goes into `MM-2`. Which `-k` a note landed in is write-time state, so resolution = try `MM-1`, `MM-2`, … within the ID's month (bounded, almost always one probe). Notes never move after creation; the cap is write-time-enforced and goes soft only under concurrent multi-machine creates (harmless).
* **Imports backdate their IDs**: resolved `created` (frontmatter → the earlier of file birthtime and mtime → now) is used to mint the ULID via `from_datetime`, so a bulk import scatters across its real months instead of piling into the import month — and imported notes sort correctly by ID everywhere.
* **Migration**: idempotent sweep on vault open — any `.md` not in a correct `YYYY/MM-k` folder for its ID moves there (cap-aware, ID-ordered), empty hex dirs pruned. Git sees renames (content unchanged). History reads (`git show rev:path`) use the note's stable current path with a fallback to the legacy hex path for pre-migration revisions.
* **New ADR superseding ADR 0004.**
* ⚠️ notuvia-mcp must be rebuilt right after merge — a stale build writes to the hex layout (the sweep adopts strays on next open, but avoid the window).

### Checklist

- [ ] `note.rs`: month derivation from ULID (UTC), bucket resolution (`MM-1..k` probe + legacy-hex probe), cap-aware placement for new notes; keep legacy hex path as a pure fallback function
- [ ] Rewire call sites (write/read, reconcile-after-write, git pathspecs, history reads with legacy fallback)
- [ ] `import.rs` + caller: birthtime∧mtime date resolution, backdated ULID minting for freshly-minted IDs only
- [ ] Migration sweep on bootstrap, idempotent, prunes empty dirs
- [ ] Tests: format-pinned layout vector, bucket spill at 500, resolution probes, migration, import backdating, history fallback
- [ ] ADR superseding 0004

One branch + PR: `steve/dev-945-file-storage`.

---

Linear DEV-945 · Editor and Sync · created 2026-07-11 · done 2026-07-12