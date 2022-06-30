import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "hideable" ]

  toggleTargets() {
    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  }
}
