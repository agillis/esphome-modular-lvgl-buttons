# Local ESPHome patches

> **2026-10-22 — the `mipi-dsi-swreset-120ms` patch is NOT the fix for the
> 10.1-DSI-TOUCH-A boot loop, and neither was the YAML `- delay 120ms` workaround.**
> The real cause is the missing **I2C 0x45 register 0x95 panel enable**: Waveshare do it
> inside `esp_lcd_new_panel_jd9365()` before any DSI traffic, and ESPHome only ever writes
> `0x96` (brightness). Without it the panel never drives its side of the link and the DSI
> generic command FIFO wedges after ~19 commands. Fixed in
> `hardware/waveshare-esp32-p4-module-dev-kit-10.1-DSI-TOUCH-A.yaml` with an `on_boot`
> priority-900 lambda; **stock ESPHome needs no patch at all**. See the DSI section of
> `CLAUDE.md` for the full evidence and the list of measured dead ends.

Patches against the installed ESPHome package that this library's hardware files
depend on. They are **not** applied automatically — see "Applying" below.

---

## `esphome-2026.9.1-mipi-dsi-swreset-120ms.patch`

**Symptom.** A MIPI-DSI panel with **no LCD reset GPIO** boots to a permanently blank
screen. The serial log shows the display never finishing setup, then a task watchdog
abort roughly 30 s later, repeating until ESPHome's boot-loop detector gives up and
enters safe mode (which runs logger/WiFi/OTA but no display — so the blank panel is a
*symptom*, not the fault):

```
[C][display.mipi_dsi:024]: Running Setup
E (39871) task_wdt: Task watchdog got triggered ... loopTask (CPU 1)
E (39871) task_wdt: Aborting.
MEPC : 0x480f8362
...
[C][safe_mode:201]: Unsuccessful boot attempts: 10
[E][safe_mode:213]: Boot loop detected
```

Decoding that PC points at a busy-wait, not any ESPHome code:

```
0x480f8362: mipi_dsi_host_ll_gen_is_cmd_fifo_full  (mipi_dsi_host_ll.h)
            inlined by mipi_dsi_hal_host_gen_write_dcs_command
0x48064652: panel_io_dbi_tx_param                  (esp_lcd_panel_io_dbi.c)
```

**Cause.** `mipi_dsi.cpp` performs the panel reset and then starts sending the init
sequence with no settling time. When no `reset_pin` is configured it issues a DCS
software reset (`SWRESET`, 0x01) and proceeds immediately; the only 120 ms guard in the
code is applied to `SLPOUT`, which comes at the *end* of the sequence. The JD9365
requires a full 120 ms after reset before it accepts **any** command, so the entire
page-programming sequence is sent into the panel's reset window and ignored. The DSI
generic command FIFO then never drains and `tx_param` spins until the watchdog fires.

The vendor driver does exactly what ESPHome omits — both reset paths end with a 120 ms
wait (`esp_lcd_jd9365.c`, `panel_jd9365_reset()`):

```c
else if (io)
{ // Perform software reset
    esp_lcd_panel_io_tx_param(io, LCD_CMD_SWRESET, NULL, 0);
    vTaskDelay(pdMS_TO_TICKS(120));
}
```

Because it is a timing race against the panel's reset, the failure is **intermittent** —
the same firmware image can boot fine one day and loop the next.

**Fix.** Add `delay(120)` after the reset, before the init sequence.

> **This patch is NOT required to use this library.** The affected hardware file
> now carries a self-contained YAML workaround: it declares `model: CUSTOM` and
> supplies the JD9365 init sequence with a leading `- delay 120ms`, which lands
> immediately after the software reset. A YAML `init_sequence:` on a *named* model
> is appended *after* the model's own sequence, which is too late to help — hence
> `CUSTOM`. The patch remains here as the upstream-shaped fix and as the
> explanation of the root cause; applying it additionally is harmless but
> redundant. Once ESPHome waits 120 ms itself, revert the hardware file to
> `model: WAVESHARE-10.1-DSI-TOUCH-A` and drop the inlined sequence.

Also included: `vsync_back_porch` 12 -> 10 for the JD9365 800x1280 model, matching the
vendor's `JD9365_800_1280_PANEL_60HZ_DPI_CONFIG`. Cosmetic timing only; not the hang.

**Affected boards in this library.** Any `mipi_dsi` panel with no reset GPIO. Confirmed
on `hardware/waveshare-esp32-p4-module-dev-kit-10.1-DSI-TOUCH-A.yaml`
(`BSP_LCD_RST = GPIO_NUM_NC` — the panel self-resets, so there is no pin to drive).
Boards that *do* route a reset pin take the GPIO path, which also lacks the delay but
tends to survive it.

**Verified.** ESPHome 2026.9.1, ESP32-P4 rev v1.3, 10.1-DSI-TOUCH-A. Before: watchdog
abort every ~40 s, safe mode, blank panel. After:

```
[C][display.mipi_dsi:181]: MIPI DSI setup complete
[C][component:164]: Setup display took 2847ms
[I][app:117]: setup() finished successfully!
```

Zero reboots and zero watchdog aborts over several minutes; native API on :6053 open
(it does not run in safe mode).

A good way to prove the panel itself is healthy before suspecting software is the
vendor's `13_Displaycolorbar` example (project `test_esp_lcd_jd9365`) from
`waveshareteam/ESP32-P4-Platform`, which drives the DSI hardware pattern generator.
On pre-rev3 silicon build it with
`SDKCONFIG_DEFAULTS="sdkconfig.defaults;<repo>/config/esp32p4_rev1_3.defaults"` — the
prebuilt factory firmware is rev3.x-only and panics with `Illegal instruction` on v1.x.

### Applying

```sh
ESPHOME=$(python3 -c 'import esphome, pathlib; print(pathlib.Path(esphome.__file__).parent.parent)')
patch -d "$ESPHOME" -p1 --dry-run < patches/esphome-2026.9.1-mipi-dsi-swreset-120ms.patch
patch -d "$ESPHOME" -p1          < patches/esphome-2026.9.1-mipi-dsi-swreset-120ms.patch
```

`pip install -U esphome` silently reverts this. Re-apply after upgrading, and drop it
once the fix is upstream.
