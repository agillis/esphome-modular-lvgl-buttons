# Modular Easy Button Screen for ESPHome + LVGL on Cheap Touchscreen Devices

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ESPHome](https://img.shields.io/badge/ESPHome-2025.x-blue)](https://esphome.io)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Integration-41BDF5)](https://www.home-assistant.io/)

A modular library for building beautiful, touch-enabled control panels using ESPHome and LVGL on ESP32 based touchscreen devices. Perfect for smart home dashboards, room controllers, lighting control, and information displays.

## ✨ Features

- **Modular Design** - Mix and match components to build your perfect interface
- **Home Assistant Integration** - Seamless control of your smart home devices
- **Multiple Screen Sizes** - Support for displays from 2.8" to 10"
- **Pre-built Components** - Ready-to-use buttons, pages, widgets, and sensors
- **Weather Display** - 4-day forecast and current conditions from Home Assistant or direct from Pirate Weather
- **Tide Information** - NOAA tide integration
- **Solar Monitoring** - Solar panel monitoring widgets
- **Boot Screen** - Professional loading screen with HA connection status
- **Swipe Navigation** - Navigate between pages with touch gestures
- **Light Controls** - Dimming, color temperature, and RGB color picker support

## 📱 Supported Screens

### Guition Displays

| Model | Size | Resolution | Flash | Touch | Features | Link |
|-------|------|------------|-------|-------|----------|------|
| `ESP32-4848S040` | 4.0" | 480×480 | 16MB | Capacitive | 120V/220V relays, built-in 120V/220V power supply | [AliExpress](https://www.aliexpress.com/item/3256806436431838.html) |
| `ESP32-JC8048W550` | 5.0" | 480×800 | 16MB | Capacitive | Qwiic (I2C) port, speaker | [AliExpress](https://www.aliexpress.com/item/3256806546911788.html) |
| `ESP32-JC8048W535` | 3.5" | 480×320 | 16MB | Capacitive | USB-C | [AliExpress](https://www.aliexpress.com/item/3256806546911788.html) |
| `ESP32-jc4827w543C` | 4.3" | 272×480 | 4MB | Capacitive | speaker, 4MB flash keep you code small| [AliExpress](https://www.aliexpress.com/item/3256806543342794.html) |
| `ESP32-P4-JC4880P443` | 4.3" | 480×800 | 16MB | Capacitive | ESP32-P4 based, speaker, mic, USB-C | [AliExpress](https://www.aliexpress.com/item/3256809431944589.html) |
| `ESP32-P4-JC1060P470` | 4.7" | 1060×600 | 16MB | Capacitive | ESP32-P4 based, USB-C | [AliExpress](https://www.aliexpress.com/item/3256808075855498.html) |
| `ESP32-P4-JC8012P4A1` | 8.0" | 800×1280 | 16MB | Capacitive | ESP32-P4 based, USB-C | [AliExpress](https://www.aliexpress.com/item/3256808075855498.html) |

### Sunton Displays

| Model | Size | Resolution | Flash | Touch | Features | Link |
|-------|------|------------|-------|-------|----------|------|
| `ESP32-8048S043` | 4.3" | 480×272 | 16MB | Capacitive | USB-C | [AliExpress](https://www.aliexpress.com/item/3256807713569037.html) |
| `ESP32-8048S050` | 5.0" | 480×800 | 16MB | Capacitive | USB-C | [AliExpress](https://www.aliexpress.com/item/1005004952694042.html) |
| `ESP32-8048S070` | 7.0" | 480×800 | 16MB | Capacitive | Large display, great for info displays, USB-C | [AliExpress](https://www.aliexpress.com/item/3256807882909237.html) |
| `ESP32-2432S028` | 2.8" | 320×240 | 4MB | Capacitive | Micro USB, popular "Cheap Yellow Display" | [AliExpress](https://www.aliexpress.com/item/3256805607954786.html) |
| `ESP32-2432S028R` | 2.8" | 320×240 | 4MB | Resistive | Micro USB, resistive touch variant | [AliExpress](https://www.aliexpress.com/item/3256805607954786.html) |
| `ESP32-4827S032R` | 3.2" | 480×320 | 16MB | Resistive | USB-C | [AliExpress](https://www.aliexpress.com/item/3256806197292489.html) |

### Waveshare Displays

| Model | Size | Resolution | Flash | Touch | Features | Link |
|-------|------|------------|-------|-------|----------|------|
| `ESP32-S3-Touch-LCD-7` | 7.0" | 800×480 | 16MB | Capacitive | USB-C | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-7.htm) |
| `ESP32-S3-Touch-LCD-7B` | 7.0" | 800×480 | 16MB | Capacitive | Variant B with different touch IC, USB-C | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-7b.htm) |
| `ESP32-S3-Touch-LCD-4.3` | 4.3" | 800×480 | 16MB | Capacitive | USB-C | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-4.3.htm) |
| `ESP32-S3-Touch-LCD-2.8C` | 2.8" | 320×240 | 16MB | Capacitive | USB-C, compact form factor | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-2.8.htm) |
| `ESP32-S3-Touch-LCD-3.5B` | 3.5" | 320×480 | 8MB | Capacitive | USB-C | [Waveshare](https://www.waveshare.com/wiki/ESP32-S3-Touch-LCD-3.5B) |
| `ESP32-P4-WiFi6-Touch-LCD-7B` | 7.0" | 1024×600 | 32MB | Capacitive | speaker, mic, USB-C | [Waveshare](https://www.waveshare.com/esp32-p4-touch-lcd-7b.htm) |
| `ESP32-P4-WiFi6-Touch-LCD-10.1` | 10.1" | 800×1280 | 32MB | Capacitive |  speaker, mic, USB-C | [Waveshare](https://www.waveshare.com/esp32-p4-wifi6-touch-lcd-10.1.htm) |
| `ESP32-P4-86-Panel` | 4.0" | 480×480 | 32MB | Capacitive | speaker, mic, 86mm panel form factor | [Waveshare](https://www.waveshare.com/esp32-p4-nano.htm) |

### Elecrow Displays

| Model | Size | Resolution | Flash | Touch | Features | Link |
|-------|------|------------|-------|-------|----------|------|
| `CrowPanel DIS05035H` (v2.2) | 3.5" | 480×320 | 4MB | Resistive | USB-C | [Elecrow](https://www.elecrow.com/esp32-display-3-5-inch-hmi-display-spi-tft-lcd-touch-screen.html) |
| `Elecrow ESP32 7inch` | 7.0" | 800×480 | 16MB | Capacitive | USB-C, wide viewing angle | [Elecrow](https://www.elecrow.com/esp32-display-7-inch-hmi-display-rgb-tft-lcd-touch-screen-support-lvgl.html) |

### Other Devices

| Model | Size | Resolution | Flash | Touch | Features | Link |
|-------|------|------------|-------|-------|----------|------|
| `ESP32-S3-Box-3` | 2.4" | 320×240 | 16MB | Capacitive | Espressif official dev kit with case | [Espressif](https://www.espressif.com/en/products/devkits/esp-box/overview) |
| `LilyGo T-Display-S3` | 1.9" | 170×320 | 16MB | Capacitive | Compact form factor | [LilyGo](https://www.lilygo.cc/products/t-display-s3) |
| `SDL Display` | Variable | Variable | N/A | Mouse | Desktop testing on Linux/MacOS | N/A |

## 🧩 Available Components

### Buttons (`buttons/`)

| Component | Description |
|-----------|-------------|
| `switch_button.yaml` | Toggle switches and lights with on/off state |
| `dimmer_light_button.yaml` | Light control with brightness slider |
| `scene_button.yaml` | Trigger Home Assistant scenes |
| `page_button.yaml` | Navigate between LVGL pages |
| `time_button.yaml` | Display current time with page navigation |
| `local_relay_button.yaml` | Control local GPIO relays |
| `color_picker.yaml` | RGB color selection for lights |

### Pages (`pages/`)

| Component | Description |
|-----------|-------------|
| `info.yaml` | System information screen (ESPHome version, IP, MAC, WiFi) |
| `light_color.yaml` | Advanced light control with color wheel, brightness, saturation, and color temperature modes |
| `loading_480px.yaml` | Boot screen with Home Assistant connection status |

### Widgets (`widgets/`)

| Component | Description |
|-----------|-------------|
| `swipe_navigation.yaml` | Enable swipe gestures for page navigation |

### Sensors (`sensors/`)

| Component | Description |
|-----------|-------------|
| `sensors_base.yaml` | Core sensors (WiFi, CPU temp, device info) |
| `sensors_base-SDL.yaml` | Simplified sensors for SDL desktop testing |

### Weather (`weather_homeassistant/`)

| Component | Description |
|-----------|-------------|
| `weather_forecast_action.yaml` | 4-day weather forecast display |
| `weather_today.yaml` | Current weather conditions |
| `weather_icons_update.yaml` | Weather icon helper |

### Common (`common/`)

| Component | Description |
|-----------|-------------|
| `backlight_time.yaml` | Automatic backlight dimming based on time of day |
| `color.yaml` | Color definitions and gradients |
| `fonts.yaml` | Font configurations |
| `mdi_glyph_substitutions.yaml` | Material Design Icon glyph mappings |
| `ota.yaml` | Over-the-air update configuration |
| `theme_style.yaml` | LVGL theme and styling definitions |
| `time_homeassistant.yaml` | Time sync via Home Assistant |
| `time_sntp.yaml` | Time sync via NTP servers |
| `wifi.yaml` | WiFi configuration template |

### Other Modules

| Directory | Description |
|-----------|-------------|
| `tides/` | NOAA tides and currents display |
| `solar/` | Solar panel monitoring widgets |
| `assets/` | Images, icons, and fonts |
| `custom_components/` | Custom ESPHome components (NOAA tides) |

## 🚀 Quick Start

### Prerequisites

ESPHome 2025.1 or later with LVGL support:

```bash
pip install esphome
```

For SVG image support (optional):

```bash
pip install cairosvg
```

### Installation

1. Clone this repository into your ESPHome configuration directory:

```bash
git clone https://github.com/agillis/esphome-modular-lvgl-buttons.git
```

2. Copy an example configuration for your display:

```bash
cp esphome-modular-lvgl-buttons/example_code/guition-esp32-s3-4848s040-display_modular.yaml my-display.yaml
```

3. Create a `secrets.yaml` file with your WiFi credentials:

```yaml
wifi_ssid: "Your WiFi SSID"
wifi_password: "Your WiFi Password"
```

4. Edit the configuration file to customize your device name and Home Assistant entities.

5. Build and deploy:

```bash
esphome run my-display.yaml
```

## 🏠 Home Assistant Integration

This project integrates seamlessly with Home Assistant. Once your device is running, it will automatically appear in Home Assistant's ESPHome integration.

### Supported Entity Types

- **Lights** - On/off, brightness, color temperature, RGB color
- **Switches** - Toggle any Home Assistant switch
- **Scenes** - Trigger any Home Assistant scene
- **Sensors** - Display sensor values (weather, temperature, etc.)
- **Climate** - Thermostat control (via scenes or direct integration)

### Using ESPHome Dashboard

The [ESPHome Dashboard Add-on](https://esphome.io/guides/getting_started_hassio/) is the easiest way to manage your ESPHome devices directly from Home Assistant.

### Using File Editor Add-on

The [File Editor Add-on](https://github.com/home-assistant/addons/tree/master/configurator) allows you to edit ESPHome configurations directly in Home Assistant.

## 🖥️ Desktop Development with SDL

The SDL display platform allows you to develop and test your UI on a desktop system running Linux or macOS. This is much faster than flashing to hardware for every change.

### Setup

1. Install SDL2 development libraries:

```bash
# Ubuntu/Debian
sudo apt install libsdl2-dev

# macOS
brew install sdl2
```

2. Use the SDL hardware configuration:

```yaml
packages:
  hardware: !include esphome-modular-lvgl-buttons/hardware/SDL-lvgl.yaml
```

3. Run the configuration:

```bash
esphome run SDL-lvgl-display_modular_480px.yaml
```

A window will open on your desktop simulating the touchscreen display.

## 📁 Project Structure

```
esphome-modular-lvgl-buttons/
├── README.md                 # This file
├── LICENSE                   # MIT License
├── secrets.yaml              # Template for WiFi/API secrets
├── assets/                   # Images, icons, and fonts
│   ├── fonts/                # Custom font files
│   └── images/               # PNG/SVG images for UI
├── buttons/                  # Reusable button components
├── common/                   # Shared configuration (themes, colors, fonts)
├── custom_components/        # Custom ESPHome components
│   └── noaa_tides/           # NOAA tide data integration
├── example_code/             # Basic example configurations
├── example_code_advanced/    # Advanced examples (weather, tides)
├── hardware/                 # Hardware-specific configurations
├── homeassistant_config/     # Home Assistant configuration examples
├── pages/                    # Full-screen page layouts
├── sensors/                  # Sensor configurations
├── solar/                    # Solar monitoring components
├── tides/                    # NOAA tide display components
├── weather_homeassistant/    # Weather display components
└── widgets/                  # Reusable UI widgets (canvas, navigation)
```

## 📝 Device-Specific Notes

### Guition ESP32-4848S040 (4.0" Square)

A great compact screen with built-in 120V/240V relays for direct light control. Includes boot screen, automatic backlight dimming at night, and buttons for controlling local and Home Assistant devices.

**Best for:** Wall-mounted light switches, room controllers

### Guition ESP32-JC8048W550 (5.0")

One of the best screens available - bright IPS display, 16MB flash, Qwiic (I2C) port, speaker port, and excellent value.

**Best for:** General-purpose dashboards, room displays

### Guition ESP32-jc4827w543C (4.3")

Excellent screen with very bright IPS display at ~$20 USD. Note: Only 4MB flash (2MB usable in ESPHome), so code size is limited. Has DAC + AMP for audio.

**Best for:** Simple dashboards, budget-friendly projects

### Sunton ESP32-8048S070 (7.0")

The largest and highest resolution affordable screen. Excellent touch screen and good dimming ability.

**Best for:** Information displays, weather stations, whole-home dashboards

### Waveshare ESP32-S3-Touch-LCD-7 (7.0")

High-quality 7" display from Waveshare with excellent documentation and support.

**Best for:** Professional installations, commercial projects

## 🔧 Troubleshooting

### Common Issues

**Display shows nothing after boot:**
- Check your hardware configuration matches your exact display model
- Verify power supply provides adequate current (most displays need 500mA+)

**Touch not working:**
- Some displays have different touch controller variants (e.g., 7B vs 7)
- Check the hardware YAML for correct I2C address and touch driver

**WiFi connection issues:**
- Ensure `secrets.yaml` has correct credentials
- Check WiFi signal strength at display location

**Compilation errors about missing files:**
- Ensure you cloned the repository into the correct directory
- Check file paths in your configuration

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [ESPHome](https://esphome.io/) - The amazing platform that makes this possible
- [LVGL](https://lvgl.io/) - Light and Versatile Graphics Library
- [Home Assistant](https://www.home-assistant.io/) - The heart of the smart home
- [Material Design Icons](https://materialdesignicons.com/) - Beautiful icon set
