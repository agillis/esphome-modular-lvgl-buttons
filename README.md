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
- **Weather Display** - 4-day forecast and current conditions from Home Assistant
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
| `ESP32-S3-Touch-LCD-7B` | 7.0" | 800×480 | Capacitive | Variant B, USB-C | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-7.htm) |
| `ESP32-S3-Touch-LCD-4.3` | 4.3" | 800×480 | Capacitive | USB-C | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-7.htm) |
| `ESP32-S3-Touch-LCD-2.8C` | 2.8" | 320×240 | Capacitive | USB-C | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-7.htm) |
| `ESP32-P4-WiFi6-Touch-LCD-7B` | 7.0" | 800×480 | Capacitive | ESP32-P4, WiFi 6, USB-C | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-7.htm) |
| `ESP32-P4-86-Panel` | 4.0" | 480×480 | Capacitive | ESP32-P4 based, 86mm panel form factor | [Waveshare](https://www.waveshare.com/esp32-s3-touch-lcd-7.htm) |

### Elecrow Displays

| Model | Size | Resolution | Touch | Features | Link |
|-------|------|------------|-------|----------|------|
| `CrowPanel DIS05035H` (v2.2) | 3.5" | 480×320 | Resistive | USB-C | [Elecrow ESP32 Display Series](https://www.elecrow.com/esp32-display-series-hmi-touch-screen.html) |
| `Elecrow ESP32 7inch` | 7.0" | 800×480 | Capacitive | USB-C | [Elecrow Displays](https://www.elecrow.com/display.html) |

### Other Devices

| Model | Size | Resolution | Touch | Link |
|-------|------|------------|-------|------|
| `ESP32-S3-Box-3` | 2.4" | 320×240 | Capacitive | [AliExpress search for ESP32 S3 Box 3](https://www.aliexpress.com/wholesale?SearchText=ESP32+S3+Box+3) |
| `LilyGo T-Display-S3` | 1.9" | 170×320 | Capacitive | [AliExpress search for LilyGo T-Display-S3](https://www.aliexpress.com/wholesale?SearchText=LilyGo+T-Display-S3) |
| `SDL Display` | Variable | Variable | Mouse | Local SDL testing environment (desktop) | 
