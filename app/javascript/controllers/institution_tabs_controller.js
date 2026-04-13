import { Controller } from "@hotwired/stimulus"

// Abas por instituição na página de extratos.
export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.index = 0
    this.render()
  }

  select(event) {
    const i = this.tabTargets.indexOf(event.currentTarget)
    if (i >= 0) {
      this.index = i
      this.render()
    }
  }

  render() {
    this.tabTargets.forEach((tab, i) => {
      const active = i === this.index
      tab.setAttribute("aria-selected", active ? "true" : "false")
      tab.classList.toggle("border-accent", active)
      tab.classList.toggle("border-transparent", !active)
      tab.classList.toggle("font-semibold", active)
      tab.classList.toggle("text-zinc-900", active)
      tab.classList.toggle("text-zinc-500", !active)
    })
    this.panelTargets.forEach((panel, i) => {
      panel.toggleAttribute("hidden", i !== this.index)
    })
  }
}
