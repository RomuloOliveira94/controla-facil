import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = [
    "form",
    "datas",
    "description",
    "value",
    "select",
    "formButton",
    "clearButton",
  ];
  static values = {
    showDatas: Boolean,
    showText: Boolean,
    showSelect: Boolean,
  };

  connect() {
    this.timeout = null;
    this.showDatasValue = false;
    this.showTextValue = false;
    this.showSelectValue = false;
  }

  toggleDatas() {
    this.showDatasValue = !this.showDatasValue;

    if (this.showDatasValue) {
      this.show(this.datasTarget);
      this.show(this.formButtonTarget);
      this.show(this.clearButtonTarget);
    } else {
      this.hide(this.datasTarget);
      this.hide(this.formButtonTarget);
      this.hide(this.clearButtonTarget);
    }
  }

  toggleText() {
    this.showTextValue = !this.showTextValue;

    if (this.showTextValue) {
      this.show(this.descriptionTarget);
      this.show(this.valueTarget);
      this.show(this.clearButtonTarget);
    } else {
      this.hide(this.descriptionTarget);
      this.hide(this.valueTarget);
      this.hide(this.clearButtonTarget);
    }
  }

  toggleSelect() {
    this.showSelectValue = !this.showSelectValue;

    if (this.showSelectValue) {
      this.show(this.selectTarget);
      this.show(this.clearButtonTarget);
    } else {
      this.hide(this.selectTarget);
      this.hide(this.clearButtonTarget);
    }
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
    }, 500);
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
