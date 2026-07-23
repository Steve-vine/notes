---
id: 01KY6ZT1DXF6MPRBXT4JMJHP5T
created: 2026-07-23T07:59:57.373528Z
updated: 2026-07-23T11:00:28.948111Z
type: task
title: Create encrypted notes
comments:
- id: 01KY6ZT9ZXEKKP3CG1C95XY1RK
  author: Steve Vine
  at: 2026-07-23T08:00:06.141567Z
  text: |-
    Steve Vine · 2026-07-06:

    **Agreed work (planned with Claude, 2026-07-06)**

    Scope for this brief — per-note password encryption of the body (title stays plaintext):

    - **Crypto/on-disk (ADR 0028):** Argon2id (m=19456, t=2, p=1, per-note 16B salt) → XChaCha20-Poly1305, fresh nonce per write, fixed context AAD. Frontmatter gains `encrypted: true`; body becomes PEM-style armor (`-----BEGIN NOTUVIA ENCRYPTED-----` … versioned headers + base64). Fully self-contained per file, preserving the ADR 0003 rebuild guarantee.
    - **Backend:** new `crypto.rs`; session-key cache on `VaultRuntime` (unlocked until hidden or app quit; keys never leave the backend); `load_note`/`update_note` branches (locked autosave preserves the envelope — safety net for flush-on-close); commands `encrypt_note`, `unlock_note`, `lock_note`, `remove_encryption`, `encrypted_notes_locked`; FTS5 never indexes encrypted bodies (`encrypted` column added; title remains searchable, snippet empty).
    - **Export:** `export_notes` gains a per-note passwords map; unlocked notes export plaintext via the cached key; locked notes prompt per note (Export / Skip / Skip all); declined or wrong password → note skipped and reported in the existing `failed[]` summary. Exported files are plaintext with the flag stripped (round-trip as plain notes, ADR 0014).
    - **UI:** lock toggle in the NotePane statusbar next to the star; new `PasswordDialog.svelte` (set/unlock/export modes); locked notes show an "Encrypted" placeholder with a View button; search hits show a lock chip; NoteHistory shows "(encrypted version)" for armored revisions.
    - **Docs:** ADR 0028 (incl. consequences: pre-encryption plaintext persists in git-sync history; restore of an old revision acts as decrypt-by-restore); `brief/data-model.md` gains the `encrypted` core field.

    Out of scope: capture window (new notes always start unencrypted), attachment encryption, vault-wide master password.
- id: 01KY6ZTP9KMZ92QGW3WX761FKR
  author: Steve Vine
  at: 2026-07-23T08:00:18.739284Z
  text: |-
    Steve Vine · 2026-07-06:

    **Build complete — PR [#195](https://github.com/Steve-vine/notuvia/pull/195)**, branch `steve/dev-704-create-encrypted-notes`.

    **What was done** (as agreed, plus ADR 0028 recording the format):
    - `src-tauri/src/crypto.rs`: Argon2id → XChaCha20-Poly1305, PEM-style armored envelope in the note body (salt/nonce/KDF params/version all in-file, so the index rebuild guarantee holds and git-sync syncs ciphertext as-is).
    - Session-key cache on `VaultRuntime`: unlock verifies via the AEAD tag and caches until hide/app-quit; keys never reach the WebView. `load_note` decrypts in memory or presents `locked`; `update_note` reseals through the cached key and preserves the envelope when locked (guards the editor's unconditional flush-on-close).
    - FTS5 never sees an encrypted body — the armor marker counts as encrypted even if the frontmatter flag is stripped. Title search still works; snippets are empty; search hits show a lock chip.
    - Export: per-note password prompts (Export / Skip / Skip all) for hidden encrypted notes; declined/wrong passwords skip the note into the existing failed summary; exported files are plaintext with the flag stripped.
    - UI: statusbar padlock next to the star (encrypt / hide / view); `PasswordDialog.svelte`; locked placeholder in all view modes; "(encrypted version)" in history previews.

    **Decisions made on the fly:**
    - AAD is a fixed context string, **not** the note id — conflict copies and restore-as-new rekey the id while keeping the body verbatim, so id-bound AAD would brick them.
    - "Remove encryption" lives as a secondary action on the unlock dialog (enter password → Remove encryption) rather than a separate control, keeping hide/view a one-click toggle.
    - `taxonomy.rs` `RESERVED_IDS` left untouched (repo precedent: `due`/`favourite` aren't blocked there either); `encrypted` is reserved in the indexer only.
    - `markEdited()` is not gated on locked — the properties panel autosaves metadata through it; the backend envelope guard is the safety net.

    **Known consequences** (in ADR 0028): pre-encryption plaintext persists in git-sync history; restoring a pre-encryption revision effectively decrypts; no password recovery (the AEAD tag is the only check).

    **Tests:** 207 backend (24 new) + 129 frontend pass; fmt/clippy/svelte-check/build clean. Manual visual pass still needed — screen capture unavailable to Claude.
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 116
sprint: sx9znt9
---
Add an option to encrypt a note, seeded on a password entered by the user.

Create a toggle on the note edit screen to encrypt, when encrypted ask the user for a password, then use that password as a seed to encrypt the contents section (not the title) of the note.

When a note is encrypted, show a hide/view toggle, which requires the password to decrypt the contents and display it as a normal note. Decrypt and display on-the-fly so that its not saved on disk decrypted.

When performing an export of any encrypted note not currently visible, ask the user for the password, if the user provides the password export unencrypted, if they decline or cannot provide the password, do not export that note.

---

Linear DEV-704 · Backlog · created 2026-06-28 · done 2026-07-06