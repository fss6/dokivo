import { Controller } from "@hotwired/stimulus"

// Modal de confirmação reutilizável (ex.: desabilitar usuário, excluir pasta, excluir conversa).
// Gatilho: data-action="click->app-confirm-modal#open" e
// data-app-confirm-modal-url-param / data-app-confirm-modal-item-label-param no botão.
export default class extends Controller {
  static targets = ["dialog", "itemLabel", "form"]

  open(event) {
    event.preventDefault()
    event.stopPropagation()
    const btn = event.currentTarget
    const url = btn.dataset.appConfirmModalUrlParam
    const itemLabel = btn.dataset.appConfirmModalItemLabelParam || "—"
    if (this.hasItemLabelTarget) this.itemLabelTarget.textContent = itemLabel
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
