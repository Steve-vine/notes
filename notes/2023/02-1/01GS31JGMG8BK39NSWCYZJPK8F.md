---
id: 01GS31JGMG8BK39NSWCYZJPK8F
created: 2023-02-12T14:48:26Z
updated: 2023-03-17T16:21:56Z
type: memo
title: Oh-My-Posh
imported_from: Obsidian
---
08-02-2023 16:53

Tags: #setup 

# Oh-My-Posh

---
https://ohmyposh.dev/ - Home page

Install
```PowerShell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

Select font
```PowerShell
oh-my-posh font install
```
Or downdload CaskaydiaCove from here - https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip?WT.mc_id=-blog-scottha

Edit Terminal settings.json
CTRL + SHIFT + ,
Add "font" attribute under "profiles"
```Editor
{
    "profiles":
    {
        "defaults":
        {
            "font":
            {
                "face": "CaskaydiaCove NF"
            }
        }
    }
}
```

Ensure ExecutionPolicy is set to RemoteSigned
```PowerShells.vine
Set-ExecutionPolicy RemoteSigned
```

Edit (or create) PowerShell profile
```PowerShell
notepad $PROFILE
```

Create profile
```PowerShell
New-Item -Path $PROFILE -Type File -Force
```

Go to [Themes | Oh My Posh](https://ohmyposh.dev/docs/themes)
Select theme and save the json locally ('c:\\code\\omp.json')
Add the init command to the profile
```PowerShell
oh-my-posh init pwsh --config 'c:\code\omp.json' | Invoke-Expression
```

Reload Profile
```PowerShell
. $PROFILE
```

Change font family in VS Code
E.g. - CaskaydiaCove NF
![[Pasted image 20230317162124.png]]
---
## References