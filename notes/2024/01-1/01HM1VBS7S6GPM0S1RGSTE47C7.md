---
id: 01HM1VBS7S6GPM0S1RGSTE47C7
created: 2024-01-13T16:44:28.793Z
updated: 2024-01-14T14:19:39.302999Z
type: memo
title: Description
---
13-01-2024 16:47

Tags: #eks 


---
# Description
In order to follow this an EKS Cluster must have been created in AWS.
This process details how to deploy an application into EKS with the following properties:
- External Secrets Operator (ESO)
- External-DNS (EDNS)
- Cert-Manager (CM)
- Ingress-Nginx (ING)
- Route53 (R53)
- Cloudflare (CF)
- Lets's Encrypt (LE)

In this example Route53 is used for internal DNS to setup a DNS A Record that will resolve to an internal load balancer allowing resources within scope of the internal DNS zone to resolve the application.  Cloudflare will be used for external DNS, to allow the domain to be verified by Let's Encrypt via Cert-Manager.  Cert-Manager will use the DNS-01 method for validation so that no external A records will be created.

# Initial Deployment and Configuration
## Prerequisite Configuration
### Step 1
Create an OIDC Provider for the cluster, this will be used to allow services running within the cluster to utilise IAM roles for service accounts (IRSA) to access services outside of the cluster, E.g. Route53 or Secrets Manager.
## External Secrets Operator

### Step 1
Create a IAM policy in AWS to allow ESO to communicate directly with AWS Secrets Manager.  The policy should contain the following.
```
{
  "Version": "2012-10-17",
  "Statement": [
	{
	  "Effect": "Allow",
	  "Action": "secretsmanager:GetSecretValue",
	  "Resource": "*"
	}
  ]
}
```
### Step 2
Create an IAM Role to link a Service Account within the cluster.  Use the following assume role policy.
```
{
  "Version": "2012-10-17",
  "Statement": [
	{
	  "Effect": "Allow",
	  "Principal": {
		"Federated": "arn:aws:iam::<AWS Account ID>:oidc-provider/<OIDC URL>"
	  },
	  "Action": "sts:AssumeRoleWithWebIdentity",
	  "Condition": {
		"StringEquals": {
		  "<OIDC URL>:sub": "system:serviceaccount:external-secrets:<Service Account Name>"
		}
	  }
	}
  ]
}
```
### Step 3
Attach the policy to the role
### Step 4
Install External Secrets Operator into the cluster passing the following values.
```
serviceAccount.name = <Service Account Name>
serviceAccount.name = false
```
### Step 5
Create the Service Account in the ESO Namespace with the below annotation.
```
eks.amazonaws.com/role-arn: arn:aws:iam::<Account ID>:role/<Role Name>
```
## External-DNS
### Step 1
Create an IAM Policy in AWS to allow EDNS to communicate with Route53.  The Policy should include the folowing.
```
{
  "Version": "2012-10-17",
  "Statement": [
	{
	  "Effect": "Allow",
	  "Action": [
		"route53:ChangeResourceRecordSets"
	  ],
	  "Resource": [
		"arn:aws:route53:::hostedzone/*"
	  ]
	},
	{
	  "Effect": "Allow",
	  "Action": [
		"route53:ListHostedZones",
		"route53:ListResourceRecordSets",
		"route53:ListTagsForResource"
	  ],
	  "Resource": [
		"*"
	  ]
	}
  ]
}
```
### Step 2
Create an IAM Role to link a Service Account within the cluster.  Use the following assume role policy.
```
{
  "Version": "2012-10-17",
  "Statement": [
	{
	  "Effect": "Allow",
	  "Principal": {
		"Federated": "arn:aws:iam::<AWS Account ID>:oidc-provider/<OIDC URL>"
	  },
	  "Action": "sts:AssumeRoleWithWebIdentity",
	  "Condition": {
		"StringEquals": {
		  "<OIDC URL>:sub": "system:serviceaccount:external-dns:<Service Account Name>"
		}
	  }
	}
  ]
}
```
### Step 3
Attach the policy to the role
### Step 4
Install External-DNS using a deployment to pass values during the pod creation
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  labels:
    app.kubernetes.io/name: external-dns
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app.kubernetes.io/name: external-dns
  template:
    metadata:
      labels:
        app.kubernetes.io/name: external-dns
    spec:
      serviceAccountName: <Service Account Name>
      containers:
        - name: external-dns
          image: oci://registry-1.docker.io/stevevine/edns-provisioner:<Version Tag>
          args:
            - --source=service
            - --source=ingress
            - --domain-filter=<Domain Name>
            - --provider=aws
            - --txt-owner-id=<Project Name>
          env:
            - name: AWS_DEFAULT_REGION
              value: <AWS Region>
```
### Step 5
Create the Service Account in the EDNS Namespace with the below annotation.
```
eks.amazonaws.com/role-arn: arn:aws:iam::<Account ID>:role/<Role Name>
```
### Step 6
Create an RBAC Role to allow the Service Account to watch for Pods and Ingress'.
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: external-dns
  labels:
    app.kubernetes.io/name: external-dns
rules:
  - apiGroups: [""]
    resources: ["services","endpoints","pods","nodes"]
    verbs: ["get","watch","list"]
  - apiGroups: ["extensions","networking.k8s.io"]
    resources: ["ingresses"]
    verbs: ["get","watch","list"]
```
### Step 7
Create a ClusterRoleBinding to bind the Service Account to the Role
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
  labels:
    app.kubernetes.io/name: external-dns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
  - kind: ServiceAccount
    name: <Service Account>
    namespace: external-dns
```
## Cert-Manager
### Step 1
Install Cert-Manager into the cluster passing the following values.
```
installCRDs = true
```
## Ingress-Nginx
### Step 1
Create an internal Ingress controller by installing Ingress-Nginx into the cluster and passing the following values file (ingress-internal-values.yaml) to it.
```
controller:
  ingressClassByName: true

  ingressClassResource:
    name: ingress-internal
    enabled: true
    default: true
    controllerValue: "k8s.io/ingress-nginx-internal"

  ingressClass: ingress-internal
  service:
    external:
      enabled: false
    internal:
      enabled: true
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-internal: "true"
        service.beta.kubernetes.io/aws-load-balancer-name: "loadbalancer-internal"
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
        service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
```

```
helm upgrade --install ingress-nginx-internal ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx-internal --create-namespace -f ingress-internal-values.yaml
```
# Install and Configure the Application
## Install the application into the cluster
Install the application and create a service with a ClusterIP.  The Service name will be used by the ingress controller later.
## Create a TLS Certificate
### Step 1
Create a secret that contains the API Key for Cloudflare (creds-cloudflare), this will be used by Cert-Manager to create a TXT record containing the Let's Encrypt challenge.
### Step 2
Create an Issuer for Cert-Manager, this will create a configuration for Cert-Manager with the URL for the cert issuer (Let's Encrypt), the DNS Service used to validate the domain (Cloudflare), and the method used (DNS-01).

Below is an example using the Let's Encrypt staging area for testing purposes
```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-dns01-test
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: steve.vine@moneypenny.co.uk
    privateKeySecretRef:
      name: letsencrypt-dns01-test
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: creds-cloudflare
            key: CloudflareAPIToken
```

Once testing is successful, a production Issuer can be used.
```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-dns01-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: steve.vine@moneypenny.co.uk
    privateKeySecretRef:
      name: letsencrypt-dns01-prod
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: creds-cloudflare
            key: CloudflareAPIToken
```
### Step 3
Create a cert that references the Issuer created in the previous step, the full domain name to be used by the cert, and the name of the secret where the cert will be stored. It may take several minutes for the cert to be successfully created depending in DNS Propagation time.
```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: myapp-certificate
  namespace: default
spec:
  secretName: myapp-tls  
  issuerRef:
    name: letsencrypt-dns01-prod 
    kind: Issuer
  dnsNames:
  - myapp.moneypenny.uk 
```
### Step 4
Create an Ingress that maps the domain name to the app Service Name and references the TLS Certificate.
Once created, External-DNS will create the A Record in Route53.
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: internal-ingress
spec:
  ingressClassName: ingress-internal
  tls:
  - hosts:
    - myapp.moneypenny.uk
    secretName: myapp-tls
  rules:
  - host: myapp.moneypenny.uk
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
```


---
## References