---
id: 01M4N1Z0PM0D3NZH912E19KCKY
created: 2026-10-11T08:41:10.61259Z
updated: 2026-10-12T19:10:56.302769Z
type: task
title: An AWS account can be connected with its own read-only user and key — no single identity reaches more than one account
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 903
sprint: svsqcj9
comments:
- id: 01M4N3TBAGT7FSMKYFF65KQBWG
  author: Steve Vine
  at: 2026-10-11T09:13:34.800088Z
  text: |-
    Merged to main (PR #905, 2026-10-11). Not on staging yet: staging is promoted when Steve says.

    What to look at, under Inventory ▸ Settings:
    - Add account now asks "How Compass signs in". "Its own user" is chosen first: enter the access key ID and secret of a read-only user in that account. Add stays greyed until both are in. There is a button to download the template that creates the user.
    - "A role that trusts Compass" is the second choice and is exactly what was built before.
    - The account's row says which way it is read: "Its own user · key …1234" or "Through a role".
    - Set up and test, for an own-user account, shows the key's last four characters, the template download and Test. No external ID, and no warning about Compass having no AWS identity.
    - Edit replaces the key (leave both fields blank to keep it), or changes the account from one way to the other. Changing to a role deletes the stored key.
    - AWS organisations: Connect an organisation has the same choice, there is a new Sign-in button to replace the organisation's key, and Switch on asks for the account's own key when "Its own user" is chosen.
    - Admin ▸ Integrations ▸ AWS identity now says it is only for accounts connected through a role. With none of those it is not checked and does not go red.

    Behaviour worth knowing:
    - A key that belongs to a different account is refused, with both account numbers in the message.
    - If AWS rejects a key (deleted or made inactive), the message says it is that account's key and where to replace it. Nothing is marked gone.
    - The key is never shown again, anywhere, and is not written to the activity log.
    - The template creates the user but not its access key. You make the key in AWS afterwards (IAM ▸ Users ▸ compass-discovery ▸ Security credentials). A key made by a template would be readable by anyone who can see the stack.
    - An organisation and its accounts can mix the two ways.

    Costs of this way, as agreed:
    - One long-lived key per account, and one per organisation, each rotated by hand.
    - Switching on an organisation's account is no longer one click.
    - Compass cannot tell whether a key's user has been given more than the template's policy. It checks the account number, not the permissions.

    Known limit: an own-user connection only works for ordinary AWS accounts. An account in AWS China or GovCloud has to connect through a role.

    Needed from you before this can be smoke-tested: an AWS account with the user from docs/aws/compass-discovery-user.yaml and an access key for it. Nothing needs entering under Admin ▸ Integrations first.

    Technical: ADR 0101 (amends ADR 0099 §7 and §8). Migration 0242 (auth, access_key_id, access_key_secret_encrypted on aws_connections and aws_organisations; role_arn nullable). New PATCH /inventory/aws-organisations/{id}. docs/aws/README.md rewritten for both ways, including key rotation. New shipped files compass-discovery-user.yaml and compass-organisation-user.yaml.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Part of sprint 67, Inventory expansion. Follows COM-882 and COM-890. Steve, 2026-10-11: "I would prefer to use a separate AWS IAM user per account rather than a single account that can access all of them."

As built, Compass has one AWS identity of its own, and every connected account has a role that trusts it. Outside AWS that identity is one long-lived key which can step into every connected account. This task makes the account's own user the normal way to connect.

## What people see

- **Adding an AWS account asks how Compass signs in**, and the first choice is "Its own user". You create a read-only user in that account from a template Compass gives you, make an access key for it in AWS, and paste the key in. There is no role and no external ID, and nothing has to be set up under Admin ▸ Integrations first.
- **The key is stored encrypted and is never shown again.** The account's row shows the last four characters of the key's ID, and "Replace key" swaps it.
- **Test, the health pill and the six-hourly read work as they do now.** If AWS rejects the key, the message says it is this account's key and where to replace it.
- **A key that belongs to a different account is refused**, with both account numbers named.
- **The other way stays**: "A role that trusts Compass's own identity", exactly as built. It is what an install inside AWS uses, where no key is stored at all. An account can be changed from one way to the other without losing what was found in it.
- **An organisation is connected the same two ways.** With its own user, the management account gets a user that can list the organisation's accounts and nothing else.
- **Switching on an account found through an organisation asks for that account's key** when the own-user way is chosen. It is no longer one click, which is the cost of not having an identity that reaches every account.
- **Admin ▸ Integrations ▸ AWS identity** says it is only needed for accounts connected through a role, and is not shown as a fault when nothing uses it.
- **Who:** an Inventory admin, as now.

## Notes (technical)

- **ADR.** A new ADR amending ADR 0099 §7, which considered and rejected an access key per connected account. Record why it is now offered and what it costs: N long-lived keys that can each read directly, against one that can read nothing by itself but can step into all; no external ID is needed because the key is handed over by the account's owner.
- **`aws_connections` and `aws_organisations`** gain `auth` (`role` | `access_key`, existing rows `role`), `access_key_id`, `access_key_secret_encrypted` (Fernet, `core.secretbox`; both names are on the redaction list). `role_arn` becomes nullable. New migration, append-only.
- **`core/aws.py`** stays the one client factory: a key connection signs with its own key directly, a role connection assumes as now. The partition for a read comes from who AWS says the caller is, not from the role ARN.
- **The shipped templates** gain `compass-discovery-user.yaml` and `compass-organisation-user.yaml`: an IAM user with the same generated least-privilege policy as the role, attached as a managed policy (a user's inline policies are capped at 2,048 characters). The template does not create the access key: that would put the secret in the stack's outputs.
- **The health check** no longer needs Compass's own identity when no connection uses a role.
- **API.** Create, update and switch-on accept `access_key_id` + `secret_access_key`; outs carry `auth` and `access_key_hint`, never the secret. An organisation gains an update route so its key can be replaced. Regenerate `schema.d.ts` and run the drift script.
- **Known limit.** A key connection is signed against the standard AWS partition; an account in China or GovCloud connects through a role.
- **Tests.** Integration: connect with a key, test, read, wrong-account key, rejected key, replace key, change way both directions, secret never returned or audited in clear, organisation by key, switch-on with a key, health pass with no identity. Vitest for the add form and replace key. Fixtures must not contain anything shaped like a real AWS key.

**Needs from Steve before smoke-testing:** an AWS account with the user from the template and an access key for it.

**Done when:** on staging, with nothing entered under Admin ▸ Integrations ▸ AWS identity, an account is connected with its own user's key, tests green, and is read.