# CLAUDE.md — esphome-modular-lvgl-buttons


---

## The Core Architecture

Every entity type (light, switch, sensor, climate, button, …) is implemented as a set of files co-located in one folder:

```
ui/<type>/local.yaml     — tile widget for a locally-defined ESPHome entity
ui/<type>/remote.yaml    — tile widget for a Home Assistant entity
ui/<type>/detail.yaml    — full-screen detail UI (complex types only)
```

### The Local / Remote Split

Every entity type gets **both** a local and a remote variant — no exceptions. The two variants differ only in how they communicate with the entity:

- **local** — drives ESPHome components directly via native actions (`light.turn_on`, `switch.toggle`, etc.), `on_state` hooks, and lambdas reading component state
- **remote** — drives HA via `homeassistant.action` and reads state via `homeassistant` platform sensors and text_sensors

Everything else — tile layout, globals, detail page, abstract script names — is identical between local and remote.

### The Detail Page (complex types only)

Simple types (switch, button) are tile-only. A tap performs the action, nothing more.

Complex types (light, climate, likely sensor) get a detail page opened via long-press on the tile. The detail page:

- Lives in `ui/<type>/detail.yaml`, alongside `local.yaml` and `remote.yaml`
- Is pulled in by **both** `local.yaml` and `remote.yaml` via `packages:` as `file: detail.yaml`
- Calls only abstract scripts — it has zero knowledge of whether the entity is local or remote
- Declares all shared globals for that type

### The Abstract Script Contract

The mechanism that makes local and remote interchangeable. Every button file defines a fixed set of scripts prefixed with `${uid}_`. The detail page calls these scripts; the button file implements them. The detail page never directly references an ESPHome component ID or a HA entity.

The contract is defined per entity type. The light type is the reference implementation.

---

## Folder Structure

```
ui/
  light/
    local.yaml           ✅ implemented
    remote.yaml          ✅ implemented
    detail.yaml          ✅ implemented
  switch/
    local.yaml           ✅ implemented
    remote.yaml          ✅ implemented
  sensor/
    local.yaml           ✅ implemented
    remote.yaml          ✅ implemented
  binary_sensor/
    local.yaml           ✅ implemented
    remote.yaml          ✅ implemented
  text_sensor/
    local.yaml           ✅ implemented
    remote.yaml          ✅ implemented
  button/
    local.yaml           ✅ implemented
    remote.yaml          ✅ implemented
  climate/
    local.yaml           ✅ implemented
    remote.yaml          ✅ implemented
    detail.yaml          ✅ implemented
  clock/
    flip_clock.yaml      ✅ implemented
  weather/
    today.yaml           ✅ implemented
    forecast.yaml        ✅ implemented
  solar/                 ✅ implemented
  tides/                 ✅ implemented

pages/                   global UI pages — reuse as-is, do not modify
  loading.yaml           boot screen (top_layer overlay, not a page)
  info.yaml

common/                  shared infrastructure — reuse as-is, do not modify
  sensors_base.yaml      WiFi signal, CPU temp, restart buttons
  sensors_base_sdl.yaml  SDL desktop testing variant
  swipe_navigation.yaml  swipe gesture handler for pages
  wifi.yaml, ota.yaml, color.yaml, fonts.yaml, theme_style.yaml, ...

hardware/                device-specific configs — reuse as-is, do not modify

example_code/            example device configs
  advanced/              advanced integration examples (solar, tides, weather, clock)
```

---

## Variable Contract (all entity types)

Every button include uses these vars:

| Variable | Type | Description |
|---|---|---|
| `uid` | string | Unique identifier — prefixes all IDs, globals, scripts |
| `entity_id` | string | ESPHome component ID (local) or HA entity string e.g. `"light.foo"` (remote) |
| `row` | int | Grid row on parent page |
| `column` | int | Grid column on parent page |
| `text` | string | Tile label and detail page header |
| `icon` | glyph | MDI icon glyph |
| `row_span` | int | Optional, default 1 |
| `column_span` | int | Optional, default 1 |
| `page_id` | string | Parent page ID, optional, default `main_page` |

Individual types may add type-specific optional vars (e.g. `min_temp`, `max_temp` for climate).

---

## Reference Implementation: Light

### Abstract Script Contract

Each light button file must implement:

| Script | Responsibility |
|---|---|
| `${uid}_light_toggle` | Toggle on/off |
| `${uid}_light_set_brightness` | Apply `${uid}_current_brightness` [0.0–1.0] |
| `${uid}_light_apply_hs` | Apply `${uid}_current_hue` [0–360] + `${uid}_current_saturation` [0–100] |
| `${uid}_light_apply_color_temp` | Apply `${uid}_current_color_temp` [Kelvin] |

The detail page defines:

| Script | Responsibility |
|---|---|
| `${uid}_sync_state` | Push all globals → LVGL widget values and colors |
| `${uid}_update_visibility` | Show/hide controls based on detected capabilities |
| `${uid}_toggle_color_mode` | Flip RGB ↔ CCT mode if light supports both |
| `${uid}_update_bulb_color` | Recompute bulb glow color from current state |

### Globals (declared in `ui/light/detail.yaml`)

| Global | Type | Range |
|---|---|---|
| `${uid}_is_on` | bool | — |
| `${uid}_current_brightness` | float | 0.0–1.0 |
| `${uid}_current_hue` | float | 0–360 |
| `${uid}_current_saturation` | float | 0–100 |
| `${uid}_current_color_temp` | float | Kelvin, 2000–6500 |
| `${uid}_is_temp_mode` | bool | false=RGB, true=CCT |
| `${uid}_supports_rgb` | bool | detected at runtime |
| `${uid}_supports_color_temp` | bool | detected at runtime |
| `${uid}_supports_brightness` | bool | detected at runtime |

### Capability Detection

Never declared by the user — always detected at runtime:

- **local**: read from `get_traits()` inside `light.on_state`, checking `ColorCapability::RGB`, `COLOR_TEMPERATURE`, `COLD_WARM_WHITE`, `BRIGHTNESS`
- **remote**: parsed from the HA `supported_color_modes` text sensor attribute (presence of `"rgb"`, `"color_temp"`, `"brightness"` substrings)

---

## Popup System (ui/popup/popup_system.yaml)

All popups live in LVGL's `top_layer` (singleton overlay that floats above every page).
A shared `popup_scrim` provides the dim backdrop and catches taps outside popups to close everything.

### Opening a Popup

```yaml
- lvgl.widget.show: popup_scrim
- lvgl.widget.show: popup_<name>
- script.execute: popup_start_timeout
```

### Auto-Close Timeout

Popups automatically close after a configurable timeout (default 120 seconds).
Set in the top-level page substitutions:

```yaml
substitutions:
  popup_timeout_seconds: '120'  # Change to desired seconds
```

The timeout is managed by:
- `popup_start_timeout` — starts the delay and calls `popup_close` when expired
- `popup_timeout_seconds` — global int (seconds), initialized from substitution

When a user closes the popup manually (tap scrim, click button, etc.), the delay is cancelled automatically.

### Force Close

To immediately close all popups (e.g., before an update or page change):

```yaml
- script.execute: popup_force_close
```

This will hide the scrim and all popups instantly, cancelling any active timeout.

---

## Color Picker (common/color_picker.yaml)

Reusable per-instance HSV/Kelvin color picker popup. Size: 450×450px (centered on screen).

### Variables

| Variable | Type | Description |
|---|---|---|
| `uid` | string | Instance identifier, must match the parent light tile |
| `text` | string | Popup title (default "Color Picker") |
| `mode` | string | `"rgb"` / `"kelvin"` / `"both"` (default "both") |

### Public API (provided to parent)

| Item | Type | Purpose |
|---|---|---|
| `${uid}_popup` | widget | The popup container (hidden by default) |
| `${uid}_mode_kelvin` | global bool | false=HSV ring, true=Kelvin ring |
| `${uid}_picker_update` | script | Refresh swatch + readout from globals |
| `${uid}_picker_apply_mode` | script | Sync widget visibility from mode+global |
| `${uid}_mode_toggle` | script | Flip HSV ↔ Kelvin + reapply |

### Required from Host (light tile)

Parent light file must define these for each picker instance:

| Item | Type | Purpose |
|---|---|---|
| `${uid}_current_hue` | global float | 0–360 |
| `${uid}_current_saturation` | global float | 0–100 |
| `${uid}_current_color_temp` | global float | Kelvin |
| `${uid}_current_brightness` | global float | 0.0–1.0 |
| `${uid}_light_toggle` | script | Toggle on/off |
| `${uid}_light_set_brightness` | script | Apply brightness |
| `${uid}_light_apply_hs` | script | Apply HSV |
| `${uid}_light_apply_color_temp` | script | Apply Kelvin |
| `slider_${uid}` | widget | Tile-side brightness slider (synced when popup changes) |

### Example Usage

In a light tile file:

```yaml
packages:
  color_picker_rgb:
    file: esphome-modular-lvgl-buttons/common/color_picker.yaml
    vars:
      uid: my_light
      text: "RGB Light"
      mode: "rgb"
```

To open the picker:

```yaml
- lvgl.widget.show: popup_scrim
- lvgl.widget.show: my_light_popup
- script.execute: popup_start_timeout
```

---

## Rules for Implementing New Entity Types

1. Create `ui/<type>/`
2. Define the abstract script contract in a comment block at the top of `ui/<type>/detail.yaml`, or at the top of both button files if tile-only
3. `local.yaml` implements the scripts using ESPHome native actions and hooks
4. `remote.yaml` implements the same scripts using `homeassistant.action` and `homeassistant` platform sensors
5. `detail.yaml` calls only abstract scripts — never references a component ID or HA entity directly
6. Globals go in `detail.yaml` for complex types, in the button files for tile-only types
7. Namespace everything with `${uid}_` — all IDs, globals, scripts, LVGL widget IDs
8. Tile layout is consistent across all types: icon top-left, label bottom-left, optional inline control top-right, short-click = primary action, long-press = detail page (complex types only)

---

## ESPHome Jinja/Substitutions

ESPHome uses Jinja2 but with **different delimiters** than standard Jinja. Getting this wrong produces broken YAML.

### Expression Syntax
- ESPHome uses `${...}` instead of `{{ ... }}` for expressions
- **`{% if %}` / `{% else %}` blocks are NOT supported** — use inline ternary instead

## Conventions

- **Color temperature** stored internally in Kelvin always. Convert to mireds only at the ESPHome API boundary.
- **Brightness** stored as float 0.0–1.0. LVGL sliders operate 0–255 and convert on read/write.
- **HA attribute strings**: numbers parsed with `atof(x.c_str())`, tuples like `"(120.5, 80.0)"` split on `','`.
- **One include per entity**: a device YAML needs only a single `!include`. All internal dependencies (detail page, globals, scripts) are wired via `packages:` inside the component files.
- **Theme vars only**: use `$button_on_color`, `$button_off_color`, `$icon_on_color`, `$icon_off_color`, `$label_on_color`, `$label_off_color`, `$icon_font` — never hardcode colors or fonts in component files.
- **Hardware agnostic**: component files must not hardcode pixel coordinates or assume a specific screen resolution. Layout must work across all supported displays (ranging from 320×240 to 800×1280). Use LVGL alignment properties (`align`, `grid_cell_*`, percentage-based widths/heights) instead of fixed x/y values wherever possible. The current development hardware is the Waveshare ESP32-S3-Touch-LCD-4 (480×480) but this is not a constraint.
- **ESPHome 2026.7.0+** required (the `image:` component uses the new `platform: file` form introduced in 2026.7.0).
