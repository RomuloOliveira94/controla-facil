import { Controller } from "@hotwired/stimulus";
import { MaskInput } from "maska";

// Connects to data-controller="masks"
export default class extends Controller {
  static targets = ["brl"];

  connect() {
    new MaskInput(this.brlTarget, {
      mask: "R$ 0,99",
      tokens: {
        0: { pattern: /[0-9]/, multiple: true },
        9: { pattern: /[0-9]/ },
      },
    });
  }
}
