---
id: 01J4S90A2GABEZNZ913XWBS5HD
created: 2024-08-08T15:16:34Z
updated: 2024-08-08T15:40:20Z
type: memo
title: Crossplane AWS Permissions Setup
---
08-08-2024 16:17

Tags: #crossplane #aws


---
### Long-Term Credentials (IAM Access Keys)

Setting up Crossplane with LTC's is required if running from a separate cluster not in AWS

Create an IAM user with the relevant policies and generate access keys

Create a file called 'aws-credentials.txt'
```
[default]
aws_access_key_id = <aws_access_key_id>
aws_secret_access_key = <aws_secret_access_key>
```

Create a Kubernetes secret using the txt file
```
kubectl create secret generic secret-aws -n crossplane-system --from-file=aws-creds=./aws-credentials.txt
```

The ProviderConfig should reference this secret, e.g.
```
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
	name: providerconfig-aws
	namespace: crossplane-system
spec:
	credentials:
		source: Secret
		secretRef:
			namespace: crossplane-system
			name: secret-aws
			key: aws-creds
```

---
## References

[AWS Quickstart · Crossplane v1.16](https://docs.crossplane.io/latest/getting-started/provider-aws/)