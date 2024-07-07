import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="nav-bar"
export default class extends Controller {
  static targets = ["toggle", "btn"];

  connect() {
    if (window.innerWidth < 768) {
      this.toggleTarget.classList.add("hidden");
    }
  }

  toggle() {
    this.toggleTarget.classList.toggle("hidden");
  }
}
