import React from 'react'
import PropTypes from 'prop-types'
import SchedulerContext from 'components/blockouts/contexts/scheduler'

class AddBlockoutButton extends React.Component {
  render () {
    return (
      <SchedulerContext.Consumer>
        {({ setModalInfo }) => (
          <button
            type='button'
            className='primary button tiny add-new-blockout-button'
            onClick={setModalInfo.bind(this, { component: 'NewBlockoutModal' })}
          >
            Add Blockout
          </button>
        )}
      </SchedulerContext.Consumer>
    )
  }
}
export default AddBlockoutButton
