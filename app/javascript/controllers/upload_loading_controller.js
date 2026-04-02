import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  show() {
    if (!this.hasOverlayTarget) return
    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("flex")
  }

  hide() {
    if (!this.hasOverlayTarget) return
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("flex")
  }
}

