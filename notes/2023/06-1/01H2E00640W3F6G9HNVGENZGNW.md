---
id: 01H2E00640W3F6G9HNVGENZGNW
created: 2023-06-08T17:13:52Z
updated: 2023-10-01T11:59:41Z
type: memo
title: Pull an Image from a Private Registry
imported_from: Obsidian
---
08-06-2023 17:41

Tags: #docker #kubernetes  


---
https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

Login to Docker
```Bash
docker login -u stevevine
```

View the config
```Bash
cat ~/.docker/config.json
```

If the 'auth' key is available a secret can be created based on existing credentials. if the key is in a 'credStore' the secret can be created by providing credentials on the command line

### Create a Secret based on existing credentials

Copy the credentials into the cluster
*There seems to be an issue with kubectl recognizing ~ as HOME, this should work but can't find the config file*
```Bash
kubectl create secret generic regcred --from-file=.dockerconfigjson=~/.docker/config.json --type=kubernetes.io/dockerconfigjson
```
*Instead, CD to ~/.docker and run*
```Bash
kubectl create secret generic regcred --from-file=.dockerconfigjson=./config.json --type=kubernetes.io/dockerconfigjson
```

### Create a Secret by providing credentials on the command line

Create a secret
```Bash
kubectl create secret docker-registry creds-dockerhub --docker-server=https://index.docker.io/v1/ --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
```

\<your-registry-server> is your Private Docker Registry FQDN. Use https://index.docker.io/v1/ for DockerHub.
\<your-name> is your Docker username.
\<your-pword> is your Docker password.
\<your-email> is your Docker email.

View the secret
``` Bash
kubectl get secret regcred --output=yaml
```

---
## References