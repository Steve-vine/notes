---
id: 01GRK8QXC0RY4QQ3N6CVRQHH9K
created: 2023-02-06T11:45:52Z
updated: 2023-02-06T11:45:52Z
type: memo
title: Enable Nested Virtualization in Hyper-V
---
06-02-2023 09:27

Tags: #hyper-v

# Enable Nested Virtualization in Hyper-V

---
To allow a Hyper-v VM to run virtualization tasks such as Hyper-V, WSL or Docker, enable Nested Virtualization on the VM.

Open a Shell on the Hyper-V host and run the following
```PowerShell
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```

To check is it is set
```PowerShell
$(Get-VMProcessor -VMName <VMName>).ExposeVirtualizationExtensions
```

Also untick "Enable Dynamic Memory"

---
## References