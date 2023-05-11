import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "loader", "formInput"];

  connect() {
    this.element.addEventListener("turbo:submit-start", () => this.disableForm());
    this.element.addEventListener("turbo:submit-end", () => this.enableForm());
  }

  showLoader() {
    const loader = document.getElementById("message-loader");
    if (loader) {
    loader.classList.remove("hidden");
    }
    this.buttonTarget.classList.add("hidden");
    this.loaderTarget.classList.remove("hidden");
  }

  hideLoader() {
    const loader = document.getElementById("message-loader");
    if (loader) {
    loader.classList.add("hidden");
    }
    this.buttonTarget.classList.remove("hidden");
    this.loaderTarget.classList.add("hidden");
  }

  disableForm() {
    this.showLoader();
    this.formInputTargets.forEach(input => input.disabled = true);
  }

  enableForm() {
    window.scrollTo(0, document.body.scrollHeight);
    this.hideLoader();
    this.formInputTargets.forEach(input => input.disabled = false);
  }

  submitForm(event) {
    event.preventDefault();
    if (this.element.checkValidity()) {
      this.disableForm();
      const inputField = document.getElementById('input-text-area');
      let messageContent = inputField.value;
      var newMessage = document.createElement('div');
      newMessage.className = 'mb-4 mt-4';
      newMessage.innerHTML = `
          <div class="inline-block bg-blue-100 rounded-tl-lg rounded-tr-lg rounded-br-lg px-4 py-2 text-green-800">
              You: ${messageContent}
          </div>
      `;
  
        // Append the new HTML element to the messages-container
        document.getElementById('result_frame').appendChild(newMessage);
  
      this.element.requestSubmit();
      inputField.value = '';
    } else {
      this.element.reportValidity();
    }
  }
  
}
