import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Listen for the turbo:before-fetch-request event to hide the Turbo progress bar
    document.addEventListener("turbo:before-fetch-request", this.hideTurboProgressBar);
  }

  disconnect() {
    // Remove the event listener when the controller is disconnected
    document.removeEventListener("turbo:before-fetch-request", this.hideTurboProgressBar);
  }

  hideTurboProgressBar(event) {
    // Use setTimeout to wait for the Turbo progress bar to be created
    setTimeout(() => {
      // Get the Turbo progress bar element
      const turboProgressBar = document.querySelector(".turbo-progress-bar");
      // Add the "hide-element" class to hide the Turbo progress bar
      if (turboProgressBar) {
        turboProgressBar.classList.add("hidden");
      }
    }, 501);
    // Note that the Turbo progress bar is created from the DOM after 500ms
  }
}