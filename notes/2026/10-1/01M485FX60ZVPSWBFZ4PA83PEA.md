---
id: 01M485FX60ZVPSWBFZ4PA83PEA
created: 2026-10-06T08:32:42.176947Z
updated: 2026-10-06T12:43:38.76885Z
type: task
title: 'Joiner fields: Manager, Country and hire date — each with its own picker on the joiner form'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 842
sprint: sme8esk
blocked_by:
- 01M484XF1XJ6HQSXY426KN26XC
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Asked for by Steve, 2026-10-06. Fourth of four — builds on COM-839 (the Joiner fields list), COM-840 (the form and the request) and COM-841 (writing to the account), which cover text fields. These three can't be typed: each needs a picker.

## What people see

**On Access Control ▸ Admin ▸ Joiner fields**, three more entries in the "Add field" picker, added, renamed, made required and ordered like any other:

| | Active Directory | Entra ID |
|---|---|---|
| **Manager** | yes | yes |
| **Country/region** | yes | yes |
| **Employee hire date** | — | yes |

**On the joiner form** (and wherever a joiner's details can be corrected at approval):

- **Manager** — a people picker: type a name or email, pick the person. It offers people who have an account in the directory the starter is being created in and who haven't left. The request shows the manager by name.
- **Country/region** — a searchable list of countries. No typing "UK" one day and "United Kingdom" the next.
- **Employee hire date** — a date picker.

**On the new account:**

- Manager is set to that person, exactly as if chosen in the directory's own tools. In Hybrid it is set in Active Directory and reaches Entra through the sync.
- Country is set the way the directory's own tools set it — in Active Directory that fills all three of the places AD keeps a country, so address books and other systems read it correctly.
- Hire date is set on the Entra account.

**If the chosen manager has left or been removed by the time the request runs**, the joiner shows Failed with "the manager chosen no longer has an account" — correct it and Retry. The account is never created with a missing or wrong manager silently.

## Hire date and Active Directory

Active Directory has **no hire-date field** — it's an Entra-only detail, which is why it's only in the Entra ID list. In AD only and Hybrid, an organisation that wants it recorded uses one of the extension attributes (COM-839) as a text field named "Hire date"; in Hybrid their directory sync can be set to carry that across into Entra's hire date. Compass doesn't configure the sync.

## Decisions taken (say if any is wrong)

- **Manager must already have an account.** Raising a joiner whose manager is also a joiner in the same request isn't supported — the manager's request goes first.
- **Country is independent of Usage location** (the licensing country Entra asks for, which the request already carries). Choosing a Country doesn't change it.
- **No default values** (e.g. Country pre-set to United Kingdom) — not asked for; a follow-on if wanted.

## Notes (technical)

- Catalogue (`kind` was added in COM-839 as `text` only): add `person`, `country`, `date`.
  - AD: `manager` (kind `person`) · `country` (kind `country`; one catalogue entry that writes `c` = ISO alpha-2, `co` = name, `countryCode` = ISO numeric, as ADUC does).
  - Entra: `manager` (kind `person`) · `country` (kind `country`; Graph `country` is free text — write the country name) · `employeeHireDate` (kind `date`; Graph wants a UTC timestamp — write midnight UTC of the chosen date).
- Snapshot on the request subject (COM-840) carries `kind`, so these need no change to its shape. Values: `person` → the directory user's Compass record id (plus the name as shown, for display if the record later vanishes); `country` → ISO alpha-2; `date` → `YYYY-MM-DD`. Validate by kind on raise and on a gate save.
- Manager picker: the existing directory-user search (`useDirectoryUserSearch` in `requestHooks.ts`), narrowed server-side to the directory in use — for AD, records with an AD anchor (`ad_object_guid`); for Entra, records with an Entra id — and to enabled, non-vanished people. Follow the picker-label conventions (`pickerLabels.ts`).
- Country list: reuse an existing ISO country list if the codebase has one; otherwise one module (alpha-2, numeric, name) shared by form and writer. Names should match what ADUC writes to `co` where they differ from ISO short names.
- Writing:
  - AD manager: resolve the manager's **current** DN from their record at run time (not a DN stored at raise — people get moved between OUs) and put `manager` on the same `connection.add`. No AD anchor / vanished → fail the subject with the plain message.
  - AD country: the three attributes on the same `add`.
  - Entra manager: `manager@odata.bind` on `POST /users` if Graph accepts it on create; otherwise `PUT /users/{id}/manager/$ref` straight after — covered by COM-841's "retry finishes an account Compass made" rule.
  - Entra hire date / country: on the create body.
- The request page shows the manager's name (resolved, with the snapshot name as fallback), the country by name, the date in the app's date format; the before/after rows at a gate do the same.

## Done when

- Manager, Country/region and (Entra) Employee hire date can be added to the lists and appear on the joiner form as a people picker, a country list and a date picker.
- A joiner created in AD has `manager`, `c`/`co`/`countryCode` set; one created in Entra has its manager, country and hire date.
- A manager who has gone fails the joiner with the reason; correcting and retrying works.
- Tests: each picker on the form and at the gate; validation by kind; AD writes against the Samba test DC; Entra payloads; the vanished-manager path.
- Smoke-tested on staging: a joiner with a manager and a country, checked in ADUC.