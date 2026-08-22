---
id: 01M0N8JMVRWM8ZTXHK0E3R50YZ
created: 2026-08-22T17:33:58.008009Z
updated: 2026-08-22T19:53:18.980627Z
type: task
title: Vendor Portal branding — Portal tab with title, logo and intro-text overrides
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 370
sprint: sbph5q5
comments:
- id: 01M0NGHSNWTE4Z0TP2CRK8H7RP
  author: Steve Vine
  at: 2026-08-22T19:53:18.780329Z
  text: |-
    Done — PR #372, merged to main.

    **Portal tab** (last on Vendor Management, vendor-write gated): title text, logo upload with preview and remove, intro text, sender identity, and a live preview of the header so the either/or is visible rather than stated as a rule. Every field falls back to today's rendering, so a company that never opens the tab sees no change. The API refuses title + logo together rather than picking a winner silently.

    **Two open questions, decided:**

    - **SVG: no.** It can carry script, and the portal is the one Compass surface with no authenticated session behind the reader — a crisper logo doesn't buy enough to put a scriptable document in that page. PNG/JPEG, ≤200KB, and the type is validated against the **bytes** (magic numbers), because the declared content type is whatever the uploader said and the bytes are what a browser acts on.
    - **Full custom From: deferred, not shipped as a toggle.** Implemented (a) as recommended — custom display name, platform From address, Reply-To carries the company's address. A toggle warning about SPF/DKIM invites somebody to tick it and then hit deliverability failures that look like *Compass losing mail*; doing it safely needs per-domain verification, which is a feature rather than a checkbox. The tab explains the reasoning where the decision is made, rather than in a doc nobody opens.

    **Storage**: `bytea` on a per-company row with `company_id` **unique** — two rows would make the portal's appearance depend on which the query returned first. Delivered inline as a data URI on the session payload, so the token ingress grows no second unauthenticated route (ADR 0051 keeps that surface narrow).

    **Plumbing**: `OutboundMessage` gained optional `from_name`/`reply_to`, honoured by all four transports (message's identity over the transport's); only the two vendor-portal emails set them.

    **One small fix along the way**: the logo had `alt=""`. When the logo *is* the header, an empty alt tells a screen-reader user nothing about where they are — it now carries a real text alternative.

    **Tests**: unset reads as all-defaults (not a 404), save/clear round trip, logo-or-title refused together, SVG refused, a lying content type refused, over-cap refused, nothing stored through any refusal, invalid reply-to refused, read/write gating, branding on the portal session with sender identity absent from it, the MIME builder honouring a message identity and falling back without one, and three frontend rendering cases.
assignee: steve
label:
- feature
priority: medium
task_status: review
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