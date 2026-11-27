---
id: 01M8ENT87ES4E934SHQ0GZD36J
created: 2026-11-27T14:16:12.270567Z
updated: 2026-11-27T23:14:31.794577Z
type: task
title: 'The joiner form only accepts what the directory can create: every field held to its limit and allowed characters as it''s typed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2190
sprint: snt3b17
comments:
- id: 01M8FMKXPD4YZFZBBS52544AD8
  author: Steve Vine
  at: 2026-11-27T23:14:30.732936Z
  text: |-
    Built: PR #2210, merged to main (not on staging yet; it goes with the sprint deploy).

    What's there:
    - **Display name**: 64 characters at most where new starters are made in Active Directory (AD names the account after it), and 256 in Entra ID. The box stops at the limit and shows a count as you near it ("58 / 64"). The server refuses a longer one with the reason, rather than AD refusing it after approval. Compass never shortens it.
    - **Sign-in name**: the name before the @ takes exactly what Entra ID allows: letters A to Z, digits and ' . - _ ! # ^ ~, with no accents or spaces, 64 characters at most, and no full stop at either end. Each problem is said under the box as you type, naming the characters it can't have. Before, accented letters and $ % & got through.
    - **Every extra detail** is held to its directory's limit as it's typed, with a count near the limit and an example where a format applies (preferred language).
      - **Entra ID details now have limits**, taken from Microsoft's documentation (job title 128, department 64, employee ID 16, postal code 40, other emails 250 each, and so on).
      - Where Microsoft documents none (office, fax, business phone, employee type, division), the AD attribute it syncs from sets the limit.
    - **Submit stays unavailable** while anything is over a limit. The same limits apply when correcting a request, in a role's joiner defaults (Save stays unavailable) and in a mover's account details.
    - **A joiner raised before this** that is now over a limit shows each problem under the person, and approval is refused until it's corrected.
    - **Polaris** is told every limit and the sign-in name rule, and that nothing is shortened to fit. It gets the same refusals in words.

    For you to look at:
    - **Cost center** has no documented Entra limit and no AD equivalent, so I set it to 64. Say if your tenant takes more.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
**On the chain** (the joiner form's limits come from the API; the request API takes on new refusals).

Raised by Steve 27 Nov 2026 after asking how Compass stays inside AD's 20-character logon name. Fields can be typed in the form that the directory then refuses. Today a new starter with a display name over 64 characters is raised, approved, and only then fails with "AD refused to create the account". **Steve's rule: the form deals with the limits. Nobody can enter anything that is invalid or that the directory can't create. Compass never changes the details itself: what the user enters is what is created.**

Duplicates (the same logon name, email address or display name as an existing account) and the AD logon name box are **COM-2191**. This task is about length and allowed characters.

## What people see
- **Display name**: can't be longer than the directory allows. That's **64 characters** when the account is created in Active Directory (AD names the account after it) and 256 in Entra ID. The box stops at the limit and shows a count as you near it ("58 / 64"). Compass never shortens it.
- **Sign-in name**: the name before the @ is held to 64 characters and the allowed characters **as it's typed**, with the reason shown under the box. Today that's only checked on submit. The domain is still picked from the allowed list.
- **Every extra detail** (job title, department, phone, extension attributes…) is held to its own limit and format as it's typed, with the same count. Today the AD limits are only checked on submit, and the **Entra ID** details have no limits at all; they get Entra's own.
- **The request can't be submitted** while any field is over its limit or holds a character it can't have. Each problem is said under its own box.
- **The same limits apply wherever these fields are typed**: a role's joiner defaults (Access Control ▸ Admin), a mover's account details, correcting a request before approval, and Polaris raising a joiner (it's told the limit and the reason, not a bare error).
- A value raised before this change and now over a limit is shown with the reason and must be corrected before it can be approved. It never fails at creation.

## Notes (technical)
- Display name: `AccessSubjectIn.display_name` is `max_length=255` (`api/v1/schemas.py`). The AD account's CN is the display name (`ad_writer.create_user`, `cn` rangeUpper 64). Choose the limit by the directory the joiner is created in (`joiner_fields.directory_in_use`). Never truncate.
- Sign-in name: `sign_in_domains._check_name` already enforces 64 characters plus forbidden characters server-side. Expose the same rule to `SignInNameInput` (the joiner form response, or a shared constant), so the form says it first. Entra's `mailNickname` is the part before the @; make sure the allowed characters also suit it, so Compass never alters it.
- Extra details: AD lengths are in `core/joiner_fields.py` (`_ACTIVE_DIRECTORY`, rangeUpper, held by `test_ad_samba.py`). `_ENTRA_ID` entries have no `max_length`; take each from Microsoft Graph's user resource documentation. The frontend (`JoinerFieldInput`, `JoinerFieldsSection`, `SubjectFieldsEditor`) applies no `maxLength` today; pass `max_length` (and `pattern`) through the form response and apply them. List fields hold each value to the limit.
- Same checks in the role-defaults editor, mover account details, request correction and the Polaris joiner tools (`assistant/tools/access_*`).
- OpenAPI/schema.d.ts regen. Build before COM-2191 (it adds the logon name box to the same form).

**Done when:** on staging, in E2E Test Company, the joiner form won't take a 65-character display name (AD company), a sign-in name with a space or over 64 characters before the @, or a job title over its limit, says why under each box as it's typed, and keeps Submit unavailable until they're fixed. The same values are refused through Polaris and in a role's joiner defaults.