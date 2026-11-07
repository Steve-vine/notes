---
id: 01M6TPK6R0Z24KWRX8F0V6S8V6
created: 2026-11-07T09:49:22.385926Z
updated: 2026-11-07T10:07:04.551282Z
type: task
title: A control's evidence gets its own Evidence tab (Overview · Evidence · Gaps · Risks · History) in four sections — Security Assurance Plan, Managed Content, Automated Collection and Manual Collection — and Risks moves to its own tab
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
- Four sections on it: **Security Assurance Plan**, **Managed Content**, **Automated Collection** and **Manual Collection**. Managed Content was added the same morning: "between SAP and Automated. In here it should be possible to link to documents in the content section".
- **Risks** moves to its own tab as well.

## The page after

Tabs: **Overview · Evidence · Gaps · Risks · History**. Evidence and Risks are shown only when a company is selected and the person can read it, as Gaps and History are now. Each tab shows its count as Gaps does: Evidence counts live checks, linked content and linked evidence; Risks counts linked risks.

The side pane keeps only the **Standing** card (the company's assessment and the Assess button) and **Open gaps**. Risks, Evidence of operation, Checks and How Compass collects this all leave it.

Overview loses its **Linked content** panel, which moves to Managed Content. Overview keeps the guidance, framework mappings and Decisions. Overview is the one tab shown without a company, so a reader with no company still needs to see the linked content: in that case Overview keeps a read-only Linked content list.

### Evidence tab, full width, four sections in this order

1. **Security Assurance Plan**: today's Evidence of operation card (`evidence/EvidenceOfOperationCard.tsx`). It shows the plan activities that prove the control works, last done and next due, with "Add to the plan". The content is unchanged, laid out for the wider space.
2. **Managed Content**: the policies, standards, procedures and runbooks in Content that govern this control.
   - **The domain's policy is shown first, by membership.** A policy covers every control in its domain without a link. It is marked "Covers every control in <domain>" and can't be unlinked here.
   - Then each **linked** document, as today's Linked content does, showing its title (opening the document), type, status and last reviewed or published date.
   - **Link content**: a picker searching Content by title and type, offering documents not already linked, including another domain's policy. Choosing one links it.
   - **Unlink**: on each linked document, asking first.
   - Both use the existing link and unlink on the content side (`POST /api/v1/content/{slug}/controls/{control_id}`), so they need **playbook author** rights. Anyone else sees the list without the buttons.
   - Links are part of the shared playbook, so every company sees them. The picker says so ("Linked for every company").
   - Empty state: "No standards, procedures or runbooks are linked to this control."
3. **Automated Collection**: what Compass gathers by itself.
   - **Built-in checks** speaking to the control (today's Checks card, `checks/ChecksCard.tsx`).
   - **Collected checks** (today's How Compass collects this, `collection/CollectionCard.tsx`).
   - The section heading carries the coverage words, e.g. "Partly automated · Evidence only".
   - **Made readable.** Each check is one row or compact card: name, Covers (full/partly), Doing pill, account, last capture, next due, and links to the page (PDF) and raw data.
   - Its detail sits behind a "Details" toggle: "Still needs a person", the reads, and the rule with its approve/edit.
   - The four stacked buttons per check (Ask Polaris for a rule, Collect now, Ask Polaris to check this, Re-create) become one action menu per row. Write a rule / Advanced go in the same menu.
   - "Ask Polaris for another check" sits once, at the foot of the section.
   - Waiting proposals and held captures sit at the top of the section, as they need a person.
4. **Manual Collection**: the evidence in the Evidence register linked to this control by hand (uploads, links, documents). This is what Audit ▸ Evidence ▸ By control shows for the control (`audit/ControlEvidenceView.tsx` and `LinkedEvidenceList`), with "Add evidence" for whoever may add it. Collected captures are not repeated here: they belong to Automated Collection. Empty state: "No evidence has been added by hand for this control."

### Risks tab

Today's `ControlRisksCard`, full width and unchanged in content: the risks the control is an exception to, then the risks it reduces.

## Done when

- The tabs read Overview · Evidence · Gaps · Risks · History. The URL `?tab=evidence` and `?tab=risks` work and are kept on reload, as the other tabs are.
- The side pane holds only Standing and Open gaps.
- Each section has a heading and an empty state, and a section a person can't read isn't shown. Evidence of operation keeps its "each source decides who may read it" rule.
- **Managed Content**:
  - It shows the domain's policy by membership plus the linked documents.
  - A playbook author can link and unlink from the control page. The document's own page then lists the control, and the reverse also holds.
  - Someone without author rights sees no buttons.
  - Tests cover link, unlink, the membership policy not being unlinkable, and the buttons being hidden without rights.
- Collected checks are one row each with details folded away and one action menu. Six checks on SOD.9 fit on one screen with every row folded.
- Screen conventions hold: no pill truncates, fields on one row line up (COM-1623), and the tab bar folds into More on a narrow screen.
- Links that pointed at the old cards still land: "View" from a check, Fix sign-in actions, Review tab links and audit look-over flags open the control on the Evidence tab.
- The Browser smoke (`app/e2e`) covers the two new tabs for each test account. Page tests are updated.
- On staging: SOD.9 in Test Company reads cleanly on the Evidence tab, and the Secure Development policy shows under Managed Content. Linking a procedure from there shows it on the procedure's page. Risks is its own tab.

## Where

- `pages/ControlDetailPage.tsx`: the tabs, the side pane, and Overview's Linked content.
- `evidence/EvidenceOfOperationCard.tsx`
- Managed Content uses the content link API in `api/v1/content.py` (`link_control`, and the unlink beside it), checks `require_playbook_author`, and needs a content search for the picker. It also needs the domain's policy on the control detail. Check whether `CoreControlDetail` already carries it, and add it if not: that would be an API change, on the chain.
- `checks/ChecksCard.tsx`
- `collection/CollectionCard.tsx`: the per-check layout.
- `audit/ControlEvidenceView.tsx` and `LinkedEvidenceList.tsx`
- `components/ControlRisksCard.tsx`
- Links into the control page: actions, the Review tab, audit flags.