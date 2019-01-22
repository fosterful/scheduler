import React from 'react'
import SchedulerContext from 'blockouts/contexts/scheduler'

const AddBlockoutButton = () =>
  <SchedulerContext.Consumer>
    {({ setModalInfo }) => (
      <button
        type='button'
        className='primary button add-new-blockout-button'
        onClick={setModalInfo.bind(this, { component: 'NewBlockoutModal' })}
      >
        Add Blockout
      </button>
    )}
  </SchedulerContext.Consumer>

export default AddBlockoutButton
