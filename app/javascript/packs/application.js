import Foundation from '../src/foundation_loader';
import '../src/application.scss';
import Rails from 'rails-ujs';
import Selectize from 'selectize';
import Turbolinks from 'turbolinks';
import Inputmask from 'inputmask';

Rails.start();
Turbolinks.start();

$(document).on('turbolinks:load', function() {
  $('select').selectize()
  Inputmask().mask(document.querySelectorAll("input"));
});
