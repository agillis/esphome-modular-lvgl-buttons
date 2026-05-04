[← Back to main README](../../README.md)

# ui/text_sensor

Read-only tile that displays a live string value. The value updates automatically on every change. No tap action.

Simple type — tile only, no detail page.

## Files

| File | Purpose |
|---|---|
| `local.yaml` | ESPHome text sensor component (defined in the same device YAML) |
| `remote.yaml` | Home Assistant entity state or attribute |

## Variables

| Variable | Required | Description |
|---|---|---|
| `uid` | ✅ | Unique identifier — must be unique across all tiles on the device |
| `entity_id` | ✅ | ESPHome text sensor ID (local) or HA entity string e.g. `"sensor.washing_machine"` (remote) |
| `row` | ✅ | Grid row position (0-based) |
| `column` | ✅ | Grid column position (0-based) |
| `text` | ✅ | Label shown on tile (sensor name) |
| `icon` | ✅ | MDI glyph e.g. `$mdi_information` |
| `bg_opa` | — | Background opacity. 0%-100% or text TRANSP or COVER, for fully opaque (optional, default: COVER) |
| `attribute` | — | HA attribute to display instead of the entity state (remote only, default: state) |
| `row_span` | — | Number of rows to span (default: `1`) |
| `column_span` | — | Number of columns to span (default: `1`) |
| `page_id` | — | Parent page ID to place the tile on (default: `main_page`) |

## Usage

```yaml
# Local — ESPHome text sensor
version_tile: !include
  file: esphome-modular-lvgl-buttons/ui/text_sensor/local.yaml
  vars:
    uid: fw_version
    entity_id: esphome_version   # your text_sensor: component id
    row: 0
    column: 0
    text: "Firmware"
    icon: $mdi_information

# Remote — HA entity state
washer_tile: !include
  file: esphome-modular-lvgl-buttons/ui/text_sensor/remote.yaml
  vars:
    uid: washer
    entity_id: "sensor.washing_machine_status"
    row: 0
    column: 1
    text: "Washer"
    icon: $mdi_washing_machine

# Remote — display a specific HA attribute instead of the state
ssid_tile: !include
  file: esphome-modular-lvgl-buttons/ui/text_sensor/remote.yaml
  vars:
    uid: wifi_ssid
    entity_id: "sensor.my_panel"
    attribute: "ssid"
    row: 1
    column: 0
    text: "Wi-Fi"
    icon: $mdi_wifi
```

## Notes

- The value label shows `"--"` on boot until the first reading arrives.
- Long values are truncated with `…` (`long_mode: dot`) to fit the tile width.
- The `attribute` var is remote-only — the local variant always displays the sensor's primary state value.
