---
id: 01M25XKG7NYWYZ6QYFM1D05DQ4
created: 2026-09-10T15:04:58.869727Z
updated: 2026-09-10T15:07:11.995707Z
type: task
title: The chart gives the backend pods a ServiceAccount, so S3 can be reached by pod role instead of static keys
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 662
sprint: stek6vx
comments:
- id: 01M25XQJ7V9DEDRR4M18E8XB7W
  author: Steve Vine
  at: 2026-09-10T15:07:11.995543Z
  text: 'PR #666 open: https://github.com/Steve-vine/compass/pull/666 — annotation hooks on the existing api/worker ServiceAccounts, prod overlay carries the IRSA role-arn placeholder and drops the S3 key refs. Staging render diff vs main: 0 lines.'
assignee: steve
label:
- feature
priority: high
task_status: active
---
For the production install (COM-660) attachments go to S3 and the API should authenticate as its **pod role (IRSA)**, not with an access key pair stored in Secrets Manager. The backend already supports it: `S3Storage` passes `None` for the keys when `S3_ACCESS_KEY_ID`/`S3_SECRET_ACCESS_KEY` are unset and boto3 falls through to the default credential chain, which on EKS is the projected service-account token.

**Correction on reading the chart**: ServiceAccounts already exist — `<release>-api` (API) and `<release>-worker` (worker + beat), both `automountServiceAccountToken: false`, which is fine for IRSA (the EKS pod-identity webhook projects its own token volume). Only the import and migrate hook Jobs run as the namespace default, deliberately (hook ordering), and neither touches storage. So the change is just an **annotations hook**:

- `api.serviceAccount.annotations` and `worker.serviceAccount.annotations` in `values.yaml` (empty by default, ADR 0008: cloud-specific things come from values), rendered onto the two existing ServiceAccounts.
- `values-prod.yaml`: both set to `eks.amazonaws.com/role-arn: arn:aws:iam::000000000000:role/compass-prod-app` as a documented placeholder (the real role is created in COM-660); the `s3AccessKeyId` / `s3SecretAccessKey` ESO remoteRefs removed from the prod overlay; `config.s3.region` → `eu-west-2`. Static keys stay supported in the base chart for MinIO / non-AWS.
- `chart/README.md` prerequisites: the IAM role row.

**Acceptance**: `helm template` with the prod overlay shows the annotation on both ServiceAccounts; the staging overlay renders no annotations and is otherwise unchanged; lands on main and is promoted to staging before v0.1.0 is cut.