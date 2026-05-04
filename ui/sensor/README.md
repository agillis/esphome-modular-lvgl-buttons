[← Back to main README](../../README.md)

# ui/sensor

Read-only tile that displays a live numeric sensor value. No actions, no detail page.

The tile shows the icon top-left, the sensor name bottom-left, and the formatted value top-right. The value updates automatically whenever the sensor reports a new reading.

## Files

| File | Purpose |
|---|---|
| `local.yaml` | ESPHome sensor component (defined in the same device YAML) |
| `remote.yaml` | Home Assistant sensor entity |

## Variables

| Variable | Required | Description |
|---|---|---|
| `uid` | ✅ | Unique identifier — must be unique across all tiles on the device |
| `entity_id` | ✅ | ESPHome sensor ID (local) or HA entity string e.g. `"sensor.temperature"` (remote) |
| `attribute` | — | HA attribute to display instead of the entity state (remote only, default: state) |
| `row` | ✅ | Grid row position (0-based) |
| `column` | ✅ | Grid column position (0-based) |
| `text` | ✅ | Label shown on tile |
| `icon` | ✅ | MDI glyph e.g. `$mdi_thermometer` |
| `bg_opa` | — | Background opacity. 0%-100% or text TRANSP or COVER, for fully opaque (optional, default: COVER) |
| `unit` | — | Unit string appended to the value e.g. `"°C"`, `"%"`, `"W"` (default: none) |
| `precision` | — | Decimal places in the displayed value (default: `1`) |
| `row_span` | — | Number of rows to span (default: `1`) |
| `column_span` | — | Number of columns to span (default: `1`) |
| `page_id` | — | Parent page ID to place the tile on (default: `main_page`) |
| `sensor_font` | — | Font for the sensor value, e.g. `nunito_36` |
| `label_font` | — | Font for the label text, e.g. `nunito_36` |

## Usage

```yaml
# Local — ESPHome sensor component
cpu_temp_btn: !include
  file: esphome-modular-lvgl-buttons/ui/sensor/local.yaml
  vars:
    uid: cpu_temp
    entity_id: cpu_temperature  # your sensor: component id
    row: 0
    column: 0
    text: "CPU"
    icon: $mdi_chip
    unit: "°C"
    precision: 0

# Remote — Home Assistant sensor entity
outdoor_temp_btn: !include
  file: esphome-modular-lvgl-buttons/ui/sensor/remote.yaml
  vars:
    uid: outdoor_temp
    entity_id: "sensor.outdoor_temperature"
    row: 0
    column: 1
    text: "Outdoor"
    icon: $mdi_thermometer
    unit: "°C"
    precision: 1

# Power meter — integer, unit, no decimal
solar_power_btn: !include
  file: esphome-modular-lvgl-buttons/ui/sensor/remote.yaml
  vars:
    uid: solar_power
    entity_id: "sensor.solar_power"
    row: 1
    column: 0
    text: "Solar"
    icon: $mdi_solar_power
    unit: "W"
    precision: 0
```

## Notes

- The value label shows `"--"` on boot until the first reading arrives.
- `unit` and the value are separated by a space automatically when `unit` is non-empty.
- The tile uses a `button` widget with `clickable: false` so it inherits all theme styles (radius, padding, colors) but does not respond to taps.
