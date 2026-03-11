# CLAUDE.md — esphome-modular-lvgl-buttons

This is an **ESPHome YAML library** for building LVGL touchscreen UIs on ESP32 devices connected to Home Assistant. Not Python, not JavaScript — pure ESPHome YAML with inline C++ lambdas.

Read ARCHITECTURE.md for the full architecture reference.

## Build / Test

```bash
# Validate all example configs
cd /path/to/parent/directory  # directory containing esphome-modular-lvgl-buttons/
bash esphome-modular-lvgl-buttons/testing/test_configs.sh

# Validate a single config
esphome config example_code/SDL-lvgl-display_modular_480px.yaml
```

## Essential Patterns

- **Always use named colors, never hex values.** Use library colors from `common/color.yaml` (e.g., `ep_orange`, `misty_blue`, `very_dark_gray`, `gray50`-`gray900`) or ESPHome built-in CSS color names (e.g., `coral`, `dodgerblue`, `teal`, `tomato`). Full list in `common/color.yaml`. If you need a new color, define it as a substitution (e.g., `my_teal: "0x1ABC9C"`) and reference as `$my_teal` — never inline hex.
- Every button needs a **unique `uid`** — generates LVGL widget IDs: `button_${uid}`, `icon_${uid}`, `label_${uid}`, `widget_sensor_${uid}`
- Buttons extend pages: `!extend ${page_id | default("main_page")}` — never create standalone pages
- Variables: `${var | default(value)}` syntax
- Colors via substitution vars: `$button_on_color`, `$button_off_color`, `$icon_on_color`, `$icon_off_color`, `$label_on_color`, `$label_off_color`
- Icons from `common/mdi_glyph_substitutions.yaml`: `$mdi_lightbulb`, `$mdi_home`, etc.
- Fonts: `$icon_font` for icons, `$text_font` for labels
- Grid positioning: `grid_cell_row_pos`, `grid_cell_column_pos` (0-based), optional `grid_cell_row_span`/`grid_cell_column_span`
- HA state tracking: `binary_sensor` (on/off) or `text_sensor` (multi-state) from `platform: homeassistant`

## New Button Checklist

1. Create file in `buttons/` with YAML comment header listing `vars:`
2. `lvgl: pages:` using `!extend` → `container` → `button` → labels
3. Add `binary_sensor` or `text_sensor` for HA state tracking
4. Update colors in state handler with `lvgl.widget.update`
5. Test with SDL: add to `example_code/SDL-lvgl-display_modular_480px.yaml`, run `esphome config`

## Key Files

- `buttons/switch_button.yaml` — canonical simple button pattern
- `buttons/cover_button.yaml` — complex multi-state example
- `common/theme_style.yaml` — LVGL theme defaults and Dark/Light switcher
- `common/mdi_glyph_substitutions.yaml` — ~6000 icon substitution mappings
- `common/color.yaml` — ~50 named colors
- `common/fonts.yaml` — Nunito font family (sizes 12-72)
- `hardware/` — one file per supported display device (27+)

## Known Issues

- `shadow_width: 0` must be explicitly set in theme despite LVGL default
