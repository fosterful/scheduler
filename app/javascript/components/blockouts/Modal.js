import React from "react"
import PropTypes from "prop-types"
import SchedulerContext from './scheduler-context'
import ReactModal from 'react-modal'
import NewBlockoutModal from "./NewBlockoutModal"
import { isNil } from 'ramda'


ReactModal.setAppElement('#scheduler')

class Modal extends React.Component {
  modals = {
    NewBlockoutModal: NewBlockoutModal
  }

  renderComponent = (component, data) => {
    const Component = this.modals[component]
    return isNil(Component) ? null : <Component data={data} />
  }

  render () {
    return (
      <SchedulerContext.Consumer>
        {({ modalInfo: { component, data } }) => (
          <ReactModal isOpen={ !isNil(component) }>
            { this.renderComponent(component, data) }
          </ReactModal>
        )}
      </SchedulerContext.Consumer>
    )
  }
}

Modal.propTypes = {
  info: PropTypes.bool
}

export default Modal
