import 'core-js/stable'
import 'regenerator-runtime/runtime'
import Foundation from '../src/foundation_loader'
import '../src/application.scss'
import Rails from 'rails-ujs'
import select2 from 'select2'
import Turbolinks from 'turbolinks'
import Inputmask from 'inputmask'
import Favicon from 'images/omd-icon.png'
import OMDLogo from 'images/omd-logo-horiz.png'
import moment from 'moment-timezone'
import { extendMoment } from 'moment-range'
import 'react-toggle/style.css'
import '../src/responses'

moment.tz.setDefault(window.timeZone)
window.moment = extendMoment(moment)

Rails.start()
Turbolinks.start()

$(document).on('turbolinks:load', function() {
  $('select.single').select2()
  $('select.multiple').select2({
    maximumSelectionLength: 0
  })
  Inputmask().mask(document.querySelectorAll('input'))
})

// Support component names relative to this directory:
var componentRequireContext = require.context('components', true)
var ReactRailsUJS = require('react_ujs')
ReactRailsUJS.useContext(componentRequireContext)
