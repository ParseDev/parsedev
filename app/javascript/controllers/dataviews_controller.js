import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  createDataquery(event) {
    event.preventDefault();
    const frame = event.target.closest("turbo-frame");
    const form = frame.querySelector("form");

    Rails.ajax({
      url: form.action,
      type: form.method,
      data: new FormData(form),
      success: (response) => {
        Turbo.renderStreamMessage(response);
      },
      error: (xhr) => {
        console.error(xhr);
      },
    });
  }
}
