import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "zone", "hint", "fileName"]

  connect() {
    this.counter = 0
  }

  dragEnter(event) {
    event.preventDefault()
    event.stopPropagation()
    this.counter++
    this.zoneTarget.classList.add("border-accent", "bg-teal-50/50", "shadow-[0_0_0_3px_rgb(20_184_166/0.12)]")
  }

  dragLeave(event) {
    event.preventDefault()
    event.stopPropagation()
    this.counter--
    if (this.counter <= 0) {
      this.counter = 0
      this.zoneTarget.classList.remove("border-accent", "bg-teal-50/50", "shadow-[0_0_0_3px_rgb(20_184_166/0.12)]")
    }
  }

  dragOver(event) {
    event.preventDefault()
    event.stopPropagation()
  }

  drop(event) {
    event.preventDefault()
    event.stopPropagation()
    this.counter = 0
    this.zoneTarget.classList.remove("border-accent", "bg-teal-50/50", "shadow-[0_0_0_3px_rgb(20_184_166/0.12)]")

    const files = event.dataTransfer?.files
    if (files?.length) this.assignFile(files[0])
  }

  changed() {
    const f = this.inputTarget.files?.[0]
    if (!f) return

    this.showFileName(f.name)
    this.submitForm()
  }

  browse(event) {
    event.preventDefault()
    event.stopPropagation()
    this.inputTarget.click()
  }

  zoneClick(event) {
    if (event.target.closest("button")) return
    this.browse(event)
  }

  assignFile(file) {
    const dt = new DataTransfer()
    dt.items.add(file)
    this.inputTarget.files = dt.files
    this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
  }

  submitForm() {
    const form = this.inputTarget.closest("form")
    if (form) form.requestSubmit()
  }

  showFileName(name) {
    if (this.hasHintTarget) this.hintTarget.classList.add("hidden")
    if (this.hasFileNameTarget) {
      this.fileNameTarget.textContent = name
      this.fileNameTarget.classList.remove("hidden")
    }
  }
}
