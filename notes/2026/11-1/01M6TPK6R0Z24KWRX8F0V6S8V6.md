---
id: 01M6TPK6R0Z24KWRX8F0V6S8V6
created: 2026-11-07T09:49:22.385926Z
updated: 2026-11-07T10:02:33.680195Z
type: task
title: A control's evidence gets its own Evidence tab (Overview · Evidence · Gaps · Risks · History) in three sections — Security Assurance Plan, Automated Collection and Manual Collection — and Risks moves to its own tab
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1630
sprint: s5khbev
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
![CleanShot 2026-11-07 at 09.48.51@2x.png](attachments/2026/11/01M6TPK6R0Z24KWRX8F0V6S8V6/CleanShot-2026-11-07-at-09.48.51@2x.png)

Raised by Steve while testing on staging (2026-11-07), on SOD.9 in Test Company. The control page's narrow right-hand pane holds the Standing card, Risks, Evidence of operation and "How Compass collects this". With six collected checks, that last card runs to many screens of small text: each check's "still needs a person" paragraph, its reads, and four stacked buttons. It's hard to read.

## What Steve asked for

- A new **Evidence** tab between Overview and Gaps, holding the evidence sections now in the side pane.
- Three sections on it: **Security Assurance Plan**, **Automated Collection** and **Manual Collection**.
- **Risks** moves to its own tab as well.

## The page after

Tabs: **Overview · Evidence · Gaps · Risks · History**. Evidence and Risks are shown only when a company is selected and the person can read it, as Gaps and History are now. Each tab shows its count as Gaps does: Evidence counts live checks plus linked evidence; Risks counts linked risks.

The side pane keeps only the **Standing** card (the company's assessment and the Assess button) and **Open gaps**. Risks, Evidence of operation, Checks and How Compass collects this all leave it.

### Evidence tab, full width, three sections in this order

1. **Security Assurance Plan**: today's Evidence of operation card (`evidence/EvidenceOfOperationCard.tsx`). It shows the plan activities that prove the control works, last done and next due, with "Add to the plan". The content is unchanged, laid out for the wider space.
2. **Automated Collection**: what Compass gathers by itself.
   - **Built-in checks** speaking to the control (today's Checks card, `checks/ChecksCard.tsx`).
   - **Collected checks** (today's How Compass collects this, `collection/CollectionCard.tsx`).
   - The section heading carries the coverage words, e.g. "Partly automated · Evidence only".
   - **Made readable.** Each check is one row or compact card: name, Covers (full/partly), Doing pill, account, last capture, next due, and links to the page (PDF) and raw data.
   - Its detail sits behind a "Details" toggle: "Still needs a person", the reads, and the rule with its approve/edit.
   - The four stacked buttons per check (Ask Polaris for a rule, Collect now, Ask Polaris to check this, Re-create) become one action menu per row. Write a rule / Advanced go in the same menu.
   - "Ask Polaris for another check" sits once, at the foot of the section.
   - Waiting proposals and held captures sit at the top of the section, as they need a person.
3. **Manual Collection**: the evidence in the Evidence register linked to this control by hand (uploads, links, documents). This is what Audit ▸ Evidence ▸ By control shows for the control (`audit/ControlEvidenceView.tsx` and `LinkedEvidenceList`), with "Add evidence" for whoever may add it. Collected captures are not repeated here: they belong to Automated Collection. Empty state: "No evidence has been added by hand for this control."

### Risks tab

Today's `ControlRisksCard`, full width and unchanged in content: the risks the control is an exception to, then the risks it reduces.

## Done when

- The tabs read Overview · Evidence · Gaps · Risks · History. The URL `?tab=evidence` and `?tab=risks` work and are kept on reload, as the other tabs are.
- The side pane holds only Standing and Open gaps.
- Each section has a heading and an empty state, and a section a person can't read isn't shown. Evidence of operation keeps its "each source decides who may read it" rule.
- Collected checks are one row each with details folded away and one action menu. Six checks on SOD.9 fit on one screen with every row folded.
- Screen conventions hold: no pill truncates, fields on one row line up (COM-1623), and the tab bar folds into More on a narrow screen.
- Links that pointed at the old cards still land: "View" from a check, Fix sign-in actions, Review tab links and audit look-over flags open the control on the Evidence tab.
- The Browser smoke (`app/e2e`) covers the two new tabs for each test account. Page tests are updated.
- On staging: SOD.9 in Test Company reads cleanly on the Evidence tab, and Risks is its own tab.

## Where

- `pages/ControlDetailPage.tsx`: the tabs and the side pane.
- `evidence/EvidenceOfOperationCard.tsx`
- `checks/ChecksCard.tsx`
- `collection/CollectionCard.tsx`: the per-check layout.
- `audit/ControlEvidenceView.tsx` and `LinkedEvidenceList.tsx`
- `components/ControlRisksCard.tsx`
- Links into the control page: actions, the Review tab, audit flags.