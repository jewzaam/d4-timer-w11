# D4 Timer — Diablo 4 Event Tracker for Windows 11

System tray app that polls the helltides.com public API and alerts you ahead of World Boss, Helltide, and Legion events via audio + on-screen popup.

## Requirements

- Windows 11
- Python 3.11+

## Installation

```bash
pip install -e .
pip install pytest pytest-cov black flake8 "mypy==1.11.2"
```

Or use the Makefile:

```bash
make install-dev
```

## Usage

```bash
# Run normally
python -m d4_timer

# With debug logging
python -m d4_timer --debug

# Suppress audio (popups still appear)
python -m d4_timer --quiet
```

Or via installed script:

```bash
d4-timer
```

## Features

- **System tray icon** — crimson circle (gray when muted); left-click opens the countdown window
- **Countdown window** — shows time remaining for next World Boss, Helltide, and Legion event
- **Alerts** — configurable lead time per event type; audio + auto-dismissing popup
- **Mute all** — silences audio; icon turns gray
- **Settings** — per-event alert lead time and enable/disable toggle
- **Persistence** — settings saved to `%APPDATA%\d4-timer\settings.json`

## Development

```bash
make test          # Run unit tests
make coverage      # Coverage report (target: ≥80%)
make lint          # flake8
make format        # black
make typecheck     # mypy
```

## Data Source

Events sourced from the [helltides.com](https://helltides.com) community API. No official Blizzard API exists for this data.

## Architecture

- **Main thread:** tkinter `mainloop()` + 1-second tick for UI updates and alert checks
- **Poll thread:** daemon thread polling API every 60s with exponential backoff
- **Tray thread:** pystray event loop; all callbacks dispatched to main thread via `root.after()`
- No binary assets — icon and audio generated at runtime
