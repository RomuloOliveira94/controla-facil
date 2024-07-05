import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav-bar"
export default class extends Controller {
  static targets = [ "toggle", "btn" ]

  connect() {
  }

  toggle() {
    this.toggleTarget.classList.toggle('hidden');
  }
}
