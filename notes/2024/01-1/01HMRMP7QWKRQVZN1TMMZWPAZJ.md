---
id: 01HMRMP7QWKRQVZN1TMMZWPAZJ
created: 2024-01-22T13:10:23.228Z
updated: 2024-01-22T13:13:58.806999Z
type: memo
title: Set the refresh interval
---
22-01-2024 13:10

Tags: #secrets-manager


---
# Set the refresh interval
```
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: basicauth-es
spec:
  refreshInterval: 1h
```

Valid time units are "ns", "us" (or "µs"), "ms", "s", "m", "h"
# Trigger a refresh
```
kubectl annotate es <es-name> force-sync=$(date +%s) --overwrite
```


---
## References