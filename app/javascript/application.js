// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
document.addEventListener('DOMContentLoaded', function() {
  const productSelect = document.querySelector('select[name="order[product_ids][]"]');
  const totalAmountInput = document.querySelector('input[name="order[total_amount]"]');

  function updateTotalAmount() {
    let totalAmount = 0;
    const selectedProductIds = Array.from(productSelect.selectedOptions).map(option => option.value);
    
    console.log('Selected Product IDs:', selectedProductIds);  // Debugging line
    
    if (selectedProductIds.length > 0) {
      // Make an AJAX request to fetch product prices based on selected product IDs
      fetch('/products/prices', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ product_ids: selectedProductIds })
      })
      .then(response => response.json())
      .then(data => {
        console.log('Fetched Prices:', data.prices);  // Debugging line
        data.prices.forEach(price => totalAmount += price);
        totalAmountInput.value = totalAmount.toFixed(2);
      });
    } else {
      totalAmountInput.value = '0.00';
    }
  }

  productSelect.addEventListener('change', updateTotalAmount);
});


// Disable the submit button to prevent multiple submissions
document.querySelector('form').addEventListener('submit', function() {
  this.querySelector('input[type="submit"]').disabled = true;
});


