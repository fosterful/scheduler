import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "hideableHours", "hideableNeeds" ]

  toggleHoursTargets() {
    this.hideableHoursTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  }

  toggleNeedsTargets() {
    this.hideableNeedsTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  }

  hideHoursTargets() {
    this.hideableHoursTargets.forEach((el) => {
      el.hidden = true
    });
  }

  hideNeedsTargets() {
    this.hideableNeedsTargets.forEach((el) => {
      el.hidden = true
    });
  }
}
