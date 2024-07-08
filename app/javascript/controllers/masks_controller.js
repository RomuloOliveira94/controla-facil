import { Controller } from "@hotwired/stimulus";
import { Mask, MaskInput } from "maska";

// Connects to data-controller="masks"
export default class extends Controller {
  static targets = ["brl"];

  connect() {
    new MaskInput(this.brlTarget, {
      eager: true,
      number: { locale: 'br', fraction: 2}
    })
  }
}
