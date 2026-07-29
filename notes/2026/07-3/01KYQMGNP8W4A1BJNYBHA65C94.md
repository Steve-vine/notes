---
id: 01KYQMGNP8W4A1BJNYBHA65C94
created: 2026-07-29T19:09:41.448004Z
updated: 2026-07-29T19:43:37.38906Z
type: task
title: AWS connector foundation — add an AWS account to ISE
project: 01KX671DATY39VW6GWK3M2T3DN
number: 358
sprint: sjyt01k
assignee: steve
label:
- feature
priority: medium
task_status: review
---
New `aws` connector type (read-only v1), per-account instances, static access-key auth.

- `connectors/aws.py`: `connector_type="aws"`, capabilities `{entities, alerts, evidence}`; `credential_spec()` = access key id + secret access key (secret) + default region (`secret=False`); `validate_credential()` structural checks; `health_check()` = STS GetCallerIdentity (surfaces account id); `sync_spec()` no slices; `action_catalogue() → []`, `_execute` raises (actions are next sprint).
- boto3 dependency; register in `connectors/__init__.py`; add credential key names to `REDACTED_KEY_PARTS` in `logging_setup.py` (ADR 0018 DoD).
- Per-instance config tenant `aws_config` (region list) in `System.config` with editor endpoint in `api/v1/systems.py` — kind_dictionary pattern, no migration.
- Write ADR 0058: AWS connector — per-account instances, static-key auth (read/write credential split reserved for the actions sprint), account-scoped native keys `aws:{account_id}:{arn}` (ADR 0045), alarm/Health→Alert mapping, new entity types.

**Done when:** an operator can add an AWS account in Settings (picker shows AWS with capability badges, auto-generated credential form), verify the credential, and see health green with the account identity.