"""LVGL Screenshot Component - serves a PNG screenshot of the LVGL framebuffer via HTTP."""

import esphome.codegen as cg
import esphome.config_validation as cv
from esphome.const import CONF_ID, CONF_PORT

CODEOWNERS = ["@dcgrove"]
DEPENDENCIES = ["lvgl"]

lvgl_screenshot_ns = cg.esphome_ns.namespace("lvgl_screenshot")
LvglScreenshot = lvgl_screenshot_ns.class_("LvglScreenshot", cg.Component)

CONFIG_SCHEMA = cv.Schema(
    {
        cv.GenerateID(): cv.declare_id(LvglScreenshot),
        cv.Optional(CONF_PORT, default=8080): cv.port,
    }
).extend(cv.COMPONENT_SCHEMA)


async def to_code(config):
    # do_capture_() uses lv_snapshot_take(); LVGL 9 ships it disabled by default.
    cg.add_build_flag("-DLV_USE_SNAPSHOT=1")

    var = cg.new_Pvariable(config[CONF_ID])
    await cg.register_component(var, config)
    cg.add(var.set_port(config[CONF_PORT]))
