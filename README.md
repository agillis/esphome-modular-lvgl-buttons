# esphome-modular-lvgl-buttons

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ESPHome](https://img.shields.io/badge/ESPHome-2025.1+-blue)](https://esphome.io)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Integration-41BDF5)](https://www.home-assistant.io/)

A modular component library for building touchscreen smart home control panels using [ESPHome](https://esphome.io/) + [LVGL](https://lvgl.io/) on cheap ESP32 displays.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full design rationale.

---

## How it works

Each entity type lives in `ui/<type>/` and provides:

```
ui/<type>/local.yaml    — tile for an ESPHome component on the same device
ui/<type>/remote.yaml   — tile for a Home Assistant entity
ui/<type>/detail.yaml   — full-screen detail page (complex types only)
```

Your device YAML composes a panel by including one hardware file, the shared infrastructure, and one `!include` per tile. Everything internal (globals, scripts, detail page) is wired automatically.

---

## Quick start

### 1. Prerequisites

ESPHome 2025.1 or later. For SVG image support (required by solar/tides modules):

```bash
pip install cairosvg
```

### 2. Clone into your ESPHome config directory

```bash
cd /config   # or wherever your ESPHome configs live
git clone https://github.com/iezhkv/esphome-modular-lvgl-buttons.git
```

### 3. Set up secrets

Create `secrets.yaml` in your ESPHome config root (one level above this repo):

```yaml
wifi_ssid: "your-ssid"
wifi_password: "your-wifi-password"
ap_password: "your-fallback-ap-password"
latitude: 0.0000
longitude: 0.0000
api_encryption_key: "your-base64-key"
ota_password: "your-ota-password"
```

Generate an API key:
```bash
python3 -c "import secrets,base64; print(base64.b64encode(secrets.token_bytes(32)).decode())"
```

### 4. Create your device config

Copy the closest example from `example_code/` and adapt it, or start from scratch:

```yaml
substitutions:
  icon_font:    mdi_icons_40
  text_font:    nunito_20
  button_on_color:  "ep_orange"
  button_off_color: "very_dark_gray"
  icon_on_color:    "yellow"
  icon_off_color:   "gray"
  label_on_color:   "white"
  label_off_color:  "gray"
  display_daytime_brightness:   "100%"
  display_nighttime_brightness: "50%"
  display_night_hour:   "22"
  display_night_minute: "0"
  display_backlight_timeout_always_enabled: "false"
  display_backlight_timeout_initial: "30"
  screen_width:  "480"
  screen_height: "480"

  # you can use the glyphsets to support additional characters
  # see also https://esphome.io/components/font/#configuration-variables
  #
  # glyphsets: "GF_Latin_Core"

esphome:
  name: my-panel
  friendly_name: My Panel
  on_boot:
  - priority: 400
    then:
    - script.execute: update_loading_page

logger:

script:
- id: time_update
  then:
  - lambda: return;

packages:
  wifi:           !include esphome-modular-lvgl-buttons/common/wifi.yaml
  ota_screen:     !include esphome-modular-lvgl-buttons/common/ota.yaml
  theme:          !include esphome-modular-lvgl-buttons/common/theme/index.yaml
  sensors:        !include esphome-modular-lvgl-buttons/common/sensors_base.yaml
  backlight:      !include esphome-modular-lvgl-buttons/common/backlight_time.yaml
  hardware:       !include esphome-modular-lvgl-buttons/hardware/<your-hardware>.yaml
  loading_screen: !include esphome-modular-lvgl-buttons/pages/loading.yaml
  info_screen:    !include esphome-modular-lvgl-buttons/pages/info.yaml

  my_light: !include
    file: esphome-modular-lvgl-buttons/ui/light/remote.yaml
    vars:
      uid: my_light
      entity_id: "light.living_room"
      row: 0
      column: 0
      text: "Living Room"
      icon: $mdi_ceiling_light

lvgl:
  buffer_size: 100%
  pages:
  - id: main_page
    layout: 2x3
    styles: page_style
    <<: !include esphome-modular-lvgl-buttons/common/swipe_navigation.yaml

font:
- file: 'https://github.com/Templarian/MaterialDesign-Webfont/raw/v7.4.47/fonts/materialdesignicons-webfont.ttf'
  id: mdi_icons_40
  size: 40
  bpp: 8
  glyphs:
  # required by light detail page
  - $mdi_brightness_6
  - $mdi_chevron_up
  - $mdi_circle_opacity
  - $mdi_eyedropper
  - $mdi_lightbulb
  # your tile icons
  - $mdi_ceiling_light
  - $mdi_information_box
```

### 5. Flash

```bash
esphome run my-panel.yaml
```

---

## Available entity types

| Type | local | remote | Detail page | Notes |
|---|---|---|---|---|
| [`light`](ui/light/README.md) | ✅ | ✅ | ✅ | RGB / CCT / brightness, capability auto-detected |
| [`switch`](ui/switch/README.md) | ✅ | ✅ | — | Works with any toggleable HA entity |
| [`sensor`](ui/sensor/README.md) | ✅ | ✅ | — | Configurable unit and decimal precision |
| [`binary_sensor`](ui/binary_sensor/README.md) | ✅ | ✅ | — | Read-only — door, motion, leak |
| [`text_sensor`](ui/text_sensor/README.md) | ✅ | ✅ | — | Display any string state or attribute |
| [`button`](ui/button/README.md) | ✅ | ✅ | — | Momentary press — works with `script.*`, `scene.*` too |
| [`climate`](ui/climate/README.md) | ✅ | ✅ | ✅ | Arc setpoint, mode + fan + swing dropdowns, capability auto-detected |
| `cover` | 🔜 | 🔜 | 🔜 | Blinds, shutters, garage doors |
| `fan` | 🔜 | 🔜 | 🔜 | — |
| `number` | 🔜 | 🔜 | 🔜 | Setpoints, PID targets |
| `select` | 🔜 | 🔜 | 🔜 | Operating modes, option lists |
| `media_player` | 🔜 | 🔜 | 🔜 | — |
| `lock` | 🔜 | 🔜 | 🔜 | With PIN pad detail page |

Click any type name in the table above for its full variable reference and usage examples.

---

## Common variables (all entity types)

| Variable | Required | Description |
|---|---|---|
| `uid` | ✅ | Unique identifier — must be unique across your entire config |
| `entity_id` | ✅ | ESPHome component ID (local) or HA entity e.g. `"light.foo"` (remote) |
| `row` | ✅ | Grid row (0-based) |
| `column` | ✅ | Grid column (0-based) |
| `text` | ✅ | Tile label |
| `icon` | ✅ | MDI icon glyph e.g. `$mdi_lightbulb` |
| `row_span` | — | Rows to span (default: `1`) |
| `column_span` | — | Columns to span (default: `1`) |
| `page_id` | — | Parent page ID (default: `main_page`) |

---

## Grid layout

Pages use LVGL's grid layout. `layout: NxM` creates N rows × M columns.

| Layout | Tiles | Good for |
|---|---|---|
| `2x2` | 4 | Small displays |
| `2x3` | 6 | Portrait or compact |
| `3x3` | 9 | 480×480 square displays |
| `4x4` | 16 | Large landscape displays |

Tiles are placed with `row` and `column` (0-based). Use `row_span` / `column_span` to make a tile span multiple cells.

### Multiple pages

Add more pages to the `lvgl.pages` list, include `swipe_navigation.yaml` on each, and set `page_id` on tiles to route them to the right page:

```yaml
lvgl:
  pages:
  - id: main_page
    layout: 3x3
    styles: page_style
    <<: !include esphome-modular-lvgl-buttons/common/swipe_navigation.yaml
  - id: lights_page
    layout: 2x3
    styles: page_style
    <<: !include esphome-modular-lvgl-buttons/common/swipe_navigation.yaml
```

---

## Icons

Icons use [Material Design Icons](https://materialdesignicons.com/) via substitution variables. Usage: `icon: $mdi_lightbulb`.

The icon name must also be listed as a glyph in your device `font:` block — otherwise it will render as a blank square:

```yaml
font:
- file: 'https://github.com/Templarian/MaterialDesign-Webfont/raw/v7.4.47/fonts/materialdesignicons-webfont.ttf'
  id: mdi_icons_40
  size: 40
  bpp: 8
  glyphs:
  - $mdi_lightbulb
  - $mdi_ceiling_light
  - $mdi_thermostat
  # ... add every icon you use
```

Each detail page type also requires specific glyphs — see the type's `README.md`.

---

## Theme

The theme lives in [`common/theme/`](common/theme/README.md) and is a self-contained bundle — one include pulls in colors, fonts, MDI glyph substitutions, and LVGL styles. See the [theme README](common/theme/README.md) for the full color palette, font sizes, and customization reference.

The `common/theme/index.yaml` bundle includes colors, fonts, MDI glyph substitutions, and LVGL styles in one include.

To debug layout, swap to the debug variant which adds red outlines to all widgets:

```yaml
# theme: !include esphome-modular-lvgl-buttons/common/theme/index.yaml
  theme: !include esphome-modular-lvgl-buttons/common/theme/index_debug.yaml
```

Theme appearance is controlled via substitution variables:

| Variable | Default | Description |
|---|---|---|
| `button_on_color` | `ep_orange` | Tile background when active/on |
| `button_off_color` | `very_dark_gray` | Tile background when inactive/off |
| `icon_on_color` | `yellow` | Icon color when active |
| `icon_off_color` | `gray` | Icon color when inactive |
| `label_on_color` | `white` | Label color when active |
| `label_off_color` | `gray` | Label color when inactive |
| `icon_font` | `mdi_icons_40` | Font ID used for icons |
| `text_font` | `nunito_20` | Font ID used for labels |

Available named colors: `ep_orange`, `ep_blue`, `ep_green`, `steel_blue`, `misty_blue`, `very_dark_gray`, `gray800`, `gray900`, and all standard CSS colors.

---

## Desktop development with SDL

Test your UI on macOS or Linux without flashing hardware:

```bash
# macOS
brew install sdl2

# Ubuntu/Debian
sudo apt install libsdl2-dev
```

Use the SDL hardware config instead of a real device:

```yaml
packages:
  hardware: !include esphome-modular-lvgl-buttons/hardware/SDL-lvgl.yaml
  sensors:  !include esphome-modular-lvgl-buttons/common/sensors_base_sdl.yaml
```

Then `esphome run your-config.yaml` — a window opens simulating the display. See `example_code/SDL-lvgl-display_modular_480px.yaml` for a full working SDL config.

---

## Supported hardware

### Waveshare

| Model | Size | Resolution |
|---|---|---|
| `waveshare-esp32-s3-touch-lcd-2.8c` | 2.8" | 320×240 |
| `waveshare-esp32-s3-touch-lcd-4-v4` | 4.0" | 480×480 |
| `waveshare-esp32-s3-touch-lcd-4.3` | 4.3" | 800×480 |
| `waveshare-esp32-s3-touch-lcd-7` | 7.0" | 800×480 |
| `waveshare-esp32-s3-touch-lcd-7B` | 7.0" | 800×480 |
| `waveshare-esp32-p4-wifi6-touch-lcd-4b` | 4.0" | 720×720 |
| `waveshare-esp32-p4-86-panel` | 4.0" | 720×720 |
| `waveshare-esp32-p4-wifi6-touch-lcd-7` | 7.0" | 1024×600 |
| `waveshare-esp32-p4-wifi6-touch-lcd-7b` | 7.0" | 1024×600 |
| `waveshare-esp32-p4-wifi6-touch-lcd-10.1` | 10.1" | 800×1280 |

### Guition

| Model | Size | Resolution |
|---|---|---|
| `guition-esp32-s3-4848s040` | 4.0" | 480×480 |
| `guition-esp32-jc4827w543` | 4.3" | 272×480 |
| `guition-esp32-jc8048w535` | 3.5" | 480×320 |
| `guition-esp32-jc8048w550` | 5.0" | 480×800 |
| `guition-esp32-p4-jc4880p443` | 4.3" | 480×800 |
| `guition-esp32-p4-jc8012p4a1` | 8.0" | 800×1280 |

### Sunton

| Model | Size | Resolution |
|---|---|---|
| `sunton-esp32-2432s028` | 2.8" | 320×240 |
| `sunton-esp32-2432s028R` | 2.8" | 320×240 |
| `sunton-esp32-4827s032R` | 3.2" | 480×320 |
| `sunton-esp32-8048s050` | 5.0" | 480×800 |
| `sunton-esp32-8048s070` | 7.0" | 480×800 |

### Other

| Model | Size | Resolution |
|---|---|---|
| `esp32-s3-box-3` | 2.4" | 320×240 |
| `lilygo-tdisplays3` | 1.9" | 170×320 |
| `elecrow-esp32-7inch` | 7.0" | 800×480 |
| `SDL-lvgl` | variable | Desktop simulation |

---

## Feature modules

Additional UI modules under `ui/` for specific integrations:

| Module | Description |
|---|---|
| `ui/clock/flip_clock.yaml` | Gluqlo-style flip clock widget |
| `ui/weather/today.yaml` | Current weather tile from HA weather entity |
| `ui/weather/forecast.yaml` | 4-day forecast widget via `weather.get_forecasts` |
| `ui/solar/` | Enphase / solar production and consumption monitoring |
| `ui/tides/tide_update.yaml` | NOAA tide clock with gauge display |
| `ui/tides/NOAA_tide_update.yaml` | NOAA API integration for tide data |

See `example_code/advanced/` for full working configs using these modules.

---

## License

MIT — see [LICENSE](LICENSE).
