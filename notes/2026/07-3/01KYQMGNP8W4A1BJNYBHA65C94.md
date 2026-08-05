---
id: 01KYQMGNP8W4A1BJNYBHA65C94
created: 2026-07-29T19:09:41.448004Z
updated: 2026-08-05T19:02:38.884407Z
type: task
title: AWS connector foundation — add an AWS account to ISE
project: 01KX671DATY39VW6GWK3M2T3DN
number: 358
sprint: sjyt01k
comments:
- id: 01KYQPF4HQJPBE28QQPJZPPZ2M
  author: Steve Vine
  at: 2026-07-29T19:43:48.279739Z
  text: |-
    Built and shipped to review. PR #331 (feature/ise-358-aws-connector-foundation → main), merged to staging.

    What landed: new `aws` Integration Type (ADR 0058 written) — read-only v1 capabilities {alerts, entities, evidence}, empty action catalogue; static access-key credential spec with structural validation (rejects ASIA temporary keys, mangled pastes, bad region codes); STS GetCallerIdentity health check surfacing account id + caller ARN; `aws_config` region tenant on System.config with GET/PUT /systems/{id}/aws-config (viewer read, admin write, audited); boto3 behind a build_client seam; `access_key` added to the redaction list.

    Gates: ruff/format/mypy strict green, 27 tests passed (new suite + connectors/credentials), frontend build + prettier green after api-types regen. Smoke check on staging: add an AWS integration in Settings, paste a read-only key, Verify → health should show the account identity.
assignee: steve
label: null
priority: medium
task_status: done
---
New `aws` connector type (read-only v1), per-account instances, static access-key auth.

- `connectors/aws.py`: `connector_type="aws"`, capabilities `{entities, alerts, evidence}`; `credential_spec()` = access key id + secret access key (secret) + default region (`secret=False`); `validate_credential()` structural checks; `health_check()` = STS GetCallerIdentity (surfaces account id); `sync_spec()` no slices; `action_catalogue() → []`, `_execute` raises (actions are next sprint).
- boto3 dependency; register in `connectors/__init__.py`; add credential key names to `REDACTED_KEY_PARTS` in `logging_setup.py` (ADR 0018 DoD).
- Per-instance config tenant `aws_config` (region list) in `System.config` with editor endpoint in `api/v1/systems.py` — kind_dictionary pattern, no migration.
- Write ADR 0058: AWS connector — per-account instances, static-key auth (read/write credential split reserved for the actions sprint), account-scoped native keys `aws:{account_id}:{arn}` (ADR 0045), alarm/Health→Alert mapping, new entity types.

**Done when:** an operator can add an AWS account in Settings (picker shows AWS with capability badges, auto-generated credential form), verify the credential, and see health green with the account identity.