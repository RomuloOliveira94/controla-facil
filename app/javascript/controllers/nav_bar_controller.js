import { Controller } from "@hotwired/stimulus";
import { useWindowResize } from "stimulus-use";

// Connects to data-controller="nav-bar"
export default class extends Controller {
  static targets = ["toggle", "btn", "links", "width", "inputCheck"];

  connect() {
    useWindowResize(this);
    this.activateLink();
  }

  windowResize({ width }) {
    if (width < 768) {
      this.toggleTarget.classList.add("hidden");
      this.inputCheckTarget.checked = false;
      this.linksTargets.forEach((link) => {
        link.classList = "text-gray-500";
      });
    } else {
      this.toggleTarget.classList.remove("hidden");
      this.inputCheckTarget.checked = false;
      this.activateLink();
    }
  }

  toggle() {
    this.toggleTarget.classList.toggle("hidden");
  }

  activateLink() {
    this.linksTargets.forEach((link) => {
      if (link.href === window.location.href) {
        link.classList = "text-primary";
        if (window.innerWidth > 768) {
          link.classList = "text-primary border-b-2 border-primary pb-[30px]";
        }
      } else {
        link.classList = "hover:text-secondary";
      }
    });
  }
}
