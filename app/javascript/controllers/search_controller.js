import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["form", "searchToggle"];

  connect() {
    this.timeout = null;
  }

  toggleForm() {
    this.formTarget.classList.toggle("hidden");
    this.searchToggleTarget.classList.toggle("btn-primary");
    this.searchToggleTarget.classList.toggle("btn-default");
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
    }, 500);
  }
}
