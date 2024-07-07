import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="nav-bar"
export default class extends Controller {
  static targets = ["toggle", "btn", "links"];

  connect() {
    if (window.innerWidth < 768) {
      this.toggleTarget.classList.add("hidden");
    }

    this.activateLink();
  }

  toggle() {
    this.toggleTarget.classList.toggle("hidden");
  }

  activateLink() {
    this.linksTargets.forEach((link) => {
      if (link.href === window.location.href) {
        link.classList = "text-primary border-b-2 border-primary pb-[18px]";
      } else {
        link.classList = "text-gray-500";
      }
    });
  }
}
