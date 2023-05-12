import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "link", "select" ]

  connect() {
    this.updateLink()
  }

  updateLink() {
    const datasourceId = this.selectTarget.value
    if (datasourceId && datasourceId.trim() !== "") {
        this.linkTarget.classList.remove("hidden");
      }
    const newHref = `/datasources/${datasourceId}`
    this.linkTarget.href = newHref
  }
}
