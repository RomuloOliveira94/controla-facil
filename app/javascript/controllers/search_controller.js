import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = [
    "form",
    "description",
    "formButton",
    "clearButton",
  ];
  static values = {
    showText: Boolean,
  };

  connect() {
    this.timeout = null;
    this.showTextValue = false;
  }

  toggleText() {
    this.showTextValue = !this.showTextValue;

    if (this.showTextValue) {
      this.show(this.descriptionTarget);
    } else {
      this.hide(this.descriptionTarget);
    }
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
      this.showClearButton();
    }, 500);
  }

  showClearButton() {
    this.show(this.clearButtonTarget);
  }

  show(element) {
    element.classList.remove("hidden");
    element.classList.add("flex");
  }

  hide(element) {
    element.classList.add("hidden");
    element.classList.remove("flex");
  }
}
