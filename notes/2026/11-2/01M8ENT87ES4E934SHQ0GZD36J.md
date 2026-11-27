---
id: 01M8ENT87ES4E934SHQ0GZD36J
created: 2026-11-27T14:16:12.270567Z
updated: 2026-11-27T14:16:16.763545Z
type: task
title: 'The joiner form only accepts what the directory can create: every field held to its limit as it''s typed, and a sign-in name someone already has is refused'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2190
sprint: snt3b17
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
**On the chain** (the joiner form's limits come from the API; the request API takes on new refusals).

Raised by Steve 27 Nov 2026 after asking how Compass stays inside AD's 20-character logon name. The logon name is handled: Compass builds it from the sign-in name, cut to 20 characters and numbered if taken. But other fields can still be typed in a form that the directory then refuses. Today a new starter with a display name over 64 characters is raised, approved, and only then fails with "AD refused to create the account". **Steve's rule: the form deals with the limits. Nobody can enter anything that is invalid or that the directory can't create.**

## What people see
- **Display name**: can't be longer than the directory allows. That's **64 characters** when the account is created in Active Directory (AD names the account after it) and 256 in Entra ID. The box stops at the limit and shows a count as you near it ("58 / 64").
- **Sign-in name**: the name before the @ is held to 64 characters and the allowed characters **as it's typed**, with the reason shown under the box. Today that's only checked on submit. The domain is still picked from the allowed list.
- **A sign-in name someone already has** is refused on the form: "ada.lovelace@moneypenny.com already belongs to Ada Lovelace". Today nothing checks this, and if the account exists in AD, Compass adopts it as the new starter's. Re-running a joiner, or adopting an account an admin made by hand for it (COM-2185), still works, because that happens after the request is raised, not on the form.
- **Every extra detail** (job title, department, phone, extension attributes…) is held to its own limit as it's typed, with the same count. Today the AD limits are only checked on submit, and the **Entra ID** details have no limits at all; they get Entra's own.
- **The same limits apply wherever these fields are typed**: a role's joiner defaults (Access Control ▸ Admin), a mover's account details, correcting a request before approval, and Polaris raising a joiner (it's told the limit and the reason, not a bare error).
- A value raised before this change and now over a limit is shown with the reason and must be corrected before it can be approved. It never fails at creation.

## Notes (technical)
- Display name: `AccessSubjectIn.display_name` is `max_length=255` (`api/v1/schemas.py`). The AD account's CN is the display name (`ad_writer.create_user`, `cn` rangeUpper 64). Choose the limit by the directory the joiner is created in (`joiner_fields.directory_in_use`). Alternatively keep displayName up to 256 and cut only the CN; Steve's rule favours refusing on the form.
- Sign-in name: `sign_in_domains._check_name` already enforces 64 characters plus forbidden characters server-side. Expose the same rule to `SignInNameInput` (the joiner form response, or a shared constant), so the form says it first.
- Duplicate sign-in name: check the directory mirror (`DirectoryUser.user_principal_name`, case-insensitive) when the request is raised and corrected. Also note `ad_writer.find_user_by_upn` adopts an existing AD account silently at creation; keep that for reruns, but the form check stops a live person's account from being taken over.
- Extra details: AD lengths are in `core/joiner_fields.py` (`_ACTIVE_DIRECTORY`, rangeUpper, held by `test_ad_samba.py`). `_ENTRA_ID` entries have no `max_length`; take each from Microsoft Graph's user resource documentation. The frontend (`JoinerFieldInput`, `JoinerFieldsSection`, `SubjectFieldsEditor`) applies no `maxLength` today; pass `max_length` (and `pattern`) through the form response and apply them. List fields hold each value to the limit.
- Same checks in the role-defaults editor, mover account details, request correction and the Polaris joiner tools (`assistant/tools/access_*`).
- OpenAPI/schema.d.ts regen.

**Done when:** on staging, in E2E Test Company, the joiner form won't take a 65-character display name (AD company), a sign-in name with a space or over 64 characters before the @, a sign-in name an existing person already has, or a job title over its limit, and says why under each box as it's typed. The same values are refused through Polaris and in a role's joiner defaults.