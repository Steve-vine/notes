---
id: 01GR7GBZ40PH35BD60X1WXSE18
created: 2023-02-01T22:08:16Z
updated: 2023-06-18T10:27:38Z
type: memo
title: Setup Dev Environment
---
01-02-2023 21:08

Tags: #setup

# Setup Dev Environment

---
## Chocolatey
https://chocolatey.org/ - Home page
https://community.chocolatey.org/packages - Package repository

Start PowerShell as Admin
```PowerShell
Set-ExecutionPolicy Remotesigned

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

## VS Code
https://code.visualstudio.com/ - Home page

```Shell
choco install vscode
```

## Git
https://git-scm.com/ - Home Page

```Shell
choco install git
```

## AWS CLI v2
https://aws.amazon.com/cli - Home page
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_use-resources.html - Using temporary credentials


```Shell
choco install awscli
```

```Shell
aws configure
```

## Terraform
https://www.terraform.io/ - Home Page

```Shell
choco install terraform
```

## AWS IAM Authenticator for Kubernetes
https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html - Guide

```Shell
choco install aws-iam-authenticator
```

## kubectl
https://kubernetes.io/docs/tasks/tools/ - Install tools

```shell
choco install kubernetes-cli
```

## Docker Desktop
https://www.docker.com/ - Home page

```Shell
choco install docker-desktop
```

## Obsidian
https://obsidian.md/ - Home Page

```Shell
choco install obsidian
```

## Adobe Reader
https://get.adobe.com/reader - Home page

```Shell
choco install adobereader
```

## WSL

```Shell
wsl --install
```

---
## Quick Setup
```PowerShell
Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install vscode -y
choco install git -y
choco install awscli -y
choco install terraform -y
choco install aws-iam-authenticator -y
choco install kubernetes-cli -y
choco install docker-desktop -y
choco install obsidian -y
choco install adobereader -y
wsl --install

```
