import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["noTextBox", "true"]

  initialize() {
    this.handleRadioClick()
  }

  handleRadioClick() {
    if (this.trueTarget.checked) {
      this.noTextBoxTarget.style.display = "none"
      this.noTextBoxTarget.disabled = true
    } else {
      this.noTextBoxTarget.style.display = "block"
      this.noTextBoxTarget.disabled = false
    }
  }
}