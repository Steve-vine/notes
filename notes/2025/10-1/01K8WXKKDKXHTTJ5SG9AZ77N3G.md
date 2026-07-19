---
id: 01K8WXKKDKXHTTJ5SG9AZ77N3G
created: 2025-10-31T10:39:26.643Z
updated: 2025-11-01T12:04:15.232Z
type: memo
title: Install from scratch
---
31-10-2025 10:39

Tags: #karpenter


---
```
export KARPENTER_VERSION="1.8.1"
```

```
helm template karpenter oci://public.ecr.aws/karpenter/karpenter --version "${KARPENTER_VERSION}" --namespace "kube-system" \
    --set "settings.clusterName=cluster-1-ekscluster" \
    --set "settings.interruptionQueue=vluster-1-ekscluster" \
    --set "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=arn:aws:iam::124355659293:role/cluster-1-role-karpentercontroller" \
    --set controller.resources.requests.cpu=1 \
    --set controller.resources.requests.memory=1Gi \
    --set controller.resources.limits.cpu=1 \
    --set controller.resources.limits.memory=1Gi > karpenter.yaml

```

---
## References