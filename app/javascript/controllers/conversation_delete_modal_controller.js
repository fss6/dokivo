import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "title", "form"]

  open(event) {
    event.preventDefault()
    event.stopPropagation()
    const btn = event.currentTarget
    const title = btn.dataset.conversationTitle || "esta conversa"
    const url = btn.dataset.deleteUrl
    if (this.hasTitleTarget) this.titleTarget.textContent = title
    if (this.hasFormTarget && url) this.formTarget.action = url
    if (this.hasDialogTarget) this.dialogTarget.showModal()
  }

  close() {
    if (this.hasDialogTarget) this.dialogTarget.close()
  }

  backdropClick(event) {
    if (event.target === this.dialogTarget) this.close()
  }
}
