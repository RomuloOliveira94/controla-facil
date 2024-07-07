import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme-switcher"
export default class extends Controller {
  connect() {
    this.element.dataset.theme = "dracula"
  }

  switch(event) {
    const theme = event.target.value
    this.element.dataset.theme = theme
  }
}
