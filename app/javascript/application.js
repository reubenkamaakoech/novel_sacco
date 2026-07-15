console.log("START OF APPLICATION");

import "@hotwired/turbo-rails";
import * as bootstrap from "bootstrap";

document.addEventListener("turbo:load", () => {
  console.log("Turbo loaded");

  document.querySelectorAll(".dropdown-toggle").forEach((element) => {
    bootstrap.Dropdown.getOrCreateInstance(element);
  });
});