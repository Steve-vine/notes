---
id: 01KYWAG5YAEZS6642BQCBH9VBV
created: 2026-07-31T14:50:51.722888Z
updated: 2026-08-05T19:02:10.219049Z
type: task
title: 'Docs: Security — roles &amp; access'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 431
order: 0.00390625
sprint: sp3en5k
comments:
- id: 01KYWBJ7S3P70F9D2YPJ0Y6CSY
  author: Steve Vine
  at: 2026-07-31T15:09:27.715504Z
  text: |-
    Done on feature/ise-431-docs-roles — PR #26, left OPEN for review.

    Full access model: five-rung cumulative capability matrix (viewer / responder / operator / approver / admin) with the responder rung's service-desk rationale and bounded surface; API-boundary enforcement with "hiding a button is a convenience, not a control"; Entra OIDC (auth code + PKCE), roles from group membership so revocation lives in the existing JML process, ISE-issued short-lived sessions, frontend never handles Entra tokens; break-glass with the honest framing (Entra is itself managed, so SSO-only locks you out during the very incident), hash-only + no reset flow + alert and audit on every use, "mitigated by making it impossible to use quietly"; separation of duties enforced in the state machine not by convention, the playbook publish-time variant, admin self-approval distinctly audited; AI containment section — allow-listed read-only tools, proposal agents see descriptions never execution, assist's read-only DB transaction as mechanism-not-convention, the prompt-injection blast-radius argument ("read-only is not the same as harmless… it cannot make ISE act"), streamed redaction accumulated-and-scrubbed-whole against split secrets. Facts from ADRs 0015/0017/0023/0056 + security-model brief. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/security/roles.md` with real content: the role ladder (viewer < responder < operator < approver < admin) with a capability matrix — who can see, execute published playbooks, propose, approve, and administer; Entra ID (OIDC) sign-in and how roles derive from group membership; the sealed break-glass account, when to use it and the alerting on every use; per-user API/MCP tokens.

Ground in ADRs 0015, 0056 (the responder rung), 0017, and `../ise/docs/briefs/security-model.md`. Operator audience, released capability only.