import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["folder"]
  static values = { documentId: Number, selectedFolderId: Number }

  dragStart(event) {
    const documentId = this.documentIdValue
    if (!documentId) return

    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", String(documentId))
    event.currentTarget.classList.add("opacity-40")
  }

  dragEnd(event) {
    event.currentTarget.classList.remove("opacity-40")
    this.clearFolderHighlights()
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
}
