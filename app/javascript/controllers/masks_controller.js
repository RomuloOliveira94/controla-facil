import { Controller } from "@hotwired/stimulus";
import { Mask, MaskInput } from "maska";

// Connects to data-controller="masks"
export default class extends Controller {
  static targets = ["brl", "day"];

  connect() {
    new MaskInput(this.brlTarget, {
      mask: "R$ 0,99",
      tokens: {
        0: { pattern: /[0-9]/, multiple: true },
        9: { pattern: /[0-9]/ },
      },
    });

    new MaskInput(this.dayTarget, {
      mask: "99",
      tokens: {
        9: { pattern: /[0-9]/ },
      },
    });
  }
}
