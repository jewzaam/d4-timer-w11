# D4 Timer — Diablo 4 Event Tracker for Windows 11

System tray app that alerts you ahead of World Boss, Helltide, and Legion events via audio + on-screen popup. Event data sourced from the [helltides.com](https://helltides.com) community API.

## Requirements

- Windows 11
- Python 3.11+

## Install

```powershell
pip install git+https://github.com/jewzaam/d4-timer-w11
```

## Run

```powershell
pythonw -m d4_timer
```

> Use `pythonw` (not `python`) to avoid a console window opening alongside the tray icon.

## Auto-start on login (optional)

Run this once in PowerShell to register D4 Timer as a startup app. It will appear in Task Manager → Startup Apps and can be disabled there at any time.

```powershell
$pythonw = (Get-Command python).Source -replace 'python\.exe','pythonw.exe'
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" `
    -Name "D4Timer" -Value "`"$pythonw`" -m d4_timer"
```

To remove it:

```powershell
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "D4Timer"
```

## Development

```bash
git clone https://github.com/jewzaam/d4-timer-w11
cd d4-timer-w11
make install-dev
make run          # Start normally
make run-debug    # Start with debug logging
```

To suppress audio (popups still appear):

```bash
python3 -m d4_timer --quiet
```

## Features

- **System tray icon** — colored circle matching the window border; green when alerts are active, gray when muted or suppressed; left-click opens the countdown window
- **Countdown window** — borderless, always-on-top; colored border mirrors the tray icon (green = live, gray = muted/suppressed); drag to reposition; right-click for context menu; Helltide shows active/countdown state
- **Alerts** — configurable lead time per event type (1–240 min); audio beep + dismissable popup
- **Mute** — tray and context menu checkmark item; icon and border turn gray
- **Game detection** — optional suppression of alerts when Diablo IV is not running (Settings → "Only alert while Diablo IV is running"); icon and border turn gray when suppressed
- **Settings** — per-event alert lead time, enabled toggle, window/alert background color, alert tone frequency (100–8000 Hz) with live test button, auto-dismiss, game detection toggle
- **Persistence** — window positions, colors, and all settings saved to `%APPDATA%\d4-timer\settings.json`
- **License** — GPL-3.0-or-later

## Development

| Target | Description |
|--------|-------------|
| `make install-dev` | Install package and dev dependencies |
| `make test` | Run unit tests |
| `make coverage` | Coverage report (target: ≥80%) |
| `make lint` | flake8 |
| `make format` | black |
| `make typecheck` | mypy |

## Architecture

- **Main thread:** tkinter `mainloop()` + 1-second tick for UI updates and alert checks
- **Poll thread:** daemon thread, fetches API on startup then every 10 minutes with exponential backoff on failure
- **Tray thread:** pystray event loop; all callbacks dispatched to main thread via `root.after()`
- No binary assets — icon and audio generated at runtime
