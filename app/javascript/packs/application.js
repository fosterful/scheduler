import '@babel/polyfill'
import Foundation from '../src/foundation_loader'
import '../src/application.scss'
import Rails from 'rails-ujs'
import Selectize from 'selectize'
import Turbolinks from 'turbolinks'
import Inputmask from 'inputmask'
import OMDLogo from 'images/omd-logo-horiz.png'
import moment from 'moment-timezone'
import { extendMoment } from 'moment-range'
import 'react-toggle/style.css'

moment.tz.setDefault(window.timeZone)
window.moment = extendMoment(moment)

Rails.start()
Turbolinks.start()

$(document).on('turbolinks:load', function() {
  $('select.single').selectize()
  $('select.multiple').selectize({
    maxItems: null
  })
  Inputmask().mask(document.querySelectorAll('input'))
})

// Support component names relative to this directory:
var componentRequireContext = require.context('components', true)
var ReactRailsUJS = require('react_ujs')
ReactRailsUJS.useContext(componentRequireContext)
