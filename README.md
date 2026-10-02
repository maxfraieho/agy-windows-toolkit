# Antigravity Windows Toolkit 🚀

Complete turnkey automation toolkit for **Google Antigravity CLI (`agy`)**, **Charm Crush CLI (`crush`)**, and **Antigravity Claude Proxy** on Windows 10/11.

Provides automated multi-profile management, smart multi-account load balancing, UTF-8 BOM prevention, and seamless IDE/CLI integration.

---

## Architecture Overview

```mermaid
flowchart TD
    subgraph Clients["Windows User Environment (.30)"]
        AgyCLI["Antigravity CLI (agy)"]
        CrashCLI["crash / crash-edgee CLI\n(Smart Gateway Auto-Resolver)"]
        CrushCLI["Charm Crush CLI (v0.97.1)"]
        BrowserUI["Web UI Dashboard\nhttp://localhost:8080"]
    end

    subgraph EdgeeCloud["Edgee AI Gateway Cloud"]
        EdgeeGateway["Edgee Token Compressor & BYOK Router\n(api.edgee.ai / api.edgee.app)"]
    end

    subgraph IngressNode["Cloudflare Ingress Node (.184)"]
        CFTunnel["Cloudflare Tunnel\n(antigravity-proxy.exodus.pp.ua)"]
    end

    subgraph ProxyGateway["Antigravity Claude Proxy (Port 8080 on .30)"]
        Router["Smart Hybrid Strategy\n(Auto-Failover & Health Score)"]
        TokenRefresher["OAuth Token Lifecycle"]
    end

    subgraph Upstream["Google Cloud Code / Antigravity Backend"]
        ModelGemini["Gemini 3.8 Flash Tiered"]
        ModelSonnet["Claude 3.5 Sonnet / 4.6"]
        ModelFlash["Gemini 3 Flash"]
    end

    AgyCLI -->|NTFS Junction Switcher| ProxyGateway
    BrowserUI -->|REST API /api/accounts| ProxyGateway

    %% Dual Mode Routing
    CrashCLI -->|Edgee Compression Route| EdgeeGateway
    EdgeeGateway -->|HTTPS BYOK Ingress| CFTunnel
    CFTunnel -->|LAN Forwarding .184 -> .30:8080| ProxyGateway

    CrashCLI -.->|Direct Loopback Mode (--raw)| CrushCLI
    CrushCLI -.->|HTTP 127.0.0.1:8080| ProxyGateway

    ProxyGateway --> Router
    Router --> TokenRefresher
    TokenRefresher -->|tukroschu@gmail.com (Pro Quota)| Upstream
    TokenRefresher -.->|arsen.k111999@gmail.com (Fallback)| Upstream
    Upstream --> ModelGemini
    Upstream --> ModelSonnet
    Upstream --> ModelFlash
```

---

## ⚡ Zero-Touch Quickstart (From Scratch)

Run in PowerShell as your normal user (`vokov`):

```powershell
# 1. Clone toolkit repository
git clone https://github.com/maxfraieho/agy-windows-toolkit.git $HOME\projects\agy-windows-toolkit
cd $HOME\projects\agy-windows-toolkit

# 2. Run all-in-one setup
.\setup.ps1
```

The script will automatically:
1. Isolate Antigravity CLI into dual profiles (`me` and `son`) using NTFS Junctions.
2. Deploy `agy-switch.ps1`, `agy-me.cmd`, and `agy-son.cmd` into `%USERPROFILE%\bin`.
3. Clone, install, and start **Antigravity Claude Proxy** with smart failover.
4. Configure **Charm Crush** (`crush.json` and `crushrc`) with UTF-8 BOM-free configs.
5. Register PowerShell `$PROFILE` aliases (`agy-switch`, `agy-sel`, `proxy-start`, `proxy-stop`, `proxy-status`).
6. Run an automated end-to-end verification pipeline.

---

## 🛠️ Included Components

### 1. Antigravity CLI Multi-Profile Switcher
Switch between primary (owner) and secondary accounts in seconds without losing OAuth tokens:

- **Command-line**:
  ```powershell
  agy-switch me      # Switch active profile to tukroschu@gmail.com
  agy-switch son     # Switch active profile to arsen.k111999@gmail.com
  agy-switch status  # Show active profile and target junction
  ```
- **Interactive TUI Picker**:
  ```powershell
  agy-sel            # Displays a 1-click numeric menu
  ```
- **Quick CMD Launchers**:
  `agy-me.cmd` and `agy-son.cmd` for Wave Terminal, Crash, or third-party launchers.

### 2. Antigravity Claude Proxy
A local reverse proxy bridge listening on `http://localhost:8080`:
- **Smart Hybrid Account Pooling**: Both accounts are monitored in real time. If one account hits a 429 rate limit or quota lock, requests are automatically routed to the other account.
- **Web UI Dashboard**: Access [http://localhost:8080/](http://localhost:8080/) to view account quotas, health scores, request logs, and token status.
- **BOM Protection**: Native UTF-8 BOM stripping to prevent Go/Node.js JSON parsing errors on Windows.
- **Management Commands**:
  ```powershell
  proxy-start        # Starts proxy in background
  proxy-stop         # Stops proxy process on port 8080
  proxy-status       # Shows health, version, and active account count
  ```

### 3. Charm Crush CLI Integration
Configures Crush to use your Google AI Pro subscription through the proxy:
- **Large Model (Main)**: `gemini-3.8-flash-tiered` / `claude-sonnet-4-6` (High quota, Pro tier)
- **Small Model (Titles/Fast)**: `gemini-3-flash`
- **Zero Quota Errors**: Bypasses the 20-request/day free tier limit of `GEMINI_API_KEY`.

### 4. Edgee AI Gateway Integration & `crash` Launcher
Integrates **Edgee Gateway** (`api.edgee.ai`) for intelligent context compression and BYOK routing:
- **Lossless Token Pruning**: Strips noisy tool-result logs and dead terminal spans before sending to upstream LLMs.
- **Smart Disambiguation**: Automatically translates bare model names (`gemini-3.8-flash-tiered`) to provider-scoped identifiers (`edgee/gemini-3.8-flash-tiered`).
- **Dual Execution Modes**:
  - `crash` / `crach` / `crash-edgee`: Full Edgee token compression, latency monitoring, and automatic failover (local proxy `:8080` <-> Cloudflare Tunnel).
  - `crash-raw` / `crush-raw`: Bypasses Edgee completely for direct local loopback (`http://127.0.0.1:8080`) when offline.
- **Detailed Manual**: See [`docs/EDGEE_ANTIGRAVITY_INTEGRATION.md`](docs/EDGEE_ANTIGRAVITY_INTEGRATION.md) for full architecture blueprints and dashboard setup instructions.

---

## 🔍 Verification & Health Check

Run the built-in diagnostic test anytime:

```powershell
.\scripts\test-pipeline.ps1
# or using PowerShell alias:
agy-test
```

Sample output:
```text
===============================================
   Antigravity Windows Toolkit Verification
===============================================

[1/3] Testing Antigravity CLI Profile Setup...
 [PASS] Junction active: C:\Users\vokov\.antigravity-profiles\me
 [PASS] Switcher script found at C:\Users\vokov\bin\agy-switch.ps1

[2/3] Testing Antigravity Claude Proxy (Port 8080)...
 [PASS] Proxy is running. Version: 1.1.0
 [PASS] Accounts in pool: 2 available / 2 total
        - tukroschu@gmail.com (Score: 967.4, Pro: pro)
        - arsen.k111999@gmail.com (Score: 965.0, Pro: pro)

[3/3] Testing Charm Crush CLI Integration...
 [PASS] Crush binary found: C:\Users\vokov\bin\crush.exe
 [*] Running test prompt through Crush (Claude Sonnet 4.6 via Proxy)...
 [PASS] Crush inference succeeded!
        Response: CRUSH_PROXY_PIPELINE_OK
```

---

## 📁 Repository Structure

```text
agy-windows-toolkit/
├── README.md                          # Documentation and architecture guide
├── setup.ps1                          # All-in-one turnkey installer
├── docs/
│   └── EDGEE_ANTIGRAVITY_INTEGRATION.md # End-to-end integration & deployment guide
├── bin/                               # Direct runtime wrappers (%PATH% drop-in)
│   ├── crash.ps1 / crash.cmd          # Primary Edgee launcher with auto-gateway
│   ├── crash-edgee.ps1 / .cmd         # Explicit Edgee compression runner
│   ├── crash-raw.ps1 / .cmd           # Offline loopback direct launcher
│   └── crach.ps1 / .cmd               # Typo-tolerant alias wrappers
├── config/
│   ├── crush/
│   │   ├── crush.json                 # Crush provider config (BOM-free UTF-8)
│   │   └── crushrc                    # Crush runtime options
│   └── proxy/
│       ├── accounts.template.json     # Clean account pool schema template
│       └── config.example.json        # Proxy strategy settings
└── scripts/
    ├── agy-switch.ps1                 # Core profile switching engine
    ├── agy-me.cmd                     # Fast wrapper for 'me'
    ├── agy-son.cmd                    # Fast wrapper for 'son'
    ├── setup-proxy.ps1                # Proxy installer and service configurator
    ├── setup-crush.ps1                # Crush config deployment script
    ├── start-proxy.cmd                # Launcher (background or foreground)
    ├── start-proxy.vbs                # Silent VBS launcher (no console window)
    ├── stop-proxy.cmd                 # Graceful terminator
    └── test-pipeline.ps1              # Full verification pipeline
```

---

## 🛡️ License & Credits

- Maintained by [maxfraieho](https://github.com/maxfraieho).
- Released under MIT License.
