import React from 'react'
import SchedulerContext from 'blockouts/contexts/scheduler'
import ReactModal from 'react-modal'
import NewBlockoutModal from 'blockouts/NewBlockoutModal'
import EditBlockoutModal from 'blockouts/EditBlockoutModal'
import { isNil } from 'ramda'

ReactModal.setAppElement('#scheduler')

class Modal extends React.Component {
  modals = {
    NewBlockoutModal: NewBlockoutModal,
    EditBlockoutModal: EditBlockoutModal
  }

  renderContent = (component, data) => {
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
            { this.renderContent(component, data) }
          </ReactModal>
        )}
      </SchedulerContext.Consumer>
    )
  }
}

export default Modal
