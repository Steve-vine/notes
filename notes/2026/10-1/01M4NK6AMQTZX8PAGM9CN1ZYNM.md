---
id: 01M4NK6AMQTZX8PAGM9CN1ZYNM
created: 2026-10-11T13:42:15.959725Z
updated: 2026-10-11T13:42:19.797131Z
type: task
title: Compliance gains a Domains chart — compliance by domain over time — beside Maturity, with Open gaps moved down beside Risks
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

## What people should see

- **A fourth chart, "Domains",** showing each domain's compliance over time.
- **It is one of the charts that do not follow the filter.** Like Maturity, Open gaps and Risks it always shows the whole company, and the note above those charts names it with the others.
- **The layout under "Compliance over time" becomes two rows of two:**
  - first row: Domains on the left, Maturity on the right;
  - second row: Open gaps on the left, Risks on the right.
- **It follows the period choice,** as every chart on the page does, and carries the same event marks.

## Assumption to confirm with Steve

- **One small chart per domain, not one chart with a line per domain.** There are about twenty domains, and twenty lines with a legend cannot be read. The Maturity panel already shows maturity by domain this way, as a grid of small charts under its main line. Domains would be the same grid, each small chart labelled with the domain's name and its current percentage.
- If Steve wants a single chart with a line per domain, say so before this is built: it is a different panel.

## Notes (technical)

- No new data and no API change: every point of `/posture-timeline` already carries `domains[].compliance_percent` (beside the `avg_maturity` the Maturity sparklines use).
- `CompliancePage.tsx`, `Charts`: a new `Panel title="Domains"` first in the `SimpleGrid`, then Maturity, Open gaps, Risks. Reuse the shape of `DomainSparklines`, reading `compliance_percent`, in a compliance tone (not the maturity accent), with a fixed 0 to 100 scale so the small charts can be compared.
- A domain with nothing in scope on a day has no value there: a gap, not a zero.
- Update the whole-company note to "Domains, Maturity, Open gaps and Risks show the whole company".
- If COM-908's sparklines for maturity stay in the Maturity panel, the two grids sit side by side and should use the same domain order.
- Tests: the panel order in the page test; a domain's values, including a gap, in a unit test.

**Done when:** on staging the page shows Domains and Maturity side by side, Open gaps and Risks beneath them, and the Domains panel does not change when the Measure, Tier or level filter does.