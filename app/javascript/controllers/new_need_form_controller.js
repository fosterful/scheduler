import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "socialWorkerSelectContainer" ]

  handleOfficeChange(event) {
    $(this.socialWorkerSelectContainerTarget).load('/needs/office_social_workers', {
      office_id: event.target.value
    })
  }
}
