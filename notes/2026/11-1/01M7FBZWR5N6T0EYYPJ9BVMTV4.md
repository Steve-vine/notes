---
id: 01M7FBZWR5N6T0EYYPJ9BVMTV4
created: 2026-11-15T10:28:03.973381Z
updated: 2026-11-15T10:28:08.671619Z
type: task
title: 'Polaris always knows what''s on screen: the record, its tab, any open window and anything ticked, on every page'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1847
sprint: spsp226
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
## What happened

Steve, testing (2026-11-15): on a control's Evidence tab, Polaris in chat answered "I can set this up, but I can't tell from your screen which control you're on." He says this is common across the app. The same thing happened on Checks with ticked controls (COM-1836, fixed there only).

Why: Polaris is told the company, the part of Compass and the page's general name from the route (`polaris/place.ts`). It's told about the record on screen only where a page explicitly publishes it (`usePublishPolarisContext`). Just 7 places do: DDQs and their questions, collected checks, and ticked controls on Checks. Each one added a named field of its own (`ddq_ref`, `check_ref`, `ticked_controls`…). Every other record page tells Polaris nothing: controls, risks, gaps, exceptions, vendors, assets, incidents, vulnerabilities, secrets, initiatives, audits, content and more. Neither the tab you're on nor a window you've opened is passed either. Meanwhile about 75 pages already name their record for the trail (`useTrailLabel`, e.g. "5.2 · Passwords are long"), so the page knows; Polaris just isn't told.

## What people see

- **On any page showing one thing, Polaris knows what it is and which tab you're on.** The status bar shows it, e.g. "Moneypenny · Posture ▸ Assessments · ACC.13 Access reviews · Evidence". That covers a control, risk, gap, vendor, asset, incident, vulnerability, secret, initiative, audit, document, framework requirement and so on. "This control", "this risk", "here" and "it" mean that record.
- **A window opened over a page counts too.** For example, a gap opened from a control, or a question in a DDQ: Polaris is told about the window, and about the page behind it.
- **Ticked rows count on any list with bulk actions**, not just Checks ("· 4 vulnerabilities ticked"). Polaris is told which ones.
- **A list page tells Polaris what it's showing**: its filters and search, e.g. "Risks · High, Open · owner Steve". "These" means what's shown.
- **The conversation's tools follow what's on screen.** A control's Evidence tab gives Polaris the tools for collected checks, the way a check already does.
- **Polaris stops saying it can't see your screen when the screen says.** Only if a page genuinely shows nothing in particular does it ask, by name ("Which control: ACC.12 or ACC.13?"), never "I can't tell from your screen".
- **It's built once and every page gets it:** a page that names itself for the trail tells Polaris at the same time. No page needs its own field. The existing DDQ, check and ticked-controls cases move onto the same footing and keep working.
- **New screens can't miss it.** A test, like the screen-conventions test, fails any record page that names itself without telling Polaris what it is.

## Done when

- On staging (E2E Test Company), on ACC.13 ▸ Evidence, asking Polaris "set up evidence collection for this control" acts on ACC.13 without asking which control. The status bar names it and the tab.
- The same works on at least one record page in each part of Compass: a risk, gap, vendor, asset, incident, vulnerability, secret, initiative, audit and a content document. A window (a gap opened from a control) and ticked rows on a second list (e.g. Vulnerabilities) work too.
- A list page's filters reach Polaris ("summarise these" summarises what's shown).
- The DDQ question, collected-check and ticked-controls behaviour is unchanged (their existing tests pass).
- Tests: vitest for the shared context (record, tab, window, ticked, filters) and the coverage test across record pages; backend tests that Polaris's instructions carry what's on screen and that "this" resolves to it.

**On the chain** (what Polaris is sent gains a general "on screen" record, tab, window, ticked and filters: an API change). Builds on ADR 0127 §8; amend it in the PR. Related: COM-1836.