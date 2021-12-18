import 'core-js/stable'
import 'regenerator-runtime/runtime'
import Foundation from './src/foundation_loader'
import Rails from 'rails-ujs'
import select2 from 'select2'
import Turbolinks from 'turbolinks'
import Inputmask from 'inputmask'
import moment from 'moment-timezone'
import { extendMoment } from 'moment-range'
import './src/dashboard_reports'

moment.tz.setDefault(window.timeZone)
window.moment = extendMoment(moment)

Rails.start()
Turbolinks.start()

// $(document).on('turbolinks:load', function () {
//   $('select.single').select2()
//   $('select.multiple').select2({
//     maximumSelectionLength: 0
//   })
//   Inputmask().mask(document.querySelectorAll('input'))
// })

const ReactRailsUJS = require("react_ujs");
import * as Components from "./components";
ReactRailsUJS.getConstructor = (className) => Components[className];

import './controllers'