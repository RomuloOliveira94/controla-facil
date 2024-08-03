import { Controller } from "@hotwired/stimulus";
import { MaskInput } from "maska";

// Connects to data-controller="masks"
export default class extends Controller {
  static targets = ["money", "brl"];

  connect() {
    if (this.hasBrlTarget) {
      this.loadBrl();
    }

    if (this.hasMoneyTarget) {
      this.loadMoney();
    }
  }

  loadBrl() {
    new MaskInput(this.brlTarget, {
      mask: "R$ 0,99",
      tokens: {
        0: { pattern: /[0-9]/, multiple: true },
        9: { pattern: /[0-9]/ },
      },
    });
  }

  loadMoney() {
    new MaskInput(this.moneyTarget, {
      mask: "0,99",
      tokens: {
        0: { pattern: /[0-9]/, multiple: true },
        9: { pattern: /[0-9]/ },
      },
    });
  }
}
