---
id: 01JEVBD06FJFD1CQDRD9K3NXBJ
created: 2024-12-11T17:13:54.127Z
updated: 2024-12-12T09:27:17.147Z
type: memo
title: Demo
---
11-12-2024 17:13

Tags: 


---
Login
```
aws sso login --sso-session s.vine-session
```

Who am I
```
aws sts get-caller-identity
```

Set default profile
```
export AWS_PROFILE="s.vine"
```

Clear Identity
```
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
```

Assume Role - Management
```
eval $(aws sts assume-role --role-arn arn:aws:iam::183295409300:role/EKSClusterAdminRole \
--role-session-name eksClusterAdminRole-session \
--profile=s.vine \
--query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
--output text | awk '{print "export AWS_ACCESS_KEY_ID="$1"\nexport AWS_SECRET_ACCESS_KEY="$2"\nexport AWS_SESSION_TOKEN="$3}')
```

Assume Role - Chinwag
```
eval $(aws sts assume-role --role-arn arn:aws:iam::715841355480:role/EKSClusterAdminRole \
--role-session-name eksClusterAdminRole-session \
--profile=s.vine \
--query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
--output text | awk '{print "export AWS_ACCESS_KEY_ID="$1"\nexport AWS_SECRET_ACCESS_KEY="$2"\nexport AWS_SESSION_TOKEN="$3}')
```

---
## References