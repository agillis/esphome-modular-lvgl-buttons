# Modular Easy Button Screen for ESPHome + LVGL on Cheap Touchscreen Devices

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ESPHome](https://img.shields.io/badge/ESPHome-2024.x-blue)](https://esphome.io)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Integration-41BDF5)](https://www.home-assistant.io/)

A modular library for building beautiful, touch-enabled control panels using ESPHome and LVGL on affordable ESP32 touchscreen devices. Perfect for smart home dashboards, room controllers, lighting control, and information displays.

## ✨ Features

- **Modular Design** - Mix and match components to build your perfect interface
- **Home Assistant Integration** - Seamless control of your smart home devices
- **Multiple Screen Sizes** - Support for displays from 2.8" to 7.0"
- **Pre-built Components** - Ready-to-use buttons, pages, widgets, and sensors
- **Weather Display** - 4-day weather forecast and current conditions from Home Assistant
- **Tide Information** - NOAA tide and buoy data integration
- **Solar Monitoring** - Solar panel monitoring widgets
- **Boot Screen** - Professional loading screen with HA connection status
- **Swipe Navigation** - Navigate between pages with touch gestures
- **Light Controls** - Dimming, color temperature, and RGB color picker support

## 📱 Supported Screens

### Guition Displays

| Model | Size | Resolution | Touch | Features | Link |
|-------|------|------------|-------|----------|------|
| `ESP32-4848S040` | 4.0" | 480×480 | Capacitive | 120V/220V relays, built-in power supply, USB-C | [ESPHome Devices](https://devices.esphome.io/devices/Guition-ESP32-S3-4848S040/) |
| `ESP32-JC8048W550` | 5.0" | 480×800 | Capacitive | 16MB flash, Qwiic (I2C) port, speaker port, USB-C | [AliExpress](https://www.aliexpress.com/item/3256806546911788.html) |
| `ESP32-JC8048W535` | 3.5" | 480×320 | Capacitive | USB-C | [AliExpress](https://www.aliexpress.com/item/3256806546911788.html) |
| `ESP32-jc4827w543C` | 4.3" | 272×480 | Capacitive | Bright IPS display, DAC + AMP, speaker connector, USB-C | [AliExpress](https://www.aliexpress.com/item/3256806543342794.html) |
| `ESP32-P4-JC1060P470` | 4.7" | 1060×600 | Capacitive | ESP32-P4 based, USB-C | [AliExpress](https://www.aliexpress.com/item/1005004952694042.html) |
| `ESP32-P4-JC8012P4A1` | - | 800×1280 | Capacitive | ESP32-P4 based, USB-C | [AliExpress](https://www.aliexpress.com/item/1005004952694042.html) |

### Sunton Displays

| Model | Size | Resolution | Touch | Features | Link |
|-------|------|------------|-------|----------|------|
| `ESP32-8048S043` | 4.3" | 480×272 | Capacitive | USB-C | [AliExpress](https://www.aliexpress.com/item/3256807713569037.html) |
| `ESP32-8048S050` | 5.0" | 480×800 | Capacitive | USB-C | [AliExpress](https://www.aliexpress.com/item/1005004952694042.html) |
| `ESP32-8048S070` | 7.0" | 480×800 | Capacitive | Large display, great for info displays, USB-C | [AliExpress](https://www.aliexpress.com/item/3256807882909237.html) |
| `ESP32-2432S028` | 2.8" | 320×240 | Capacitive | USB-C | [AliExpress](https://www.aliexpress.com/item/1005004952694042.html) |
| `ESP32-2432S028R` | 2.8" | 320×240 | Resistive | USB-C | [AliExpress](https://www.aliexpress.com/item/1005004952694042.html) |
| `ESP32-4827S032R` | 3.2" | 480×320 | Resistive | USB-C | [AliExpress](https://www.aliexpress.com/item/1005004952694042.html) |

### Waveshare Displays

| Model | Size | Resolution | Touch | Features | Link |
|-------|------|------------|-------|----------|------|
| `ESP32-S3-Touch-LCD-7` | 7.0" | 800×480 | Capacitive | USB-C | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-7.htm) |
| `ESP32-S3-Touch-LCD-7B` | 7.0" | 800×480 | Capacitive | Variant B, USB-C | Hardware config included |
| `ESP32-S3-Touch-LCD-4.3` | 4.3" | 800×480 | Capacitive | USB-C | Hardware config included |
| `ESP32-S3-Touch-LCD-2.8C` | 2.8" | 320×240 | Capacitive | USB-C | Hardware config included |
| `ESP32-P4-WiFi6-Touch-LCD-7B` | 7.0" | 800×480 | Capacitive | ESP32-P4, WiFi 6, USB-C | Hardware config included |
| `ESP32-P4-86-Panel` | 4.0" | 480×480 | Capacitive | ESP32-P4 based, 86mm panel form factor | Hardware config included |

### Elecrow Displays

| Model | Size | Resolution | Touch | Features | Link |
|-------|------|------------|-------|----------|------|
| `CrowPanel DIS05035H` (v2.2) | 3.5" | 480×320 | Resistive | USB-C | [Elecrow ESP32 Display Series](https://www.elecrow.com/esp32-display-series-hmi-touch-screen.html) |
| `Elecrow ESP32 7inch` | 7.0" | 800×480 | Capacitive | USB-C | [Elecrow Displays](https://www.elecrow.com/display.html) |

### Other Devices

| Model | Size | Resolution | Touch | Link |
|-------|------|------------|-------|------|
| `ESP32-S3-Box-3` | 2.4" | 320×240 | Capacitive | [AliExpress search for ESP32 S3 Box 3](https://www.espressif.com/en/dev-board/esp32-s3-box-3-en) |
| `LilyGo T-Display-S3` | 1.9" | 170×320 | Capacitive | [Espressit](https://www.espressif.com/en/dev-board/esp32-s3-box-3-en) |
| `SDL Display` | Variable | Variable | Mouse | Local SDL testing environment (desktop) |

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
| `light_color.yaml` | Advanced light control with color/temperature modes |
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

### Other Modules

| Directory | Description |
|-----------|-------------|
| `tides/` | NOAA tides and currents display |
| `solar/` | Solar panel monitoring widgets |
| `common/` | Shared configuration and styles |
| `assets/` | Images, icons, and fonts |

## 🚀 Quick Start

### Prerequisites

ESPHome with SVG support (for vector graphics):

```bash
pip install esphome cairosvg
```

### Installation

1. Clone this repository into your ESPHome configuration directory:

```bash
git clone https://github.com/agillis/esphome-modular-lvgl-buttons.git
```

2. Copy an example configuration for your display:

```bash
cp esphome-modular-lvgl-buttons/example_code/guition-esp32-s3-4848s040-display_modular.yaml .
```

3. Edit the configuration file to customize your device name and settings.

4. Build and deploy:

```bash
esphome compile guition-esp32-s3-4848s040-display_modular.yaml
esphome run guition-esp32-s3-4848s040-display_modular.yaml --device 192.168.1.100
```

## 🏠 Home Assistant Integration

### Using File Manager Add-on

The [File Manager Add-on](https://github.com/home-assistant/addons/tree/master/configurator) allows you to download and edit code from Git repos directly in Home Assistant.

### Using ESPHome Device Builder

The [ESPHome Device Builder Add-on](https://esphome.io/guides/getting_started_hassio/) lets you build and install ESPHome configurations onto your devices.

## 🖥️ Desktop Development with SDL

The SDL display platform allows you to develop and test your UI on a desktop system running Linux or MacOS. This is much faster than flashing to hardware for every change.

```yaml
packages:
  hardware: !include esphome-modular-lvgl-buttons/hardware/SDL-lvgl.yaml
```

## 📁 Project Structure

```
esphome-modular-lvgl-buttons/
├── README.md                 # This file
├── LICENSE                   # MIT License
├── secrets.yaml              # Template for secrets
├── assets/                   # Images, icons, and fonts
├── buttons/                  # Reusable button components
├── common/                   # Shared configuration
├── custom_components/        # Home Assistant custom components
├── example_code/             # Basic example configurations
├── example_code_advanced/    # Advanced example configurations
├── hardware/                 # Hardware-specific configurations
├── homeassistant_config/     # Home Assistant configuration examples
├── pages/                    # Full-screen page layouts
├── sensors/                  # Sensor configurations
├── solar/                    # Solar monitoring components
├── tides/                    # NOAA tide components
├── weather_homeassistant/    # Weather display components
└── widgets/                  # Reusable UI widgets
```

## 📝 Device-Specific Notes

### Guition ESP32-4848S040 (4.0" Square)

A great compact screen with built-in 120V/240V relays for direct light control. Includes boot screen, automatic backlight dimming at night, and buttons for controlling local and Home Assistant devices.

### Guition ESP32-JC8048W550 (5.0")

One of the best screens available - bright IPS display, 16MB flash, Qwiic (I2C) port, speaker port, and low cost.

### Guition ESP32-jc4827w543C (4.3")

Excellent screen with very bright IPS display at ~$20 USD. Note: Only 4MB flash (2MB usable in ESPHome), so code size is limited. Has DAC + AMP for audio but fitting audio code in 2MB is challenging.

### Sunton ESP32-8048S070 (7.0")

The largest and highest resolution affordable screen. Excellent touch screen and good dimming ability - ideal for information displays.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License
