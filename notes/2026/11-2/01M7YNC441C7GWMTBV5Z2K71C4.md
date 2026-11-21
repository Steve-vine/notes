---
id: 01M7YNC441C7GWMTBV5Z2K71C4
created: 2026-11-21T09:00:38.40134Z
updated: 2026-11-21T09:10:33.991471Z
type: task
title: Office previews made by a separate, locked-down converter on Debian 13, for .docx, .xlsx and .pptx only, and optional in the Helm deploy
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2052
sprint: s9hexqn
assignee: steve
label:
- improvement
priority: high
task_status: active
---
Follows COM-2048. **Do this before sprint 120 is released.** COM-2048 is on main and staging but in no release (latest v0.25.0), so production has never run LibreOffice.

Steve's decision (2026-11-21): keep LibreOffice, but:
- move it to Debian 13 (trixie);
- run it in its own isolated container;
- preview only the modern Office formats;
- make it optional in the Helm deploy.

Microsoft 365's own PDF conversion was considered and not chosen (see the rationale below).

## Why: the risk assessment (2026-11-21)

**The vulnerability rate has jumped.** LibreOffice's own advisories show 3–9 vulnerabilities a year from 2015 to 2025, about 5 on average. 2026 has had **46 so far**, 39 of them in four batches since mid-September (21 Sep, 5 Oct, 5 Nov, 16 Nov). The cause isn't stated; plan for that pace to continue.

Two families recur:
- memory bugs in the readers for old and odd formats (WMF/EMF/PICT images, fonts, DOC, PPT, Lotus, HWP);
- a document making LibreOffice run a script, fetch from the internet or read a local file.

**What we ship today isn't getting the fixes:**
- The server image is Debian 12 (bookworm) with LibreOffice 7.4.7, a 2023 version that Debian patches.
- Debian has fixed 80 LibreOffice vulnerabilities over the years, including the June 2026 batch. But it shows **38 open in bookworm**: every one since September.
- **Debian 13 (trixie) has fixed 37 of those 38.** The one left (CVE-2026-100101) is the "email a document" flaw, which a converter never touches.

**About a dozen of the open ones sit directly in our path** (open an uploaded file, export a PDF):
- image and font memory bugs, one of them during PDF export (CVE-2026-18563);
- code execution through form controls in OpenDocument files;
- file reading and requests to other addresses through .ods data links;
- file disclosure through embedded media.

**The impact is the worker's keys.** LibreOffice currently runs inside the worker container, as the same user:
- A code-execution or file-reading bug can generally reach the worker process. That process holds the database, Entra, Exchange, AD, storage and AI keys.
- LibreOffice is kept off the network only by pointing it at a dead proxy. The chart has no NetworkPolicy, so nothing stops it sending data out.
- What's already there is good but doesn't close this: fresh profile per file, macros off, scrubbed environment, 90 s and 300-page limits, zip-bomb check.

**What each decision buys:**
- **Trixie:** current fixes now, rather than waiting on bookworm.
- **Isolation:** a future flaw reaches nothing of value. At 2026's pace this is the decision that keeps the risk low, because there will always be a window between disclosure and our next release.
- **Modern formats only:** removes the readers with the worst record (the old binary formats) and the OpenDocument data-link and form flaws. OOXML still has bugs (e.g. CVE-2026-6047, CVE-2026-4430), but far fewer.
- **Optional:** an organisation that doesn't want a document reader in its cluster at all can leave it out.

**Considered and not chosen:** converting through Microsoft 365. Compass already uses it for the managed-content PDF export (ADR 0034). It would mean no reader on our servers at all, and truer copies. It wasn't chosen because:
- each evidence file would sit briefly in a SharePoint site;
- Compass would need write permission on that site;
- it only works where Microsoft 365 is connected.

Commercial converters (Aspose, Apryse) were also rejected: licence cost, and still a big parser on our servers. A browser-only preview was already ruled out in ADR 0164.

Sources:
- https://www.libreoffice.org/about-us/security/advisories/
- https://security-tracker.debian.org/tracker/source-package/libreoffice

## What people see
- **.docx, .xlsx and .pptx** preview exactly as now (COM-2048).
- **Older .doc, .xls and .ppt, and OpenDocument (.odt, .ods, .odp)** files still upload, download and go in packs as before. Their preview says "No preview for this file", with the reason that Compass previews Word, Excel and PowerPoint files saved in the current formats (.docx, .xlsx, .pptx), and Download.
  - My call (Steve to overturn): OpenDocument goes too, as recommended. "Modern Office formats" read as .docx/.xlsx/.pptx.
  - The backfill no longer makes copies of those types.
- **An organisation that deploys without the converter** gets "Preview not available" for Office files (the existing no-converter message). Everything else is unchanged: PDFs, images, text and CSV still preview.
- **If the converter is deployed but briefly down,** a copy isn't marked failed for good. It stays "Preparing a preview…" and is retried, and fails with a reason only after the retries run out.

## Implementation notes
- **Converter image:** a new image built on **Debian 13 (trixie)** with `libreoffice-{writer,calc,impress}-nogui` and the metric-compatible fonts (Carlito, Caladea, Liberation). It runs a small service: a file in, a PDF out, with the COM-2048 safeguards kept (fresh profile, macros off, time and page limits, zip-bomb check). No Compass code or secrets in it.
  - Built on push to main with the other images, arm64 included, with immutable tags.
  - Published to GHCR with a release (ADR 0071).
- **Remove LibreOffice from the backend image.** That takes back the ~150 MB COM-2048 added. The worker calls the converter over the cluster network.
  - The backend's own base image staying on bookworm is out of scope.
- **Check the file really is OOXML before sending it.** LibreOffice detects a format by content, not by name, so the worker must check the file is a zip with the right content types before converting. Name the import filter explicitly, so a .doc renamed to .docx is never read by the legacy reader. Macro-enabled variants (.docm/.xlsm/.pptm) stay out.
- **Chart: `converter.enabled`** (default on), with its own Deployment and Service. When off, nothing is deployed, the worker has no converter address, and Office files get "Preview not available". Hardening:
  - `automountServiceAccountToken: false`, no secrets or env from the Compass secret;
  - non-root, read-only root filesystem with a size-limited emptyDir for work, all capabilities dropped, seccomp RuntimeDefault;
  - CPU and memory limits (a conversion uses ~210 MB), one conversion at a time per pod.
- **Chart: NetworkPolicy** for the converter: ingress only from the worker, **no egress**. This is what really takes the network away (COM-2048 couldn't do that inside the worker). Note in the PR whether staging (g5) and production (EKS: VPC CNI network policy must be on) enforce NetworkPolicy. If one doesn't, say so; don't claim it.
- **CI:** add a chart render shape with `converter.enabled: false`, and keep the real-LibreOffice test running against the converter image.
- **ADR:** record this as an amendment appended to ADR 0164 §5 (the way ADR 0041 was amended), covering:
  - a separate converter service, chosen over LibreOffice in the worker image;
  - trixie;
  - .docx/.xlsx/.pptx only;
  - optional in the chart;
  - Microsoft 365 conversion considered and why not.

  Also add the converter to the chart README/values docs.
- **On the chain or independent:** probably independent (no migration expected). It joins the end of the chain if the failure reason needs a new value in the API.

## Done when
- The backend image has no LibreOffice, and the converter image's LibreOffice is trixie's current package.
- A new .docx, .xlsx and .pptx each preview as before. A .doc, .xls, .ppt, .odt, .ods and .odp each say why there's no preview and still download.
- A .doc renamed to .docx is refused without being converted.
- With `converter.enabled: false` the chart renders and deploys without it, and Office files say "Preview not available".
- From inside the converter pod: no service-account token, no Compass secrets in the environment, and outbound connections fail (on a cluster that enforces NetworkPolicy).
- Stopping the converter briefly leaves new copies "Preparing a preview…", and they complete once it's back.