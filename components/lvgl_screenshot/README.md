# lvgl_screenshot (vendored)

Serves a PNG of the LVGL framebuffer over HTTP — used for AI-assisted / visual
UI development without flashing hardware.

Vendored from **[agillis/esphome-lvgl-screenshot](https://github.com/agillis/esphome-lvgl-screenshot)**
(MIT, see LICENSE), with the LVGL 9 fix: `do_capture_()` now uses
`lv_snapshot_take()` (the v8 `disp->driver->draw_buf` / RGB565 bitfield API was
removed in LVGL 9), and `LV_USE_SNAPSHOT` is enabled via a build flag. Works on
ESPHome 2026.6+ (LVGL 9.5), host/SDL and ESP-IDF.

## Use

```yaml
external_components:
  - source:
      type: local
      path: esphome-modular-lvgl-buttons/components
    components: [lvgl_screenshot]

lvgl_screenshot:
  port: 8080
```

Then, with the (SDL or on-device) build running:

```bash
curl http://localhost:8080/screenshot > screenshot.png   # host/SDL
curl http://<device-ip>:8080/screenshot > screenshot.png # hardware
```

See [`AI_tools/SDL-lvgl-screenshot.yaml`](../../AI_tools/SDL-lvgl-screenshot.yaml)
for a full desktop harness.
