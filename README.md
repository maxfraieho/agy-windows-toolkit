# Antigravity CLI Windows Toolkit (`agy-windows-toolkit`)

Turnkey multi-account isolation, profile management, and quick switching system for **Google Antigravity CLI (`agy`)** on Windows (PowerShell, CMD, Wave Terminal, and Charmbracelet Crush).

---

## Architecture Overview

Google Antigravity CLI uses a hybrid authentication mechanism on Windows:
1. **Windows Credential Manager / DPAPI Keyring:** Refresh tokens are securely persisted in generic credentials under `JetskiService`.
2. **File-based Session Storage:** Configuration and state reside under `%USERPROFILE%\.antigravity` and `%USERPROFILE%\.gemini\antigravity-cli\`.

This toolkit establishes clean account separation via **NTFS Directory Junctions** and profile vaults:

```text
%USERPROFILE%\
├── .antigravity ───────────────────► [NTFS Junction] ──► %USERPROFILE%\.antigravity-profiles\me
├── .antigravity-profiles\
│   ├── me\                         # Primary profile vault
│   │   └── antigravity-oauth-token
│   └── son\                        # Secondary profile vault (e.g. during 48h quota lock)
│       └── antigravity-oauth-token
└── bin\
    ├── agy-switch.ps1              # Core PowerShell profile switcher
    ├── agy-me.cmd                  # One-click launcher/switch to 'me'
    └── agy-son.cmd                 # One-click launcher/switch to 'son'
```

---

## Quick Start / Installation

Run the automated installer in PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup.ps1
```

The script will:
1. Create the profile vaults (`.antigravity-profiles\me` and `.antigravity-profiles\son`).
2. Back up any existing session credentials safely.
3. Deploy the switcher scripts to `%USERPROFILE%\bin` and add it to user `PATH`.
4. Inject helper aliases and interactive selector menu into PowerShell `$PROFILE`.

---

## Switching Accounts

### 1. Via CLI Commands
* Switch to primary profile:
  ```powershell
  agy-switch me
  ```
* Switch to secondary profile:
  ```powershell
  agy-switch son
  ```
* Check active profile status:
  ```powershell
  agy-switch status
  ```

### 2. Via Interactive TUI Menu
Type:
```powershell
agy-sel
```
Select target profile (1: Me, 2: Son, 3: Status).

### 3. Inside Wave Terminal & Charmbracelet Crush
Launch:
```cmd
agy-me
```
or
```cmd
agy-son
```

---

## Native Slash Commands Reference

Inside the running `agy` interactive prompt, you can manage active Google accounts directly:

| Command | Action |
|---|---|
| `/logout` | Clears active token from disk and removes the cached credential from Windows Credential Manager. |
| `/login` | Triggers a fresh Google OAuth browser login flow. |
| `/exit` | Exits the CLI session. |

---

## License

MIT
