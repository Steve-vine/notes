---
id: 01M0Z99GEZDKB4FBGANKXRERFA
created: 2026-08-26T14:58:51.487838Z
updated: 2026-08-26T15:02:03.239627Z
type: task
title: HIPAA says which specifications are required and which are addressable
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 421
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: backlog
---
Every one of the 58 stored HIPAA references is real and correctly cited. Two
things are wrong around them.

**There is no required / addressable flag.** That distinction is the central
mechanic of the Security Rule. "Addressable" does not mean optional — it means
assess whether the specification is reasonable and appropriate, implement it if
so, and if not, document why and implement an equivalent alternative. A Compass
assessment that cannot express "addressable, alternative implemented, here is the
rationale" cannot produce a defensible answer for roughly half the rule.

**The selection rule is inconsistent.** The library lists *implementation
specifications* where they exist and *standards* where they do not, so the parent
standards are silently absent:

`164.308(a)(1)(i)`, `(a)(3)(i)`, `(a)(4)(i)`, `(a)(5)(i)`, `(a)(6)(i)`,
`(a)(7)(i)`, `164.310(a)(1)`, `164.310(d)(1)`, `164.312(a)(1)`, `164.312(c)(1)`,
`164.312(e)(1)`, `164.314(a)(1)`, `164.316(b)(1)`.

Thirteen references. Each is a standard in its own right that an auditor
assesses, and several have no implementation specifications beneath them at all.

## What changes for the reader

The framework reads as the rule is written: standards, with their implementation
specifications nested beneath, each marked **required** or **addressable**.

An addressable specification can be answered three ways — implemented; not
implemented with an equivalent alternative and a rationale; or not reasonable and
appropriate, with a rationale. The first is a control assessment. The other two
are documented decisions, and they belong in the record, not in someone's head.

## Implementation

- `requirement_kind` (`standard` / `implementation_specification`) and
  `hipaa_designation` (`required` / `addressable`) on the framework requirement.
  Name the second generically if a future framework wants the same idea —
  `designation` with a per-framework vocabulary — but do not build the vocabulary
  machinery for one caller.
- Parent/child via a self FK on the requirement, so the nesting is real and the
  UI can render the rule's structure. Coverage rolls up from specifications to
  standards.
- The addressable rationale is a per-company record, so it belongs with the
  applicability work rather than duplicating it — reuse
  `company_framework_requirement` and give it a `rationale` field that the
  addressable path requires.
- Add the 13 missing standards; keep display order matching the CFR.

**On currency.** The January 2025 NPRM would remove "addressable" entirely and
make every specification required. OMB now targets **July 2027** for final
action, and it may still change or be withdrawn. Do not pre-empt it — but model
the designation as data so the eventual change is an import, not a migration.

Tests: coverage rolls from specification to standard; an addressable
specification accepts an alternative-with-rationale answer and a required one
does not; the 13 standards appear in CFR order.
