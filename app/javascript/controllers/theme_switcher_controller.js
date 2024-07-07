import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="theme-switcher"
export default class extends Controller {
  static targets = ["theme"];

  connect() {
  }

  async switch(event) {
    const theme = event.target.value;
    this.element.dataset.theme = theme;

    const saveTheme = await fetch('/configurations/change_theme',
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
        body: JSON.stringify({ theme }),
      }
    );

    if (saveTheme.ok) {
      console.log("Theme saved");
    } else {
      console.error("Failed to save theme");
    }
  }

  teste(){
    console.log(this.themeTarget.value)
    console.log("testando");
  }
}
