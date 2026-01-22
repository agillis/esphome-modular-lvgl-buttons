# ESP32 Touchscreen Display Hardware Reference
# For Contributing to ESPHome
#
# This document consolidates hardware configurations from this repository
# for reference when contributing to the ESPHome project.

## Display Overview

This repository supports 20+ ESP32 touchscreen displays with LVGL. Below are
the key hardware configurations that could be contributed to ESPHome's board
definitions or documentation.

## Pin Mapping Reference

### Guition ESP32-S3-4848S040 (480×480)
**MCU:** ESP32-S3
**Flash:** 16MB
**Display:** ST7701S (RGB interface)
**Touch:** GT911 (I2C)

```yaml
# Display Pins (RGB interface)
de_pin: GPIO18
hsync_pin: GPIO16
vsync_pin: GPIO17
pclk_pin: GPIO21
cs_pin: GPIO39

# SPI for display commands
spi_clk: GPIO48
spi_mosi: GPIO47

# RGB Data Pins
data_pins:
  red: [11, 12, 13, 14, 0]
  green: [8, 20, 3, 46, 9, 10]
  blue: [4, 5, 6, 7, 15]

# Touch Controller (I2C)
i2c_sda: GPIO19
i2c_scl: GPIO45

# Backlight
backlight_pin: GPIO38

# Built-in Relays
relay_1: GPIO40
relay_2: GPIO02
relay_3: GPIO01
```

### Guition ESP32-JC8048W550 (480×800)
**MCU:** ESP32-S3
**Flash:** 16MB
**Display:** ST7701S
**Touch:** GT911

```yaml
# Display timing
dimensions:
  width: 480
  height: 800
pclk_frequency: 16MHz

# Touch
i2c_sda: GPIO19
i2c_scl: GPIO45

# Backlight
backlight_pin: GPIO38
```

### Sunton ESP32-8048S070 (480×800, 7.0")
**MCU:** ESP32-S3
**Flash:** 16MB
**Display:** ST7701S / RGB
**Touch:** GT911

```yaml
# Display
de_pin: GPIO18
hsync_pin: GPIO16
vsync_pin: GPIO17
pclk_pin: GPIO21
pclk_frequency: 16MHz

# Touch
i2c_sda: GPIO19
i2c_scl: GPIO45

# Backlight
backlight_pin: GPIO38
```

### Waveshare ESP32-S3-Touch-LCD-7 (800×480, 7.0")
**MCU:** ESP32-S3
**Flash:** 16MB
**Display:** ST7789V (RGB interface)
**Touch:** GT911

```yaml
# Higher resolution display
dimensions:
  width: 800
  height: 480

# Touch (I2C)
i2c_sda: GPIO19
i2c_scl: GPIO45

# Backlight
backlight_pin: GPIO1
```

### Waveshare ESP32-P4 Displays
**MCU:** ESP32-P4 (newer chipset)
**Features:** WiFi 6, more GPIO, better performance

Note: ESP32-P4 requires special framework configuration:
```yaml
esp32:
  variant: esp32p4
  framework:
    type: esp-idf
```

### Sunton ESP32-2432S028 "Cheap Yellow Display" (320×240)
**MCU:** ESP32 (classic)
**Display:** ILI9341 (SPI)
**Touch:** XPT2046 (SPI)

```yaml
# SPI Display
display_spi:
  clk_pin: GPIO18
  mosi_pin: GPIO23
  miso_pin: GPIO19

display:
  cs_pin: GPIO15
  dc_pin: GPIO2
  reset_pin: GPIO4

# Touch (separate SPI)
touch:
  cs_pin: GPIO5
  irq_pin: GPIO36

# Backlight
backlight_pin: GPIO21
```

## Common Display Driver Types

### 1. RGB Interface (Parallel) - High Resolution
Used by: ST7701S, ST7789V
- Requires 16-24 data pins
- Higher resolution possible (800×480+)
- More GPIO usage
- Better performance
- Examples: 7" displays, 4.8" displays

### 2. SPI Interface - Lower Resolution
Used by: ILI9341, ILI9488
- Requires 4-5 pins (MOSI, MISO, CLK, CS, DC)
- Lower resolution (320×240 typical)
- Less GPIO usage
- Slower refresh
- Examples: 2.8" displays, 3.2" displays

## Touch Controller Types

### GT911 (Capacitive) - Most Common
- I2C interface (2 pins: SDA, SCL)
- Multi-touch support
- Interrupt pin optional
- Most reliable
- Used in: Most modern displays

### FT5x06 Series (Capacitive)
- I2C interface
- Similar to GT911
- Used in: Some Waveshare displays

### XPT2046 (Resistive)
- SPI interface
- Single touch
- Lower cost
- Used in: Budget displays, "Cheap Yellow Display"

## Display Timing Configurations

Critical parameters for RGB displays:

### 480×480 Displays
```yaml
pclk_frequency: 12MHz - 16MHz
hsync_pulse_width: 8
hsync_front_porch: 10
hsync_back_porch: 20
vsync_pulse_width: 8
vsync_front_porch: 10
vsync_back_porch: 10
```

### 480×800 Displays
```yaml
pclk_frequency: 16MHz
hsync_pulse_width: 10
hsync_front_porch: 40
hsync_back_porch: 40
vsync_pulse_width: 4
vsync_front_porch: 16
vsync_back_porch: 14
```

### 800×480 Displays
```yaml
pclk_frequency: 14MHz - 16MHz
hsync_pulse_width: 30
hsync_front_porch: 210
hsync_back_porch: 46
vsync_pulse_width: 13
vsync_front_porch: 22
vsync_back_porch: 23
```

## PSRAM Configuration

Most ESP32-S3 displays with large screens require PSRAM:

```yaml
psram:
  mode: octal      # ESP32-S3
  speed: 80MHz     # or 40MHz for stability

esp32:
  framework:
    type: esp-idf
    advanced:
      execute_from_psram: true  # Required for LVGL
```

## LVGL Buffer Configuration

Recommended buffer sizes based on resolution:

- **320×240**: 10-15% of screen
- **480×320**: 15-20% of screen
- **480×480**: 20-25% of screen
- **480×800**: 25% of screen
- **800×480**: 25% of screen

```yaml
lvgl:
  buffer_size: 25%  # Adjust based on display size
  color_depth: 16   # RGB565
```

## Framework Considerations

### ESP-IDF (Recommended for LVGL)
```yaml
esp32:
  framework:
    type: esp-idf
```

Advantages:
- Better LVGL support
- PSRAM support
- Better performance
- Required for ESP32-P4

### Arduino (Limited)
```yaml
esp32:
  framework:
    type: arduino
```

Limitations:
- Limited PSRAM support
- Slower LVGL performance
- Not recommended for large displays

## Contributing These Configurations

### To ESPHome Core (esphome/esphome)

1. **Board Definitions** (`esphome/components/esp32/boards.py`):
```python
"guition_esp32_4848s040": {
    "name": "Guition ESP32-S3-4848S040",
    "variant": "esp32s3",
    # Pin definitions...
},
```

2. **Example Configurations** (`esphome/components/lvgl/examples/`):
- Create well-commented YAML examples
- Show common patterns
- Include multiple display sizes

3. **Documentation** (esphome-docs repository):
- Hardware setup guides
- Pin mapping tables
- Troubleshooting tips

### To ESPHome Docs (esphome/esphome-docs)

Create documentation pages:
- `components/lvgl/hardware-guide.rst`
- `devices/esp32-touchscreen-displays.rst`
- Include this pin reference information

## Hardware Purchase Links

Document reliable sources:
- AliExpress store links
- Official distributor links
- Approximate pricing
- Shipping times

## Testing Checklist

Before contributing, verify:
- [ ] Display initializes correctly
- [ ] Touch responds accurately
- [ ] Backlight controls work
- [ ] LVGL renders properly
- [ ] No visual artifacts
- [ ] Stable for 24+ hours
- [ ] WiFi works reliably
- [ ] OTA updates function

## Known Issues and Workarounds

### Issue: Display Flicker
Solution: Adjust pclk_frequency down

### Issue: Touch Inaccuracy
Solution: Add transform/calibration:
```yaml
touchscreen:
  transform:
    swap_xy: false
    mirror_x: false
    mirror_y: false
```

### Issue: Out of Memory
Solution: Reduce LVGL buffer size or enable PSRAM

### Issue: Slow Rendering
Solution: Use ESP-IDF framework, enable PSRAM, optimize widgets

## Useful Resources

- **ESPHome LVGL Docs**: https://esphome.io/components/lvgl.html
- **LVGL Docs**: https://docs.lvgl.io/
- **ESP32-S3 Datasheet**: Espressif official documentation
- **Display Driver Datasheets**: Manufacturer websites

## License Note

All configurations in this repository are MIT licensed and can be freely
contributed to the ESPHome project (also MIT licensed).
