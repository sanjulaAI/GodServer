# GOD SERVER

All-in-one Windows toolbox. White professional theme, gold accents. Runs from any PC with one line of PowerShell.

## Launch

```powershell
irm https://raw.githubusercontent.com/sanjulaAI/GodServer/main/bootstrap.ps1 | iex
```

Auto-elevates to admin, opens the GUI.

## What it does

- **Dashboard** — live CPU/RAM/Disk usage, network info (local IP, gateway, DNS, public IP), ping test
- **Install Apps** — winget-driven installer, 6 categories (Browsers, Development, Utilities, Media, Communication, Gaming)
- **Tweaks** — 7 reversible toggles (telemetry, Cortana, file extensions, Bing search, classic right-click menu, dark mode, sticky keys) + one-shot bloatware removal
- **Drivers** — view installed drivers, jump to Windows Update optional updates
- **Utilities** — system info, clean temp, flush DNS, WiFi passwords, installed apps list, product key, network reset, restart Explorer
- **Advanced** — high-risk tools (permanent debloater, EXM tweaks, GodMode, process killer, BIOS mod), fetched from `batch/` at run time, gated behind double confirmation and risk badges (`!` / `!!` / `!!!`)

## Structure

```
GodServer/
├── bootstrap.ps1      # one-liner entry point — downloads + runs GodServer.ps1
├── GodServer.ps1       # main single-file WinForms GUI (all safe features)
├── batch/              # high-risk .bat scripts, only fetched when Advanced tools are run
│   ├── permanent-debloater.bat
│   ├── exm-premium-tweaks.bat
│   ├── godmode.bat
│   ├── nuclear-process-killer.bat
│   └── auto-bios.bat
└── assets/
```

## Design

- White background, dark navy sidebar, gold accent — custom-drawn WinForms controls (rounded buttons, toggle switches, nav bar, cards) via an embedded C# `Add-Type` block
- Borderless custom title bar with drag-to-move
- Tweaks are declarative: each defines its registry keys once, and a generic engine handles backup + apply + revert — flip a toggle off to restore the original value
- Backups stored at `%LOCALAPPDATA%\GodServer\backup.json`

## Before you push this repo

1. Create the repo as `sanjulaAI/GodServer` (public, so `irm` works without auth) — or update `$Global:RepoBase` in `GodServer.ps1` and the `$RepoBase` in `bootstrap.ps1` if you use a different name.
2. Repo must be public for `irm` to work without auth.
3. Force a fresh download during testing with a `?v=$(Get-Random)` suffix (already built into both scripts).

## Notes

- Tested logic is carried over from SanjulaKit's proven tweak/app/utility scripts, ported into the new single-file GUI.
- This has not been run on real hardware yet — as usual, run it and report back anything that errors and I'll patch it.
