---
id: 01M0PR2MDTQBFN810GZBW8DKN9
created: 2026-08-23T07:24:04.922861Z
updated: 2026-08-23T08:12:27.406074Z
type: task
title: 'Portal settings: the From address is settable — warning removed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 373
sprint: sbph5q5
comments:
- id: 01M0PTV6WEQP3BGM1HABMEZ8PY
  author: Steve Vine
  at: 2026-08-23T08:12:27.405951Z
  text: |-
    Done — PR #375 (green, merged), branch feature/com-373-from-address-settable.

    - **From address is a plain settable field** (`sender_from_email`) beside the display name; unset falls back to the platform transport. The tab shows the resulting header — `Display Name <address>` — instead of explaining itself.
    - **The deliverability warning is gone.** Validation is well-formed and nothing else: no SPF/DKIM check, no caveat copy. A check depending on the transport, its sending IPs and the company's DNS at send time would be wrong in both directions, and a warning that is sometimes wrong is worse than none. Where a provider refuses — SES on an unverified identity, Graph without SendAs — that surfaces as a mail error naming the address, which is the right place for it.
    - **Reply-To dropped**, per the ticket's recommendation: it carried the real address past a From that could not be theirs, and a From that can is the same fact. The transport-level `reply_to` in Admin ▸ Email is untouched — that is a platform setting.
    - Per-message From plumbed through all four transports. M365 sends it as `from` on the payload while the mailbox in the URL stays the transport's, because that is what the credentials authorise.

    **Migration 0101 is a rename, not a new column.** Every value stored in `sender_reply_to` means "mail from us reaches us here", which is exactly what the new field means — so a company that had set a Reply-To under COM-370 now *sends from* that address without being asked. That is the intended reading of what they configured and the reason the rename carries the data across; clearing the field opts out. Worth knowing before smoke-testing against data.

    **ADR 0053** records the decision and who now carries the deliverability risk — the "one line in the docs/ADR trail rather than in the UI" the ticket asked for.

    Tests: configured From reaches both email kinds (supplier invite and owner notice — separate code paths); unset falls back; the two halves are independent (name-only, address-only); invalid refused while an address on a domain Compass plainly does not control is accepted. Transport level for SMTP/SES/M365. New `PortalSettings.test.tsx` covers the field, the absent warning, the header preview and clearing.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
COM-370 shipped the safe variant of sender identity: custom display name on the platform From, custom address as Reply-To, with a deliverability warning about full custom From. Decided: promote the From address to a first-class setting and **remove the warning**.

- [ ] The Portal tab's sender-identity section gains the **From address** as a plain settable field (with the display name, rendering `Display Name <address>`); the deliverability warning copy goes.
- [ ] Vendor-portal emails (contact links, owner notifications) send **From** the configured address when set; fall back to the platform sender when unset. Decide whether Reply-To still mirrors the address or is dropped as redundant once From is real — recommend dropping it.
- [ ] Validation stays (well-formed address); nothing else second-guesses the operator — SPF/DKIM alignment for the chosen domain is deliberately the operator's responsibility now, which is the decision this task records. Worth one line in the mail-settings docs/ADR trail rather than in the UI.
- [ ] Tests: configured From lands on outgoing mail for both email kinds; unset falls back; display-name-only still works; invalid address rejected.