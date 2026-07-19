---
id: 01J4S132J044RHEFQVK0B9Z4FN
created: 2024-08-08T12:58:16Z
updated: 2024-08-08T13:36:43Z
type: memo
title: Variables
imported_from: Obsidian
---
08-08-2024 13:58

Tags: #aws #crossplane #helm 


---
### Initial Steps

Create a user with appropriate permissions
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "arn:aws:ecr:<aws-region>:<aws-account-id>:repository/<repository-name>"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    }
  ]
}

```

Create long term access keys for the user and retain the values

### Create a profile and Generate an Authentication Token

Create a local profile for the user
```
aws configure --profile <profile-name>
```

Generate the auth-token
```
aws ecr get-login-password --region <aws-region> --profile <profile-name>
```

### Create the secret

Create the base64 encoded creds
```
echo -n "AWS" | base64
```

```
echo -n "<auth-token>" | base64
```

Create the secret
```
apiVersion: v1
kind: Secret
metadata:
	name: secret-dockerhub
	namespace: crossplane-system
data:
	username: QVdT
	password: <base64 encode auth-token>
```

Apply the secret
```
kubectl apply -f crossplane-ecr.yaml
```

### Automation

This could be automated with a script, something like
```
#!/bin/bash

# Variables
AWS_REGION="<aws-region>"
SECRET_NAME="secret-ecr"
SECRET_NAMESPACE="crossplane-system"
DOCKER_SERVER="<aws_account_id>.dkr.ecr.$AWS_REGION.amazonaws.com"
DOCKER_USERNAME="AWS"
DOCKER_EMAIL="my-email@example.com"

# Get the ECR login password
DOCKER_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)

# Encode the username and password
ENCODED_USERNAME=$(echo -n "$DOCKER_USERNAME" | base64)
ENCODED_PASSWORD=$(echo -n "$DOCKER_PASSWORD" | base64)

# Create the secret YAML
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
  namespace: $SECRET_NAMESPACE
data:
  username: $ENCODED_USERNAME
  password: $ENCODED_PASSWORD
  email: $(echo -n "$DOCKER_EMAIL" | base64)
EOF
```

That could be put into a config map
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: update-ecr-secret-script
  namespace: crossplane-system
data:
  update-ecr-secret.sh: |
    #!/bin/bash
    AWS_REGION="<aws-region>"
    SECRET_NAME="secret-ecr"
    SECRET_NAMESPACE="crossplane-system"
    DOCKER_SERVER="<aws_account_id>.dkr.ecr.$AWS_REGION.amazonaws.com"
    DOCKER_USERNAME="AWS"
    DOCKER_EMAIL="my-email@example.com"
    
    DOCKER_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)
    ENCODED_USERNAME=$(echo -n "$DOCKER_USERNAME" | base64)
    ENCODED_PASSWORD=$(echo -n "$DOCKER_PASSWORD" | base64)
    
    cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: $SECRET_NAME
      namespace: $SECRET_NAMESPACE
    data:
      username: $ENCODED_USERNAME
      password: $ENCODED_PASSWORD
      email: $(echo -n "$DOCKER_EMAIL" | base64)
    EOF

```

And a Kubernetes Cron job to execute it
```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: ecr-token-renewal
  namespace: crossplane-system
spec:
  schedule: "0 */11 * * *"  # Run every 11 hours
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: update-ecr-secret
            image: amazonlinux:2
            command: ["/bin/bash", "-c", "apk add --no-cache aws-cli && /scripts/update-ecr-secret.sh"]
            volumeMounts:
            - name: script
              mountPath: /scripts
              readOnly: true
          restartPolicy: OnFailure
          volumes:
          - name: script
            configMap:
              name: update-ecr-secret-script

```


---
## References