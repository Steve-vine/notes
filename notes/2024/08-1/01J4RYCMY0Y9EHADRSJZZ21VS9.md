---
id: 01J4RYCMY0Y9EHADRSJZZ21VS9
created: 2024-08-08T12:11:04Z
updated: 2024-08-09T16:49:13Z
type: memo
title: CLI Profiles
imported_from: Obsidian
---
08-08-2024 13:11

Tags: #aws 


---
### Manage Profiles

List all profiles
```
aws configure list-profiles
```

Create a new profile
```
aws configure --profile <profile-name>
```
or
```
aws configure
```

Execute a command using a specific profile
```
aws eks update-kubeconfig --region eu-west-2 --name app-ekscluster --profile <profile-name>
```

Set default profile
```
export AWS_PROFILE=<profile-name>
```

### Single Sign On

Create an SSO profile
```
aws configure sso
```

Example settings...
SSO session name (Recommended): s.vine
SSO start URL (None): https://d-9c67641241.awsapps.com/start
SSO region (None): eu-west-2
SSO registration scopes (sso:account:access):

When the browser opens, this needs to be logged in as the account you're using
Accept the code

Choose the account if there are more than one
Then complete the remaining questions...
CLI default client Region (aws None): eu-west-2
CLI default output format (None): json
CLI profile name (AdministratorAccess-017820666225): Org-Admin

Re-authenticate session
```
aws sso login --sso-session s.vine
```

---
## References