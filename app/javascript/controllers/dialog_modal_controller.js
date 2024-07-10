import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dialog-modal"
export default class extends Controller {
  connect() {
    this.open();
  }

  open() {
    this.element.showModal();
  }

  submitEnd(event) {
    if (event.detail.success) {
      this.hideModal();
    }
  }

  hideModal() {
    this.element.close();
  }
}
