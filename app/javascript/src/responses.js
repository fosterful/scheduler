$(document).ready(function() {
  $('#toggle-optouts-list').on('click', function() {
    $('#optouts-list').toggleClass('hide');
  });

  $('#toggle-pending-list').on('click', function() {
    $('#pending-list').toggleClass('hide');
  });
});