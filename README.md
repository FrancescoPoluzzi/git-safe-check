# 🛡️ git safe check

A safety wrapper for Git designed for non‑experts, busy experts, and anyone copying Git commands from LLMs.  
It helps prevent unwanted or irreversible Git operations by intercepting potentially dangerous commands, explaining the risk, and asking for confirmation before execution.

## 🚀 Install

### Linux (Ubuntu, Debian, Fedora, Arch, etc.), macOS Catalina (10.15+), WSL  

```
curl -fsSL https://raw.githubusercontent.com/FrancescoPoluzzi/git-safe-check/main/install.sh | bash
```

After installation, restart your shell or run:

```
source ~/.bashrc
# or
source ~/.zshrc
```

### Windows PowerShell

#### Requirements

1. Git for Windows installed and available on the system path  
2. PowerShell execution policy that allows running local scripts, for example RemoteSigned or a less strict option  

#### Installation (recommended one line command)

1. Open PowerShell as a normal user  
2. If needed, relax the execution policy for the current user  

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

3. Run the installer directly from the repository

```powershell
irm https://raw.githubusercontent.com/FrancescoPoluzzi/git-safe-check/main/windows/install.ps1 | iex
```

## 🎮 Usage

Use Git exactly as you normally would.  
Whenever a command is recognized as potentially dangerous, the tool will show a warning and prompt for confirmation.

Example:

```
$ git push

-------------------------------------------------------------
✋  GIT SAFETY CHECK
-------------------------------------------------------------
You are about to push local commits to the remote repository.
This will publish your changes and make them visible to others.
-------------------------------------------------------------
Do you want to proceed? [y/N]
```

If you confirm, the tool proceeds and forwards the command to the real Git installation.

## 🗑️ Uninstall

### Linux and macOS

```
rm -rf ~/.git-safe-check
```

Then remove the PATH lines added by the installer from your shell configuration file.

### Windows PowerShell

1. Remove the installed folder  

```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.git-safe-check"
```

2. Open your PowerShell profile  

```powershell
notepad $PROFILE
```

3. Delete the block marked as git safe check start and git safe check end  
4. Save the file and restart PowerShell

## 📄 License

MIT License.
