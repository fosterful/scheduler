import React from "react"
import PropTypes from "prop-types"
import SchedulerContext from './scheduler-context'

class AddBlockoutButton extends React.Component {
  render () {
    return (
      <SchedulerContext.Consumer>
        {({ setModalInfo }) => (
          <button 
            type='button'
            className='success button tiny'
            onClick={ setModalInfo.bind(this, { component: 'NewBlockoutModal'}) }
          >
            Add Blockout
          </button>
        )}
      </SchedulerContext.Consumer>
    )
  }
}
export default AddBlockoutButton
