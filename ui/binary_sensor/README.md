[← Back to main README](../../README.md)

# ui/binary_sensor

Read-only indicator tile. Tile color reflects the current on/off state — no tap action.

Simple type — tile only, no detail page.

## Files

| File | Purpose |
|---|---|
| `local.yaml` | ESPHome binary sensor component (defined in the same device YAML) |
| `remote.yaml` | Home Assistant binary sensor entity |

## Variables

| Variable | Required | Description |
|---|---|---|
| `uid` | ✅ | Unique identifier — must be unique across all tiles on the device |
| `entity_id` | ✅ | ESPHome binary sensor ID (local) or HA entity string e.g. `"binary_sensor.front_door"` (remote) |
| `row` | ✅ | Grid row position (0-based) |
| `column` | ✅ | Grid column position (0-based) |
| `text` | ✅ | Label shown on tile |
| `icon` | ✅ | MDI glyph e.g. `$mdi_door_open` |
| `bg_opa` | — | Background opacity. 0%-100% or text TRANSP or COVER, for fully opaque (optional, default: COVER) |
| `row_span` | — | Number of rows to span (default: `1`) |
| `column_span` | — | Number of columns to span (default: `1`) |
| `page_id` | — | Parent page ID to place the tile on (default: `main_page`) |

## Usage

```yaml
# Local — ESPHome binary sensor component
motion_tile: !include
  file: esphome-modular-lvgl-buttons/ui/binary_sensor/local.yaml
  vars:
    uid: motion
    entity_id: pir_sensor     # your binary_sensor: component id
    row: 0
    column: 0
    text: "Motion"
    icon: $mdi_motion_sensor

# Remote — door contact sensor
door_tile: !include
  file: esphome-modular-lvgl-buttons/ui/binary_sensor/remote.yaml
  vars:
    uid: front_door
    entity_id: "binary_sensor.front_door"
    row: 0
    column: 1
    text: "Front Door"
    icon: $mdi_door

# Remote — leak sensor
leak_tile: !include
  file: esphome-modular-lvgl-buttons/ui/binary_sensor/remote.yaml
  vars:
    uid: leak
    entity_id: "binary_sensor.kitchen_leak"
    row: 0
    column: 2
    text: "Leak"
    icon: $mdi_water_alert
```

## Notes

- `on` state renders with `$button_on_color` / `$icon_on_color` — same as an active switch tile.
- `off` state renders with `$button_off_color` / `$icon_off_color`.
- The tile is not clickable — `clickable: false` is set on the button widget.
