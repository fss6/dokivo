import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "hidden"]

  connect() {
    this._syncDisplayFromHidden()
  }

  onFocus() {
    const amount = this._parseCurrency(this.displayTarget.value)
    if (amount === null) return
    this.displayTarget.value = this._toEditable(amount)
  }

  onInput() {
    const amount = this._parseCurrency(this.displayTarget.value)
    if (amount === null) {
      this.hiddenTarget.value = ""
      return
    }
    this.hiddenTarget.value = amount.toFixed(2)
  }

  onBlur() {
    const amount = this._parseCurrency(this.displayTarget.value)
    if (amount === null) {
      this.displayTarget.value = ""
      this.hiddenTarget.value = ""
      return
    }
    this.hiddenTarget.value = amount.toFixed(2)
    this.displayTarget.value = this._toCurrency(amount)
  }

  _syncDisplayFromHidden() {
    const amount = Number(this.hiddenTarget.value)
    if (Number.isNaN(amount)) return
    this.displayTarget.value = this._toCurrency(amount)
  }

  _parseCurrency(rawValue) {
    if (!rawValue) return null
    const normalized = rawValue
      .toString()
      .trim()
      .replace(/[R$\s]/g, "")
      .replace(/\./g, "")
      .replace(",", ".")
    if (!normalized || normalized === "-" || normalized === "+") return null
    const amount = Number(normalized)
    return Number.isFinite(amount) ? amount : null
  }

  _toCurrency(amount) {
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL"
    }).format(amount)
  }

  _toEditable(amount) {
    return amount.toFixed(2).replace(".", ",")
  }
}
