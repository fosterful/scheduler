$(document).ready(function() {
  $('#toggle-optouts-list').on('click', function(e) {
    e.preventDefault();
    $('#optouts-list').toggleClass('hide');
  });

  $('#toggle-pending-list').on('click', function(e) {
    e.preventDefault();
    $('#pending-list').toggleClass('hide');
  });
});