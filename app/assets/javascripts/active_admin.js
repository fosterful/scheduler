//= require active_admin/base
//= require selectize

$(document).ready(function() {
  $("select.single").selectize();
  $("select.multiple").selectize({
    maxItems: null
  });
});
