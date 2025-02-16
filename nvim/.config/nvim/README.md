## Automations for Windows:
### jump to the nvim config directory:
1. Create a file named "Microsoft.PowerShell_profile.ps1" under the following folder: "C:\Users\[user-name]\Documents\WindowsPowerShell"
2. Append the following function: 
<br>

```bashrc
function cdnvim {
    cd "C:\Users\[user-name]\AppData\Local\nvim"
}
```

3. in the Windows PowerShell, call the command ```cdnvim```

---

## Windows WSL nvim tmux:
https://medium.com/@tsukinoko/neovim-on-windows-wsl-4f9fe7bcb95c

