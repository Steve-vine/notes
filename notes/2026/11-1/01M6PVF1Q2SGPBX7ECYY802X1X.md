---
id: 01M6PVF1Q2SGPBX7ECYY802X1X
created: 2026-11-05T21:57:28.418246Z
updated: 2026-11-05T23:44:46.351647Z
type: task
title: Collection integration icons — a Collection tile shows the service's logo, a lettered tile in a colour when there isn't one, or a picture a person uploads (PNG, JPEG or SVG, cleaned before it's stored)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1597
sprint: s1jcke1
blocked_by:
- 01M6PVEM1AZX50AJWXD9Z0ZSMZ
comments:
- id: 01M6Q1KDRWM36XCHX0GMDW485X
  author: Steve Vine
  at: 2026-11-05T23:44:43.291972Z
  text: |-
    Done: PR #1613 merged. No migration: the icon columns came with COM-1596's 0785.

    What's there:
    - **Settings ▸ Icon** on a Collection tile:
      - **Upload a picture**: PNG, JPEG or SVG, up to 1 MB. The type is read from the file's bytes, not its name. An SVG is kept only after cleaning: no script, event handlers or outside references.
      - **Fetch it from a web address**: public addresses only, with the connection pinned to the checked address. Compass keeps its own copy.
      - **Remove** brings the lettered tile back.
    - **The lettered tile**: the service's first letter, on a colour taken from its name, so the same service always gets the same colour.
    - **The icon** is served with `nosniff` and a sandboxing content policy. Its address changes whenever the tile does, so a new picture shows at once.
    - **Activity log**: changes show as "icon changed", without the picture's bytes.

    Tested:
    - upload;
    - SVG cleaning (the script and onclick are gone);
    - a fake PNG and an over-1 MB file refused;
    - fetch, and a refused fetch;
    - remove;
    - Vitest for the panel and the cache-busted address.

    To check on staging:
    - SendGrid shows an "S" until a PNG is uploaded;
    - Remove brings the "S" back.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Evidence Collection - Integrations" (ADR 0142, COM-1595). Builds on COM-1596. The Polaris wizard (later in the sprint) finds the logo automatically; this task is where an icon is kept and shown.

## What people see

- **Every Collection tile has an icon**, the same size and placing as a Core tile's logo, in light and dark mode.
- **No icon yet:** a lettered tile with the service's first letter on a colour picked from its name, so the same service always gets the same colour. Readable in both modes.
- **Settings ▸ Icon:**
  - **Upload** a PNG, JPEG or SVG up to 1 MB. It shows as a preview before saving.
  - **Fetch from a web address**: paste an address for the logo image.
  - **Remove** puts the lettered tile back.
  - Changes are in the activity log.
- **Anything unsafe is refused in words:** a file that isn't really an image, an SVG with script, or an address on a private network.

## Notes (technical)

- Reuse `core/assets.py`:
  - `read_picture()` (type from the bytes);
  - `sanitise_svg()` (defusedxml plus the element allow-list);
  - `fetch_picture()` (public address only, pinned connection, size cap).
  - Don't copy the Trust Centre's PNG/JPEG-only `validate_logo`: SVG is wanted here and the sanitiser makes it safe.
- Store the icon bytes with the definition, or in storage, keyed by the definition. Serve them from the API with the right content type and `Content-Security-Policy: sandbox` for SVG.
- Frontend: `integrations/IntegrationLogo.tsx` gains a data-driven source alongside its static `LOGOS` record, and the lettered fallback.

**Chain:** on the chain (migration and API).

**Done when:** on staging, SendGrid's tile shows a lettered "S" until a PNG is uploaded, then the PNG; an SVG containing `<script>` is cleaned (the script is gone in the stored copy); a non-image renamed `.png` is refused; Remove brings the "S" back.