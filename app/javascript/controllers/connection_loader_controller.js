import { Controller } from "@hotwired/stimulus"

export default class extends Controller {


  submit(event) {
    // Code to be executed when the form is submitted
    event.preventDefault();

    const loadingConnectionModal = document.getElementById('loadingConnectionModal');
    if (loadingConnectionModal) {
      loadingConnectionModal.classList.remove('hidden');
    }

    // Get the form element
    const form = event.target.closest('form');
    if (form) {
      form.submit(); // Submit the form
    }
  }
}
