# D4 Timer — Test Plan

## Unit Tests (Automated)

### `test_api.py` — `d4_timer.api`
| Test | Description |
|------|-------------|
| `test_parses_world_boss` | Fixture JSON → correct EventData fields |
| `test_parses_helltide` | Fixture JSON → correct EventData fields |
| `test_parses_legion` | Fixture JSON → correct EventData fields |
| `test_empty_response` | `{}` → empty lists, no error |
| `test_skips_entries_missing_timestamp` | Items without `timestamp` excluded |
| `test_world_boss_no_zone` | Empty `zone` array → `zone_name=None` |
| `test_next_event_returns_first` | First item in list returned |
| `test_next_event_empty_returns_none` | Empty list → `None` |
| `test_null_arrays_handled` | `null` values don't crash parser |
| `test_timestamp_coerced_to_int` | String timestamps coerced |
| `test_returns_parsed_json` | Mocked `requests.get` returns fixture data |
| `test_raises_on_http_error` | `raise_for_status` exception propagates |

### `test_settings.py` — `d4_timer.settings`
| Test | Description |
|------|-------------|
| `test_returns_defaults_when_file_missing` | Missing path → defaults |
| `test_returns_defaults_on_corrupt_json` | Invalid JSON → defaults |
| `test_returns_defaults_on_wrong_type` | `null` JSON → defaults |
| `test_loads_valid_settings` | Full valid JSON → correct values |
| `test_ignores_invalid_alert_minutes_values` | Negative/string values fall back to defaults |
| `test_partial_settings_merged_with_defaults` | Partial JSON → merged with defaults |
| `test_saves_and_reloads` | Round-trip save/load preserves all values |
| `test_creates_parent_directory` | Nested path created automatically |
| `test_atomic_write_no_tmp_left_on_success` | `.tmp` file cleaned up |
| `test_file_contains_valid_json` | Saved file is parseable JSON |
| `test_get_alert_minutes_present` | Returns set value |
| `test_get_alert_minutes_missing_uses_default` | Falls back to config default |
| `test_is_enabled_true/false` | Returns set value |
| `test_is_enabled_missing_defaults_true` | Missing key → enabled |

### `test_scheduler.py` — `d4_timer.scheduler`
| Test | Description |
|------|-------------|
| `test_countdown_future` | HH:MM:SS formatted correctly |
| `test_countdown_past_shows_zero` | Past events show `00:00:00` |
| `test_countdown_none_event` | `None` → `--:--:--` |
| `test_seconds_until_positive/negative` | Correct sign |
| `test_alert_fires_within_window` | Alert fires inside `[ts - lead, ts)` |
| `test_alert_does_not_fire_before_window` | Before window → no alert |
| `test_alert_does_not_fire_after_event` | After event → no alert |
| `test_alert_fires_only_once` | Dedup via `_fired` set |
| `test_reset_fired_allows_refiring` | `reset_fired()` clears dedup state |
| `test_disabled_event_no_alert` | Disabled event → no alert |
| `test_multiple_events_all_fire` | All three event types fire simultaneously |
| `test_empty_schedule_no_alerts` | Empty schedule → no alerts |
| `test_alert_at_exact_alert_time_boundary` | Inclusive lower bound fires |
| `test_alert_at_one_second_before_event` | Exclusive upper bound fires |

### `test_audio.py` — `d4_timer.audio`
| Test | Description |
|------|-------------|
| `test_returns_sound_object_on_success` | Mock pygame → returns Sound |
| `test_caches_sound_on_second_call` | `make_sound` called once across two calls |
| `test_returns_none_when_init_fails` | Init failure → `None` |
| `test_returns_none_when_make_sound_raises` | Exception in make_sound → `None` |
| `test_calls_play_on_sound` | `play_alert()` calls `sound.play()` |
| `test_no_op_when_no_sound` | `None` sound → no crash |
| `test_no_op_when_play_raises` | Exception in `play()` → no propagation |
| `test_clears_sound_cache` | `reset_cache()` clears state |

## Manual Verification Checklist

- [ ] `make install-dev` — all dependencies install without error
- [ ] `make test` — all unit tests pass
- [ ] `make coverage` — ≥80% coverage reported
- [ ] `make lint` — no flake8 violations
- [ ] `make format` — no black changes needed (or apply and re-check)
- [ ] `python -m d4_timer --debug` — app starts, tray icon appears in system tray
- [ ] Left-click tray icon → main window appears with three countdown rows
- [ ] Set alert_minutes low enough to put an upcoming event in-window → audio fires + popup appears
- [ ] Click "Mute All" in main window → icon turns gray, no audio on next alert
- [ ] Click "Settings" → modal opens; change values and Save → settings persist across restart
- [ ] Disable a timer in Settings → countdown row still visible but shows time, no alert fires
- [ ] Close main window → app stays in tray; reopen via click
- [ ] Right-click tray → Quit → app exits cleanly
