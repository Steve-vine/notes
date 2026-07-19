---
id: 01HMRNTS93H6VK9BRB0S5ZB82N
created: 2024-01-22T13:30:20.835Z
updated: 2024-01-22T13:33:06.525Z
type: memo
title: Mount the secret as a Volume
---
22-01-2024 13:30

Tags: #python #secret 


---
# Mount the secret as a Volume
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  template:
    spec:
      containers:
      - name: my-app
        image: my-app-image
        volumeMounts:
        - name: my-secret-volume
          mountPath: "/etc/secret"
          readOnly: true
      volumes:
      - name: my-secret-volume
        secret:
          secretName: my-secret

```
# Read the secret from the volume
```
def read_secret(key):
    with open(f"/etc/secret/{key}") as file:
        return file.read().strip()

# Usage
secret_value = read_secret("key1")
```


---
## References