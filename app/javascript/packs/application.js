import Foundation from '../src/foundation_loader';
import '../src/application.scss';
import Rails from 'rails-ujs';
import Selectize from 'selectize';
import Turbolinks from 'turbolinks';
import Inputmask from 'inputmask';
import OMDLogo from 'images/omd-logo.png'

Rails.start();
Turbolinks.start();

$(document).on('turbolinks:load', function() {
  $('select').selectize()
  Inputmask().mask(document.querySelectorAll("input"));
});

// Support component names relative to this directory:
var componentRequireContext = require.context("components", true)
var ReactRailsUJS = require("react_ujs")
ReactRailsUJS.useContext(componentRequireContext)