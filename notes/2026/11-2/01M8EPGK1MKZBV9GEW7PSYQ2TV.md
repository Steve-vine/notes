---
id: 01M8EPGK1MKZBV9GEW7PSYQ2TV
created: 2026-11-27T14:28:24.24447Z
updated: 2026-11-28T00:24:06.5067Z
type: task
title: 'A new starter can''t share a logon name, email address or display name with anyone already in AD or Entra ID: checked before the request can be submitted, and Compass never changes what was typed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2191
sprint: snt3b17
blocked_by:
- 01M8ENT87ES4E934SHQ0GZD36J
comments:
- id: 01M8FNH5YFHYMK30ZAFYK6QYYZ
  author: Steve Vine
  at: 2026-11-27T23:30:29.455647Z
  text: |-
    Built: PR #2211, merged to main (not on staging yet; it goes with the sprint deploy).

    What's there:
    - **As the joiner form is filled in**, it says under each box whose the name already is: "The display name John Smith already belongs to John Smith (john.smith@moneypenny.com, Sales)". It checks:
      - the sign-in name, as anyone's sign-in name;
      - the sign-in name as any address held by a person, group, mail contact or shared mailbox;
      - the display name, anywhere in the directory;
      - the logon name, in AD.

      Disabled accounts count. Two joiners on one request can't share a name. **Submit stays unavailable** while anything clashes.
    - **AD joiners have a Logon name box**: required, 20 characters at most, AD's allowed characters. It's filled from the sign-in name only when that's a valid logon name exactly as it stands, and it's always editable. **What's typed is what's created**: Compass no longer picks, shortens or numbers it.
    - **Checked against the directories themselves** (aliases included, AD and Entra ID both in hybrid) when the joiner is submitted or corrected, when it's approved, and just before the account is created. A clash stops the joiner **before anything is created**, saying what clashed and who has it. A directory that can't be asked holds the request; it's never waved through.
    - **Compass no longer takes over an existing account.** Until now, an account that already had the sign-in name was adopted as the new starter's. Only two accounts are adopted now: one an earlier attempt of this request made (Retry still finishes it), and one a person made for this joiner's "create this account" to-do (COM-2185).
    - **A joiner raised before this** is checked at approval. An approver can correct it, including giving it a logon name. Correcting or amending a joiner never counts their own account as a clash.
    - **Polaris** raising an AD joiner takes a logon name. It uses the name before the @ only if that's valid as it stands, and otherwise asks. It gets the same refusals, naming who has the name.

    For you to look at:
    - **Renaming in a mover**: Compass can't change a display name or sign-in name in a mover today, so there's nothing to check there yet.
    - **The live checks are tested against fakes.** Pre-UAT can show the form and Compass's own copy of the directory. Checking a real alias clash needs the real AD or Entra connection, so that one is for you on staging.
- id: 01M8FRKBKA9HC47JTYW2ADM72V
  author: Steve Vine
  at: 2026-11-28T00:24:06.506357Z
  text: |-
    Pre-UAT, staging 20261127-2345, as E2E Access Manager (New request ▸ Joiner; nothing submitted): **Passed for the form; Couldn't check the live checks.**

    1. The form has the new **Logon name** box (required, "DOMAIN\name — 20 characters at most"). It's filled from the sign-in name only when that's valid as it stands.
    2. Display name "Compass Test" with sign-in name "Compass.Test" (an existing account) showed, under each box:
       - "The display name Compass Test already belongs to Compass Test (Compass.Test@moneypenny.co.uk)";
       - "The sign-in name Compass.Test@moneypenny.co.uk already belongs to …";
       - "The logon name Compass.Test already belongs to …".

       Submit stayed unavailable.
    3. Changing to free names cleared all three.

    Couldn't check:
    - the checks against the directories themselves (aliases);
    - a clash appearing after approval stopping the joiner before anything is created.

    Both need the real AD and Entra connections and a submitted joiner, and both are proven against fakes in the tests. Please try one with a shared mailbox's alias.

    Small finding (fix-forward task to follow): just after you change a name, the old message lingers for a moment until the check for the new name comes back. Submit stays unavailable meanwhile, so it's safe.

    Screenshots: ~/compass-uat/scripting/COM-2191/.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
**On the chain** (a new logon name field on the joiner request; new refusals in the request API). Build after **COM-2190** (same form).

Steve's rule, 27 Nov 2026: *"For both AD and Entra ID, it should not be possible to create users with the same login ID/username, email address or display name. Compass should check first to see if any of these will exist and not allow the user to submit the request until they are fixed. Compass should never change the details itself, what the user adds should be what is created."*

## What happens today (all at creation, after approval)
- **Same sign-in name** as an existing account: Compass **adopts that account** as the new starter's, in AD and Entra. A typo can hand a new starter a colleague's account.
- **Same logon name** (DOMAIN\username): Compass picks the logon name itself from the sign-in name, **cut to 20 characters and numbered** until free. The requester never sees it.
- **Same display name**: not checked. In AD, a second "John Smith" in the same OU fails after approval ("AD already holds an object named John Smith in that OU"). Entra allows duplicates.
- **Same email address**: not checked.

## What people see
- **The joiner form checks, as each box is filled**, that nobody in the directory the account will be created in already has:
  - the **sign-in name**: as anyone's sign-in name;
  - the **email address**: the sign-in name, which becomes the new starter's address, as anyone's email address **or alias**, including shared mailboxes, distribution lists, mail-enabled groups and mail contacts;
  - the **display name**: anywhere in the directory, not only the same OU. Two people called John Smith need different display names ("John A Smith");
  - in AD, the **logon name**.
  Under the box it says who has it: "John Smith already belongs to John Smith (john.smith@moneypenny.com, Sales)". Disabled accounts count; they still exist.
- **Hybrid companies** are checked against both AD and Entra ID.
- **The request can't be submitted** while anything clashes. Two joiners on the same request can't clash with each other either.
- **AD joiners get a Logon name box** (required, up to 20 characters, AD's allowed characters, the reason said under the box). It's suggested from the sign-in name as you type, *only when the suggestion is valid as it stands*, and is always visible and editable. What's in the box is what's created. Compass no longer picks, shortens or numbers it.
- **Compass never changes a detail.** The display name, sign-in name, email address and logon name created are exactly what was submitted. The account's name in AD is the display name as typed.
- **Checked again when submitted** (against the directory itself, so a change in the last few minutes counts), **when an approver approves**, and **just before creating** (time may pass between them). If something now clashes, the joiner **stops before anything is created**. It says what clashed and who has it, and the request can be corrected. Compass never adopts someone else's account and never works round a clash.
- **Retries still work**: an account *this request* already created (or one an admin created by hand for this request's to-do, COM-2185) is finished, not refused.
- **Renaming someone** in a mover (display name or sign-in name changed) is held to the same rule. Their own current values don't count as a clash.
- **Polaris** raising a joiner gets the same refusals, saying who has the name.

## Notes (technical)
- Mirror: `DirectoryUser` has `display_name`, `user_principal_name`, `mail`, `ad_sam_account_name`; `DirectoryGroup.mail`, `DirectoryContact.mail`. **No proxyAddresses/aliases are mirrored**, so the as-you-type check is from the mirror (cheap), and the submit/approve/create checks query live:
  - Graph: `users?$filter=userPrincipalName eq …` / `mail eq …` / `proxyAddresses/any(p:p eq 'smtp:…')` / `displayName eq …`, plus groups and contacts by mail/proxyAddresses (needs `ConsistencyLevel: eventual` for some filters).
  - AD (LDAP): `(|(userPrincipalName=…)(sAMAccountName=…)(mail=…)(proxyAddresses=smtp:…)(displayName=…)(cn=…))` over the whole domain, not just the managed OUs.
  - Case-insensitive throughout.
- New API endpoint for the form's check (per field, debounced), returning the holder's name, sign-in name and department; and the same check in raise, correct, approve, and execute.
- `AccessSubjectIn` gains `sam_account_name` (AD joiners). Validate 20 characters and `_SAM_FORBIDDEN`. Remove `ad_writer.unique_sam_account_name`'s truncation/numbering; `create_user` takes the submitted value.
- Adoption: `ad_writer.find_user_by_upn` (`_join_on_prem`) and the Entra GET in `_join_in_cloud` currently adopt any account with the UPN. Restrict to an account this request made (`_made_by_this_request` / ledger) or the COM-2185 to-do's account; otherwise fail the subject before any write, with the clash.
- Entra `mailNickname` = the part before the @ unchanged (COM-2190 keeps the allowed characters compatible).
- Requests already raised under the old rules: re-checked at approval like any other, so an existing clash shows there.
- Tests: Samba-backed AD (`test_ad_samba.py`) for the LDAP clash search; Graph fakes for the cloud.

**Done when:** on staging, in E2E Test Company, the joiner form refuses (and won't submit) a new starter whose sign-in name, email address, display name, or (AD) logon name matches an existing account (including a shared mailbox's alias and a disabled account), naming who has it. A clean joiner is created with exactly the display name, sign-in name and logon name typed. A clash introduced after approval stops the joiner before anything is created, rather than adopting or renaming.