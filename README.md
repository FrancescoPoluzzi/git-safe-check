# 🛡️ git safe check

Small wrapper around git that warns before risky commands (push, rebase, reset --hard, branch -d/-D, checkout on files). Works with aliases and stays silent in non-interactive environments.

## 🚀 Install

```
curl -fsSL https://raw.githubusercontent.com/FrancescoPoluzzi/git-safe-check/main/install.sh | bash
```
Restart your shell or `source ~/.bashrc` / `source ~/.zshrc`.

## 🎮 Usage

```
$ git push

-------------------------------------------------------------
✋  GIT SAFETY CHECK
-------------------------------------------------------------
☁️  You are about to UPLOAD changes to the remote server.

    Command: git push
-------------------------------------------------------------
❓ Do you want to proceed? [y/N]
```

## 🗑️ Uninstall

```
rm -rf ~/.git-safe-check
```
Remove the added PATH lines from your shell rc.

## 📄 License

MIT. Inspect install.sh and src/git-safe-check.sh anytime.
