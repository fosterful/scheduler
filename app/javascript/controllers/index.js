// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"

const application = Application.start()
import NeedsShowController from './needs_show_controller'
application.register("needs_show", NeedsShowController)

import NewNeedFormController from './new_need_form_controller'
application.register("new_need_form", NewNeedFormController)
