---
id: 01M4RW1BDDBTCVDS55TACHHGAG
created: 2026-10-12T20:14:33.389472Z
updated: 2026-10-12T23:04:05.716425Z
type: task
title: A Google Cloud project can be connected without a stored key — Compass signs in as the AWS identity it already has, and the project trusts exactly that
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 931
sprint: s70gjk2
blocked_by:
- 01M4RV0AXHZN6WTX3CVTP1XRXF
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 69, Inventory discovery - GCP (ADR in COM-924). Steve, 2026-10-12: "Add signing in without a stored key to this sprint." Follows the connection (COM-926) and comes before any reading, so a customer whose organisation blocks service account keys can still connect.

## What people see

- **Adding a Google Cloud project asks how Compass signs in:** with a key file (COM-926), or **without a stored key**. Each says in a line what it means.
- **Without a stored key, Compass holds nothing of Google's.** It proves who it is with the AWS identity it already has (Admin ▸ Integrations ▸ AWS identity), and the project is set up to trust that one identity and let it act as a read-only service account. No key is ever made, so an organisation's block on keys does not matter.
- **Compass shows what to set up on the Google side** as soon as the project ID is typed: who Compass is in AWS (the account and the role or user), the role file, and the commands already filled in. They create the role, the service account, the trust in Compass's AWS identity, and the permission for it to act as the service account. The last command prints the two things to enter.
- **It asks for** the project ID, a name, the service account's email address, the name of the trust it created, and Production or Non-production.
- **Test** names the project it reached, or says why not, in plain words. Beyond the reasons a key file can fail: Compass has no AWS identity yet (and where to set one), the project does not trust that identity, the identity may not act as the service account, or a Google service this way of signing in needs is not switched on.
- **Where it is not offered, it says why.** A deployment with no AWS identity sees the choice greyed with "set one under Admin ▸ Integrations ▸ AWS identity".
- **The screen is honest about what "no stored key" means here.** Where the platform gives Compass its AWS identity (production), nothing long-lived is stored anywhere. Where that identity is itself an access key someone entered (staging), that one key is what every project connected this way trusts, and the screen says so.
- **A project can be changed from one way to the other under Edit** without losing what was found in it. Changing to no stored key deletes the key.
- **Each row says which way it uses.**
- **Removing a project connected this way** also says to delete the trust on the Google side, since Compass cannot.
- **Who:** Inventory admins.

## Notes (technical)

- **Workload identity federation with an AWS provider.** `core/gcp.py` gains a second token source: a SigV4-signed `GetCallerIdentity` request (botocore's signer over Compass's own AWS credentials, taken through one accessor in `core/aws.py`, not a second credential path) is serialised as the subject token and exchanged at `sts.googleapis.com/v1/token`; the federated token then calls `iamcredentials.googleapis.com/…/serviceAccounts/{email}:generateAccessToken`. Everything after that is the same `get` and `pages`. No new dependency.
- **Impersonation, not direct access.** A federated principal can be given the role directly, but some Google APIs refuse a federated token. Acting as a service account works everywhere and keeps one role file for both ways.
- **The token is cached** until shortly before it expires, per connection, and dropped when Compass's AWS identity changes: the same moment the AWS role sessions are dropped.
- **`gcp_connections` gains** `auth` (`key` | `federated`) and `wif_audience` (the provider's full resource name); `key_encrypted` becomes nullable, with a check constraint that a row has what its way needs. Migration.
- **The trust must pin the identity, not the account.** The provider is created with an attribute condition on Compass's exact role (or user) ARN, from `trust_principal`. Without it anything in Compass's AWS account could sign in. The set-up commands carry it, a test holds the generated commands to it, and the README says why. An IAM user (staging) and an assumed role (production) arrive as different ARN shapes; cover both.
- **Nothing stands where AWS's external ID stands.** Federation has no counterpart, so a project that trusts Compass's identity would answer to any company in the deployment that typed its details. What holds: a project ID is unique across the deployment, only Inventory admins connect, and removal tells the person to delete the trust. The ADR says this plainly as an accepted cost, or records something better.
- **Set-up needs two more Google services switched on** in the project: Security Token Service and IAM Service Account Credentials. The commands do it.
- **Setup endpoint** returns Compass's AWS account, the principal to trust and the filled-in commands; `no_identity` when there is none.
- **Tests.** Google's two token endpoints are answered through the `core/gcp.py` seam; Compass's AWS identity through `tests/aws_fakes.py`. One test proves the subject token never reaches a log line.
- **Docs.** `docs/gcp/README.md` gains this way beside the key file.
- Regenerate `schema.d.ts`.

**Needs from Steve before smoke-testing:** Compass's AWS identity set on staging under Admin ▸ Integrations ▸ AWS identity (an IAM user with no permissions at all is enough: Google only asks AWS who it is), and the right to create a workload identity pool in the project (IAM Workload Identity Pool Admin).

**Done when:** on staging a project is connected without a key, Test names the project, the health pill is green, and nothing of Google's is stored for it.