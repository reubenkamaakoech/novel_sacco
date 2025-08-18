// app/javascript/application.js
import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"

document.addEventListener("turbo:load", () => {
  document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(el => {
    if (!bootstrap.Dropdown.getInstance(el)) {
      new bootstrap.Dropdown(el)
    }
  });
});
