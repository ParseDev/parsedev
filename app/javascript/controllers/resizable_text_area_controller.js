import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.style.height = `${this.element.scrollHeight}px`;
    this.element.addEventListener('input', this.resize.bind(this));
  }

  disconnect() {
    this.element.removeEventListener('input', this.resize.bind(this));
  }

  resize() {
    this.element.style.height = 'auto';
    this.element.style.height = `${this.element.scrollHeight}px`;
  }
}
