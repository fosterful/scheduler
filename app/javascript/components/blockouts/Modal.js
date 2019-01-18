import React from 'react'
import PropTypes from 'prop-types'
import SchedulerContext from './scheduler-context'
import ReactModal from 'react-modal'
import NewBlockoutModal from './NewBlockoutModal'
import EditBlockoutModal from './EditBlockoutModal'
import { isNil } from 'ramda'

ReactModal.setAppElement('#scheduler')

class Modal extends React.Component {
  modals = {
    NewBlockoutModal: NewBlockoutModal,
    EditBlockoutModal: EditBlockoutModal
  }

  renderComponent = (component, data) => {
    const Component = this.modals[component]
    return isNil(Component) ? null : <Component data={data} />
  }

  render () {
    return (
      <SchedulerContext.Consumer>
        {({ setModalInfo, modalInfo: { component, data } }) => (
          <ReactModal
            overlayClassName='reveal-overlay blockout-modal-overlay'
            className='reveal blockout-modal-content'
            isOpen={!isNil(component)}
            onRequestClose={setModalInfo.bind(this, {})}
          >
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
