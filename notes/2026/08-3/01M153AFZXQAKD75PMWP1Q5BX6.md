---
id: 01M153AFZXQAKD75PMWP1Q5BX6
created: 2026-08-28T21:09:58.909966Z
updated: 2026-08-29T17:03:37.470527Z
type: task
title: Mirror conditional access policies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 501
sprint: s5cyp1z
comments:
- id: 01M16ZGR77PAYGT71KVN5A18QB
  author: Steve Vine
  at: 2026-08-29T14:41:58.503627Z
  text: |-
    Done — PR #511, merged to main (fcf73aa).

    The rule is stored as Graph reports it and interpreted in the catalogue, never at sync time. Conditions, grant controls and session controls are kept whole. The condition grammar is Microsoft's and it changes; flattening "what this policy means" into a handful of columns would be a translation, and a translation that goes wrong goes wrong quietly — the policy would keep reporting, and keep answering a slightly different question from the one in Entra. Keeping the structure means a derived field can be corrected in a release rather than a resync.

    The state is Entra's own word too, for the same reason an unrecognised value must mirror rather than fail the pass.

    Two things are normalised out, and only two: the principals a policy includes or excludes, and the applications it covers. Both because the reports that matter cannot be asked of a JSON array — "who is excluded from this policy" and "which applications no policy covers" need rows to filter and join.

    The excluded principals are the point of mirroring this at all. Includes share the table with a flag, because the same principal can legitimately be both on one policy — two facts, not a contradiction. Entra's own words (All, None, GuestsOrExternalUsers) are kept as targets rather than interpreted here.

    Policies are marked when they leave the tenant and never deleted, so a report run that named one keeps resolving it. What a policy targets is a current-state fact and is reconciled: an exclusion somebody removed stops appearing, or the auditor's list is wrong in the direction that matters.

    **Needs a second admin consent.** `Policy.Read.All` on the compass-access app registration, alongside the `Application.Read.All` from COM-498 — same place, same consent-then-restart caveat. Until it is granted the conditional access screens and reports are empty and the Integrations card says why; "this tenant enforces no conditional access" is a finding somebody would act on, and it must never be what a missing grant looks like. Setup instructions updated in `scripts/entra/README.md`.

    Nothing user-visible on its own — COM-502 is the screens and the reports over this.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
The rules that decide whether a sign-in is allowed — the controls a framework assessment claims credit for, and which Compass has never read.

Mirror each policy: name, **state** (enabled, disabled, or report-only), created and last modified, and the shape of the rule — who it includes and excludes (users, groups, roles, guests), which applications it covers, the conditions (platforms, locations, client apps, sign-in risk), and what it grants or blocks (MFA required, compliant device required, block access), plus its session controls.

Needs **`Policy.Read.All`**, a new grant with the same consent-then-restart caveat as COM-498.

**Store the rule as Graph reports it, and interpret it in the catalogue — never at sync time.** The condition grammar is Microsoft's and it changes; a mirror that flattens *what this policy means* into a few columns is a translation that will be wrong quietly. Keep the structure, and derive the fields reports need (*does it require MFA*, *does it exclude anybody*, *how many users are excluded*) where they can be corrected without a resync.

The **excluded** principals are the point of mirroring this at all. Every real tenant has a break-glass account and a handful of exceptions nobody has revisited, and a list of them is the report an auditor asks for by name.