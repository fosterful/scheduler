import { Controller } from "stimulus"

export default class extends Controller {
  toggleUserListDisplay(event) {
    event.preventDefault()
    $($(event.target).data('listId')).toggleClass('hide')
  }
}
