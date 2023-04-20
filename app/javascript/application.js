// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Get the button element by its ID.
const userMenuButton = document.getElementById('user-menu-button');

// If the userMenuButton element exists, proceed with the rest of the code.
if (userMenuButton) {
  // Get the menu element by its role attribute.
  const menu = document.querySelector('[role="menu"]');

  // Initially hide the menu by setting its display style to 'none'.
  menu.style.display = 'none';

  // Add a click event listener to the button.
  userMenuButton.addEventListener('click', () => {
    // Toggle the visibility of the menu based on its current display style.
    if (menu.style.display === 'none') {
      // If the menu is hidden, show it by setting its display style to 'block'.
      menu.style.display = 'block';
    } else {
      // If the menu is visible, hide it by setting its display style to 'none'.
      menu.style.display = 'none';
    }
  });
}




const closeButton = document.getElementById('close-button');
const openButton = document.getElementById('mobile-menu-button');

if(closeButton && openButton) {
  // Get the element with the ID "sidebar"
  const sidebar = document.getElementById('sidebar');
  const backdrop = document.getElementById('backdrop');

  // Add a click event listener to the close button
  closeButton.addEventListener('click', function() {
    // Hide the sidebar element by setting its display property to "none"
    sidebar.style.display = 'none';
    // Hide backdrop
    backdrop.style.display = 'none';
  });

  openButton.addEventListener('click', function() {
    // Show the sidebar element by setting its display property to "block"
    sidebar.style.display = '';
    // Show backdrop
    backdrop.style.display = '';
  });
}
