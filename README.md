# D4 Timer — Diablo 4 Event Tracker for Windows 11

System tray app that alerts you ahead of World Boss, Helltide, and Legion events via audio + on-screen popup. Event data sourced from the [helltides.com](https://helltides.com) community API.

## Requirements

- Windows 11
- Python 3.11+

## Setup

```bash
make install-dev
```

## Usage

```bash
make run          # Start normally
make run-debug    # Start with debug logging
```

To suppress audio (popups still appear), run directly:

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

## System Startup (optional)

To launch on login with no console window, create a Task Scheduler entry:

1. Open **Task Scheduler** → **Create Task**
2. **General** tab: check "Run only when user is logged on"
3. **Triggers** tab: New → "At log on"
4. **Actions** tab: New → Start a program
   - Program: `C:\Users\<you>\AppData\Local\Python\pythoncore-3.14-64\pythonw.exe`
   - Arguments: `-m d4_timer`
   - Start in: path to the project directory

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
