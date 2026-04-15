import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open(event) {
    event.preventDefault()
    if (this.hasDialogTarget) this.dialogTarget.showModal()
  }

  close() {
    if (this.hasDialogTarget) this.dialogTarget.close()
  }

  backdropClick(event) {
    if (event.target === this.dialogTarget) this.close()
  }
}
