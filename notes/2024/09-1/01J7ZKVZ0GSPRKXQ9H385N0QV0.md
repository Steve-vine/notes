---
id: 01J7ZKVZ0GSPRKXQ9H385N0QV0
created: 2024-09-17T09:08:58Z
updated: 2025-02-13T10:39:25.174Z
type: memo
title: Install Komoplane
imported_from: Obsidian
---
17-09-2024 10:09

Tags: #komoplane


---
Install from Helm chart
```
helm repo add komodorio https://helm-charts.komodor.io \
  && helm repo update komodorio \
  && helm upgrade --install komoplane komodorio/komoplane -n komoplane --create-namespace
```

Access via port forward
```
export POD_NAME=$(kubectl get pods --namespace komoplane -l "app.kubernetes.io/name=komoplane,app.kubernetes.io/instance=komoplane" -o jsonpath="{.items[0].metadata.name}")
    export CONTAINER_PORT=$(kubectl get pod --namespace komoplane $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
    echo "Visit http://127.0.0.1:8090 to use your application"
    kubectl --namespace komoplane port-forward $POD_NAME 8090:$CONTAINER_PORT
```

---
## References