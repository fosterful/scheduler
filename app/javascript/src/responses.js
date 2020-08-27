$(document).on('turbolinks:load', function () {
  $('#toggle-unavailable-list').on('click', function (e) {
    e.preventDefault();
    $('#unavailable-list').toggleClass('hide');
  });

  $('#toggle-pending-list').on('click', function (e) {
    e.preventDefault();
    $('#pending-list').toggleClass('hide');
  });
});