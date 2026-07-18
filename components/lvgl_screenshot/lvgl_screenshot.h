#pragma once

#include "esphome/core/component.h"
#include "esphome/core/log.h"
#include "lvgl.h"

#ifdef USE_ESP_IDF
#include "esp_http_server.h"
#include "freertos/FreeRTOS.h"
#include "freertos/semphr.h"
#endif

#ifdef USE_HOST
#include <pthread.h>
#include <atomic>
#endif

namespace esphome {
namespace lvgl_screenshot {

class LvglScreenshot : public Component {
 public:
  void setup() override;
  void loop() override;
  float get_setup_priority() const override { return setup_priority::LATE; }
  void set_port(uint16_t port) { this->port_ = port; }

 protected:
  uint16_t port_{8080};

  // Intermediate RGB888 buffer
  uint8_t *rgb_buf_{nullptr};

  // PNG output buffer
  uint8_t *png_buf_{nullptr};
  size_t png_capacity_{0};
  size_t png_size_{0};

  // True while a capture is in flight (guards against concurrent requests)
  volatile bool in_progress_{false};

  void start_server_();
  void do_capture_();

  static void png_write_cb_(void *ctx, void *data, int size);
  static LvglScreenshot *instance_;

#ifdef USE_ESP_IDF
  httpd_handle_t server_{nullptr};
  SemaphoreHandle_t capture_requested_{nullptr};
  SemaphoreHandle_t capture_done_{nullptr};
  static esp_err_t handle_screenshot_(httpd_req_t *req);
#endif

#ifdef USE_HOST
  int server_fd_{-1};
  pthread_t server_thread_{};
  pthread_mutex_t capture_mutex_;
  pthread_cond_t capture_request_cond_;
  pthread_cond_t capture_done_cond_;
  std::atomic<bool> capture_requested_{false};
  std::atomic<bool> capture_done_{false};
  std::atomic<bool> server_running_{false};

  static void *server_thread_func_(void *arg);
  void handle_client_(int client_fd);
#endif
};

}  // namespace lvgl_screenshot
}  // namespace esphome
