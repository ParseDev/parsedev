import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {

    connect() {
    }
  
    handleClick(event) {
        const mobileMenuButton = document.querySelector('[aria-controls="mobile-menu"]');
        const mobileMenu = document.getElementById('mobile-menu');
        const isExpanded = mobileMenuButton.getAttribute('aria-expanded') === 'true';
        mobileMenuButton.setAttribute('aria-expanded', !isExpanded);
        mobileMenu.classList.toggle('hidden');
        
    }
}
