---
id: 01M4NK6AMQTZX8PAGM9CN1ZYNM
created: 2026-10-11T13:42:15.959725Z
updated: 2026-10-11T13:45:35.293248Z
type: task
title: Compliance shows "Compliance by domain" and "Maturity by domain" — each one chart with a line per domain — with Open gaps moved down beside Risks
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 915
sprint: s4gilxe
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Raised by Steve on 2026-10-11 while smoke-testing sprint 68 on staging: "Add a fourth unchanging graph, 'Domains', which shows compliance by domain; make it the first non-changing graph to the left of Maturity and move open gaps down next to Risks." Logged only; not to be actioned until Steve says.

## Decided (Steve, 2026-10-11)

- **Both are a single chart with several lines, one per domain.** I had proposed a grid of small charts, one per domain; Steve chose one chart each.
- **They are named "Compliance by domain" and "Maturity by domain",** so neither can be mistaken for the other or for the main chart.

## What people should see

- **A new chart, "Compliance by domain":** one line per domain, each domain's compliance over time.
- **The Maturity chart becomes "Maturity by domain":** one line per domain, each domain's average maturity over time. The grid of small per-domain charts under it goes, since the lines now say the same thing.
- **Neither follows the filter.** Like Open gaps and Risks they always show the whole company, and the note above those charts names all four.
- **The layout under "Compliance over time" is two rows of two:**
  - first row: Compliance by domain on the left, Maturity by domain on the right;
  - second row: Open gaps on the left, Risks on the right.
- **A domain is the same colour on both charts,** so the two can be read across.
- **Both follow the period choice** and carry the same event marks as the other charts.

## Assumption to confirm with Steve

- **"Maturity by domain" keeps the company's overall average as one heavier line** among the domain lines. Today that average is the chart's only line, and it appears nowhere else on the page as a trend; dropping it would lose it. "Compliance by domain" needs no such line, because the overall figure is the main chart above.
- If Steve wants domain lines only, remove it: a one-line change.

## Notes (technical)

- No new data and no API change: every point of `/posture-timeline` already carries `domains[]` with `compliance_percent` and `avg_maturity`.
- `CompliancePage.tsx`, `Charts`: the `SimpleGrid` order becomes Compliance by domain, Maturity by domain, Open gaps, Risks. `DomainSparklines` is removed.
- About twenty domains means about twenty lines. The page has eight framework colours today, so this needs a longer, ordered set of tones, assigned by the domain's display order so a domain keeps its colour on both charts and across periods. Put the legend beneath, and make a line stand out on hover, or the chart cannot be read.
- Compliance on a fixed 0 to 100 scale; maturity on 0 to 5, as now.
- A domain with nothing in scope, or not rated, on a day has no value there: a gap, not a zero.
- Put the line and row building in `compliance/series.ts` with the others, so it can be tested without a chart.
- Update the whole-company note to name the four charts.
- Tests: the panel order and titles in the page test; lines, colours and gaps in the series unit test.

**Done when:** on staging the page shows "Compliance by domain" and "Maturity by domain" side by side, each with a line per domain, Open gaps and Risks beneath them, and none of the four changes when the Measure, Tier or level filter does.