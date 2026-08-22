---
id: 01M0N8JMVRWM8ZTXHK0E3R50YZ
created: 2026-08-22T17:33:58.008009Z
updated: 2026-08-22T19:29:47.179506Z
type: task
title: Vendor Portal branding — Portal tab with title, logo and intro-text overrides
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 370
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The Vendor Portal currently presents as Compass (the `IconCompass` + "Compass" wordmark, `VendorPortalApp.tsx` header) with a fixed intro line under the **Assessments** title. Suppliers are looking at *the company's* questionnaire, so let each company brand it.

## Settings (per company)

- [ ] Three overrides, each optional with the current rendering as fallback:
  - **Title text** — replaces the "Compass" wordmark (default icon stays)
  - **Logo image** — replaces icon *and* text with one image (mutually exclusive with title text: image wins, and the admin UI should present it as either/or)
  - **Assessments intro text** — the paragraph under the Assessments heading (the vendor-name prefix stays; this replaces the instructional sentence)
- [ ] A small company-scoped settings model/row (the m365/org-settings shape). **Logo stored in the DB, tightly capped** (e.g. ≤200KB, PNG/JPEG/SVG — decide whether to allow SVG given it can carry script; if kept, serve with a strict content-type and CSP) — there is no file storage yet (that's its own future sprint); a DB-stored data-URI delivered inline is fine at this size and can migrate to real storage later.

## Sender identity (added 2026-08-22)

- [ ] A second section on the tab: **email address** and **display name** used as the From identity on the vendor-portal emails (contact links, owner notifications). Optional, falling back to the platform sender.
- [ ] Validate the address; render as `Display Name <address>`.
- [ ] **Deliverability caveat, surface it in the UI**: mail is sent by Compass's mail infrastructure, so a From address on a domain whose SPF/DKIM doesn't authorise that infrastructure will spam-folder or bounce. Options in order of safety: (a) custom display name only, From address stays the platform's, Reply-To gets the custom address — works for any address, recommended default; (b) full custom From for domains verified to allow it. Implement (a) now; make full-From a deliberate toggle with a warning, or defer it — decide in review.
- [ ] This resolves the earlier email-branding question for the display name: emails adopt the custom display name (and title where the template says "Compass") once set.

## Admin: the Portal tab

- [ ] New **Portal** tab on the Vendor Management page (after Approval Rules), vendor-write gated like its neighbours: title text input, logo upload with preview + remove, intro text area, the sender-identity section, and a live-ish preview of the header so the either/or is visible.

## Portal rendering

- [ ] The vendor-portal session payload carries the branding (it already resolves the vendor → company, and inline delivery means no separate asset route on the token ingress). Header renders image > custom title > default; intro text renders override > default.

- [ ] Tests: fallbacks when unset; either/or enforcement; size/type caps rejected cleanly; branding in the session payload; admin tab gated; portal renders each combination; emails carry display name + Reply-To; invalid address rejected.