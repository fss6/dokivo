import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["folder"]
  static values = { documentId: Number, selectedFolderId: Number, dragging: Boolean }

  connect() {
    this.syncFolderSelection()
  }

  selectFolder(event) {
    if (this.draggingValue) return

    const folderEl = event.currentTarget
    const folderId = Number(folderEl.dataset.folderId)
    if (!folderId) return

    this.selectedFolderIdValue = folderId
    this.syncFolderSelection()
  }

  openFolder(event) {
    if (this.draggingValue) return

    const url = event.currentTarget.dataset.folderUrl
    if (!url) return

    window.location = url
  }

  dragStart(event) {
    const documentId = this.documentIdValue
    if (!documentId) return

    this.draggingValue = true
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", String(documentId))
    event.currentTarget.classList.add("opacity-40")
  }

  dragEnd(event) {
    event.currentTarget.classList.remove("opacity-40")
    this.clearFolderHighlights()
    this.draggingValue = false
  }

  dragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
  }

  dragEnter(event) {
    event.preventDefault()
    const folderEl = event.currentTarget
    folderEl.classList.add("ring-2", "ring-accent", "ring-offset-1")
  }

  dragLeave(event) {
    if (event.currentTarget.contains(event.relatedTarget)) return
    event.currentTarget.classList.remove("ring-2", "ring-accent", "ring-offset-1")
  }

  async drop(event) {
    event.preventDefault()
    const folderEl = event.currentTarget
    const destinationFolderId = Number(folderEl.dataset.folderId)
    const documentId = Number(event.dataTransfer.getData("text/plain"))

    if (!documentId || !destinationFolderId) return
    if (this.hasSelectedFolderIdValue && destinationFolderId === this.selectedFolderIdValue) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    const response = await fetch(`/documents/${documentId}/move`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "application/json"
      },
      body: JSON.stringify({ folder_id: destinationFolderId })
    })

    if (response.ok) {
      window.location = `/folders?folder_id=${destinationFolderId}`
      return
    }

    this.clearFolderHighlights()
    alert("Não foi possível mover o arquivo.")
  }

  clearFolderHighlights() {
    this.folderTargets.forEach((el) => {
      el.classList.remove("ring-2", "ring-accent", "ring-offset-1")
    })
  }

  syncFolderSelection() {
    if (!this.hasFolderTarget) return
    if (!this.hasSelectedFolderIdValue) return

    this.folderTargets.forEach((el) => {
      const isActive = Number(el.dataset.folderId) === this.selectedFolderIdValue
      const activeClasses = (el.dataset.activeClasses || "").split(" ").filter(Boolean)
      const inactiveClasses = (el.dataset.inactiveClasses || "").split(" ").filter(Boolean)

      el.setAttribute("aria-current", isActive ? "true" : "false")

      if (activeClasses.length) {
        if (isActive) {
          el.classList.add(...activeClasses)
        } else {
          el.classList.remove(...activeClasses)
        }
      }

      if (inactiveClasses.length) {
        if (isActive) {
          el.classList.remove(...inactiveClasses)
        } else {
          el.classList.add(...inactiveClasses)
        }
      }
    })
  }
}
