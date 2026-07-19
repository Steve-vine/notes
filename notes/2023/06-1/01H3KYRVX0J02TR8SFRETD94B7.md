---
id: 01H3KYRVX0J02TR8SFRETD94B7
created: 2023-06-23T11:03:32Z
updated: 2023-06-23T13:08:17Z
type: memo
title: Install Istio
imported_from: Obsidian
---
23-06-2023 11:47

Tags: #istio #kubernetes  


---
### Install using istioctl

Download the latest release of Istio
```Bash
curl -L https://istio.io/downloadIstio | sh -
```
Or browse the releases on the Repo - https://github.com/istio/istio/releases/

Copy the istioctl to a folder in the PATH
E.g. From inside the Istio folder
```
cp bin/istioctl /usr/local/bin
```

Install Istio
```Bash
istioctl install
```

### Install Integrations

From inside the Istio downloads folder
```Bash
kubectl apply -f ./addons
```

Change an endpoint to a load Balancer
```Bash
kubectl patch svc <service> -n istio-system -p '{"spec": {"type": "LoadBalancer"}}'
```

### Install using Helm

Create Namespace
```Bash
kubectl create ns istio-system 
```

Install the Istio Base chart
```Bash
helm install istio-base istio/base -n istio-system
```

Install the Discovery chart
```Bash
helm install istiod istio/istiod -n istio-system --wait
```

Install the Ingress Gateway
```Bash
kubectl create namespace istio-ingress
```
```Bash
helm install istio-ingress istio/gateway -n istio-ingress --wait
```

## Add Istio to a Namespace

Label the Namespace
```Bash
kubectl label namespace <namespace> istio-injection=enabled
```


---
## References