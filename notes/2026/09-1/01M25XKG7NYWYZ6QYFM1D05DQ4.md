---
id: 01M25XKG7NYWYZ6QYFM1D05DQ4
created: 2026-09-10T15:04:58.869727Z
updated: 2026-09-10T15:04:58.869727Z
type: task
title: The chart gives the backend pods a ServiceAccount, so S3 can be reached by pod role instead of static keys
priority: high
task_status: active
assignee: steve
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 662
---
For the production install (COM-660) attachments go to S3 and the API should authenticate as its **pod role (IRSA)**, not with an access key pair stored in Secrets Manager. The backend already supports it: `S3Storage` passes `None` for the keys when `S3_ACCESS_KEY_ID`/`S3_SECRET_ACCESS_KEY` are unset and boto3 falls through to the default credential chain, which on EKS is the projected service-account token. What is missing is on the chart side: no `ServiceAccount` is created, every pod runs as the namespace `default`, so there is nothing to hang the `eks.amazonaws.com/role-arn` annotation on.

**Change (chart only, ADR 0008: cloud-specific things come from values, defaulted empty)**
- `values.yaml`: `serviceAccount: { create: true, name: "", annotations: {} }`. Name defaults to the release fullname.
- `templates/serviceaccount.yaml`: created when `serviceAccount.create`; annotations from values; `automountServiceAccountToken: true` (the IRSA token is a separate projected volume the EKS webhook adds, but keep the default explicit).
- `serviceAccountName` on the **api, worker, beat** Deployments and the **import** Job (all run backend code that may touch storage). The **migrate** Job keeps the namespace default — its comment explains it deliberately talks only to Postgres; leave that as is unless the SA is needed for something else.
- Selector labels untouched (COM-654 rule). No change when `serviceAccount.create: false` and `name` empty → `default`, so staging renders identically apart from the new SA object.
- `values-prod.yaml`: `serviceAccount.annotations: { eks.amazonaws.com/role-arn: arn:aws:iam::826764636751:role/<compass-prod-app> }` as a documented placeholder; `secrets.eso.remoteRefs.s3AccessKeyId/s3SecretAccessKey` removed from the prod overlay (keys are the MinIO / non-AWS path, still supported in the base chart).
- `chart/README.md` prerequisites table: IRSA role note.

**Acceptance**: `helm template` with the prod overlay shows a ServiceAccount with the annotation and `serviceAccountName` on api/worker/beat/import; with the staging overlay the pods keep running as before after deploy (a new SA object, otherwise identical); lands on main and is promoted to staging before v0.1.0 is cut.