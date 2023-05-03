
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


document.addEventListener('DOMContentLoaded', function () {
  // Mobile menu button
  const mobileMenuButton = document.querySelector('[aria-controls="mobile-menu"]');
  const mobileMenu = document.getElementById('mobile-menu');

  // User menu button
  const userMenuButton = document.getElementById('user-menu-button');
  const userMenu = document.querySelector('[aria-labelledby="user-menu-button"]');

  // Toggle mobile menu
  mobileMenuButton.addEventListener('click', function () {
    const isExpanded = mobileMenuButton.getAttribute('aria-expanded') === 'true';
    mobileMenuButton.setAttribute('aria-expanded', !isExpanded);
    mobileMenu.classList.toggle('hidden');
  });

  // Toggle user menu
  userMenuButton.addEventListener('click', function () {
    const isExpanded = userMenuButton.getAttribute('aria-expanded') === 'true';
    userMenuButton.setAttribute('aria-expanded', !isExpanded);
    userMenu.classList.toggle('hidden');
  });

  // Close user menu when clicking outside
  document.addEventListener('click', function (event) {
    if (!userMenuButton.contains(event.target) && !userMenu.contains(event.target)) {
      userMenuButton.setAttribute('aria-expanded', false);
      userMenu.classList.add('hidden');
    }
  });
}, {once: true});
