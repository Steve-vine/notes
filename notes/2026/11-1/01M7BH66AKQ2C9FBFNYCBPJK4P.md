---
id: 01M7BH66AKQ2C9FBFNYCBPJK4P
created: 2026-11-13T22:41:55.539457Z
updated: 2026-11-13T22:41:55.539457Z
type: memo
title: Compass comparison / SimpleRisk
project: 01KXGC5PTGYHV30VM3E78G76S1
---
Comparison of SimpleRisk (open-core GRC) against Compass, 2026-11-13, to find candidate future features. Based on SimpleRisk's website and support articles (not hands-on), each item checked against the Compass codebase. Companion to "Compass comparison / CISO Assistant" and "Compass comparison / Eramba".

**Summary:** SimpleRisk is the most risk-focused of the three, and Compass already covers most of it. Three things are new compared with the earlier lists; seven more repeat items already on them, and three of those now appear in all three competitors.

## New compared with the earlier lists
1. **Management review of risks, with review dates set by risk level.** A manager reviews each risk and records a decision (accept, plan mitigation, or investigate further). How often a risk comes back for review depends on its level, so high risks are reviewed more often than low ones. Compass records a last and next review date and keeps every revision, but the review isn't a decision anyone signs, and there is one review interval for every risk regardless of level.
2. **Risks visible to one team only.** E.g. HR risks and documents seen only by the HR team. Compass controls access by role and company, not by team within a company.
3. **Business units within a company.** Departments and business units are modelled, own risks and controls, and reports roll up through the structure. Compass's structure stops at the company. Eramba has business units too, so this is really on two lists (missed in the Eramba memo).

## Also on an earlier list
- **More ways to score a risk** (CISO #3, Eramba #4) — besides likelihood × impact: CVSS-style, DREAD and OWASP scoring, plus "contributing risk", which weighs several impact areas. Compass already lets you rename its levels and bands, but the grid is always 5×5.
- **Risk in money using FAIR** (CISO #1) — in SimpleRisk's AI add-on.
- **A Secure Controls Framework backbone** (CISO #5) — SimpleRisk imports the free Secure Controls Framework, which already maps controls to 250+ frameworks. Worth looking at as a cheap way for Compass to add many frameworks at once rather than one at a time; licence terms need checking first.
- **Questionnaires that create risks** (Eramba #2) — answers to a structured risk questionnaire raise risks automatically, and results can be compared over time.
- **Two-way Jira sync, plus custom review and approval workflows** (CISO #9 and #10).
- **Custom fields and forms** (CISO #18, Eramba).
- **Spreadsheet import with column matching** (CISO #20, Eramba).

## Already in Compass
The policy, standard and procedure library with review dates; controls mapped across frameworks; exceptions with approval; control testing and audits, with scoped access for auditors; risk appetite; mitigation planning; vulnerabilities read from Tenable and other scanners, with a finding promoted to a risk; incidents; email reminders; search; an API; single sign-on; an AI assistant.

## Takeaway
- **Add to the shortlist:** the management risk review with level-based review dates (1) — small, and it strengthens the risk register for audits.
- **Signals across all three products:** custom fields, configurable workflows and approvals, and spreadsheet import appear in every one; more flexible risk scoring appears in all three as well. These are now the strongest candidates.
- **Framework breadth:** the Secure Controls Framework is the idea to follow up.

## Sources
- https://www.simplerisk.com
- https://www.simplerisk.com/pricing (Extras)
- https://www.simplerisk.com/platform
- https://www.simplerisk.com/grc/risk-management
- https://www.simplerisk.com/grc/governance
- https://www.simplerisk.com/extras/vulnerability-management
- https://support.simplerisk.com/kb/01-03-risk-scoring-methodologies
- https://support.simplerisk.com/kb/05-02-custom-risk-scoring