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

- **System tray icon** — crimson circle (gray when muted); left-click opens the countdown window
- **Countdown window** — shows time remaining for next World Boss, Helltide, and Legion event
- **Alerts** — configurable lead time per event type; audio + auto-dismissing popup
- **Mute all** — silences audio; icon turns gray
- **Settings** — per-event alert lead time and enable/disable toggle
- **Persistence** — settings saved to `%APPDATA%\d4-timer\settings.json`

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
