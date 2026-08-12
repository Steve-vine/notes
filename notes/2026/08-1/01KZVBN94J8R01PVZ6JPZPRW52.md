---
id: 01KZVBN94J8R01PVZ6JPZPRW52
created: 2026-08-12T16:07:34.802348Z
updated: 2026-08-12T16:07:34.802348Z
type: task
title: Research API-keyed subfinder sources to improve coverage
label:
- follow_up
- feature
priority: low
imported_from: linear
task_status: backlog
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 128
---
## Why

Phase A of [DEV-166](<https://linear.app/stevevine/issue/DEV-166/scanner-fails-on-examplecom>) revealed that of subfinder's 39 source plugins, only 10 can run without an API key, and on two real targets ([example.com](<http://example.com>), [moneypenny.com](<http://moneypenny.com>)) only 3 sources contributed any data:

* `anubis` — passive DNS aggregation
* `crtsh` — Certificate Transparency
* `hackertarget` — passive DNS / OSINT aggregator

The other 7 keyless sources (`alienvault`, `commoncrawl`, `digitorus`, `dnsdumpster`, `rapiddns`, `sitedossier`, `waybackarchive`) returned zero on those targets — though they may contribute on others.

Adding API-keyed sources could materially improve coverage. The 29 keyed sources include high-value commercial passive-DNS providers like SecurityTrails, Censys, VirusTotal, Shodan, BinaryEdge, etc.

## Investigation scope

For each candidate source, identify:

* Pricing tier required (free / community / paid) and what that gets you
* Coverage characteristics — does it specialise (e.g. CT logs vs HTTP scanning vs DNS aggregation)?
* Rate limits and quota for the relevant tier
* Output quality — is it brute-force noise like anubis, or curated like crtsh?
* Overlap with sources we already have

Candidates to look at first, in rough order of expected value:

* `securitytrails` — historically the most comprehensive passive DNS database. Free tier exists.
* `censys` — large CT log + HTTPS scanning index. Free tier with limits.
* `virustotal` — free tier reasonably generous; useful CT/scanning data.
* `shodan` — strong on internet-facing services. Free tier limited but membership cheap.
* `chaos` (ProjectDiscovery's own dataset) — free for non-commercial use, may be free for our use case.
* `binaryedge` — free tier exists; broad scanning data.
* `whoisxmlapi` — DNS history.
* `fullhunt` — attack surface management; small free tier.

Lower priority (paid-only or small-vendor):

* `chinaz`, `c99`, `quake`, `threatbook`, `zoomeye`, `fofa`, `intelx`, `bevigil`, `bufferover`, `builtwith`, `dnsdb`, `dnsrepo`, `facebook`, `github`, `hunter`, `leakix`, `netlas`, `passivetotal`, `redhuntlabs`, `robtex`

## Comparison method

Pick 3–5 representative real targets (e.g. [moneypenny.com](<http://moneypenny.com>) plus 2–3 other domains we own with different shapes — large public surface, mostly internal, mostly SaaS-hosted). Run subfinder once per candidate source against each target. Compare results vs the current 3-source baseline:

* Net new subdomains discovered (count and quality)
* Time taken
* API quota consumed

## Decision output

For each evaluated source, decide:

* (a) Add to default scan engine — strong contribution, free or affordable, low maintenance
* (b) Make available on opt-in engines (e.g. a "deep" scan engine) — useful but expensive or rate-limited
* (c) Skip — overlap with existing sources / poor quality / not worth the cost

## Out of scope

* Implementation of the multi-tier scan engines (separate brief if needed)
* API key secrets management (1Password integration, k8s secret rollout — separate concern)
* Active subdomain brute-forcing tools (this is about passive sources only)
* Replacing subfinder with a different tool

## Source

Surfaced from [DEV-166](<https://linear.app/stevevine/issue/DEV-166/scanner-fails-on-examplecom>) Phase A investigation. Currently 99.99% of records on [example.com](<http://example.com>) came from a single source (anubis); on [moneypenny.com](<http://moneypenny.com>) 100% came from just 3 sources. Worth understanding what we're missing.

---

Imported from Linear [DEV-167](https://linear.app/stevevine/issue/DEV-167/research-api-keyed-subfinder-sources-to-improve-coverage) · parent DEV-166