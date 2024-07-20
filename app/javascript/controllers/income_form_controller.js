import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="income-form"
export default class extends Controller {
  static targets = ["fixedInput", "day", "dayInput"];

  connect() {
    if (this.fixedInputTarget.checked) {
      this.dayTarget.classList.remove("hidden");
      this.dayTarget.classList.add("flex");
    }
  }

  toggleDayInput(event) {
    if (event.target.checked) {
      this.dayTarget.classList.remove("hidden");
      this.dayTarget.classList.add("flex");
    } else {
      this.dayTarget.classList.add("hidden");
      this.dayTarget.classList.remove("flex");
    }
  }
}
