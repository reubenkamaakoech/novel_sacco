import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"

window.bootstrap = bootstrap

document.addEventListener("turbo:load", () => {
  document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(el => {

    el.addEventListener('click', function (e) {
      e.preventDefault()

      const instance = bootstrap.Dropdown.getOrCreateInstance(el)
      instance.toggle()
    })

  })
})