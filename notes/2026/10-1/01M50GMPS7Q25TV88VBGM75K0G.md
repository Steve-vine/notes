---
id: 01M50GMPS7Q25TV88VBGM75K0G
created: 2026-10-15T19:29:20.167058Z
updated: 2026-10-16T10:52:25.570504Z
type: task
title: Images go into a document — uploaded, pasted, dragged in or fetched from a web address — sized, aligned and captioned, and kept by Compass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 992
sprint: s2ufsxd
blocked_by:
- 01M50GJVGJ693A4RS0KN3A2EJ9
- 01M50GKAQT4KHC9X4PZT2WMMKY
- 01M50GM94YF8A03SHS9A4QQGKZ
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 71, Improve templated content (ADR in COM-986). Builds on the editor (COM-988), the PDF (COM-989) and the exports (COM-991). Steve asked for external images on 2026-10-15.

## What people see

- **Insert ▸ Image** takes a picture from your computer, from the clipboard, or by drag and drop, or by typing a **web address**.
- **Compass keeps its own copy.** The image doesn't change or disappear if the website does.
- **Formats:** PNG, JPEG, GIF (the first frame in a PDF), WebP and SVG, up to 10 MB each.
- **On the page:**
  - drag to resize;
  - align left, centre or right, or set it full width;
  - add a caption, and alt text for screen readers.
- **Where it appears:** the Read view, the PDF and Word as the picture, and plain text as `[Image: caption]`.
- An image stays as long as any version of the document uses it, so restoring an old version restores its pictures.
- **Pasting from Word:** pictures embedded in the pasted content are picked up as images too.

## My calls

- The 10 MB limit, and the formats listed above.
- A web address that doesn't return an image, or is inside the organisation's network, is refused with a plain message ("Compass couldn't fetch an image from that address").

## Notes (technical)

- **Server-side fetch, with SSRF guards:**
  - http/https only;
  - resolve, then refuse private, loopback, link-local and metadata ranges, then connect to the resolved IP;
  - at most 3 redirects, each re-checked;
  - a size cap while streaming, and a content type sniffed from the bytes, not the header.
- **SVG** is sanitised on an allow-list: no script, `foreignObject`, event attributes or external `href`. Never serve an uploaded SVG inline from the API origin without `Content-Security-Policy: sandbox`.
- **Storage:** `content_images` (per content item, object storage, sha256, dimensions), referenced by id from the ProseMirror `image` node. Garbage-collect only images that neither the draft nor any version references.
- The editor uploads pasted data URIs and `blob:` images, never storing data URIs in the doc.
- WeasyPrint and python-docx read the stored bytes. The renderer never fetches over the network (set WeasyPrint's `url_fetcher` to refuse anything not served by Compass).
- Semgrep: no `new RegExp(variable)` in the paste handlers.

**Done when:** on staging, a policy holds an uploaded PNG, a pasted screenshot and an image fetched from a public web address, each with a caption, and all three appear in the PDF and the Word export.