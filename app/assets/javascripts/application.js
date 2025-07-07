document.addEventListener('DOMContentLoaded', function() {
  document.body.addEventListener('ajax:success', function(event) {
    var detail = event.detail;
    var xhr = detail[0];
    var target = event.target;
    if (target.classList.contains('detected-urls-page-link')) {
      document.getElementById('detected-urls-table').innerHTML = xhr;
    } else if (target.classList.contains('undetected-urls-page-link')) {
      document.getElementById('undetected-urls-table').innerHTML = xhr;
    }
  });
}); 