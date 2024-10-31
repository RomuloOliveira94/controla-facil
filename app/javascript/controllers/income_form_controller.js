import { Controller } from "@hotwired/stimulus";
import { MaskInput } from "maska";

// Connects to data-controller="income-form"
export default class extends Controller {
  static targets = ["fixedInput", "day", "dayInput"];

  connect() {
    if (this.fixedInputTarget.checked) {
      this.dayTarget.classList.remove("hidden");
      this.dayTarget.classList.add("flex");
    }

    new MaskInput(this.dayInputTarget, {
      mask: "99",
      tokens: {
        9: { pattern: /[0-9]/ },
      },
    });
  }

  toggleDayInput(event) {
    if (event.target.checked) {
      this.dayTarget.classList.remove("hidden");
      this.dayTarget.classList.add("flex");
      this.dayInputTarget.value = "";
    } else {
      this.dayTarget.classList.add("hidden");
      this.dayTarget.classList.remove("flex");
    }
  }
}
