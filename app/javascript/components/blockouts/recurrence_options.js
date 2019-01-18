import React from 'react'

const selectedRecurrenceOptionClass = (selectedRecurrenceOption, option) => {
  return selectedRecurrenceOption === option ? 'primary' : 'hollow secondary'
}

const RecurrenceOptions = ({ selectedRecurrenceOption, selectRecurrenceOption }) => {
  return (
    <React.Fragment>
      Recurrence Options
      <div className='grid-x grid-margin-x blockout-edit-recurrence-options'>
        <div className='cell auto'>
          <button className={`button ${selectedRecurrenceOptionClass(selectedRecurrenceOption, 'one')}`} onClick={selectRecurrenceOption('one')}>
            ONE
            <div className='subtext'>Edit this particular date only</div>
          </button>
        </div>
        <div className='cell auto'>
          <button className={`button ${selectedRecurrenceOptionClass(selectedRecurrenceOption, 'future')}`} onClick={selectRecurrenceOption('future')}>
            FUTURE
            <div className='subtext'>Edit this and future dates</div>
          </button>
        </div>
        <div className='cell auto'>
          <button className={`button ${selectedRecurrenceOptionClass(selectedRecurrenceOption, 'all')}`} onClick={selectRecurrenceOption('all')}>
            All
            <div className='subtext'>Edit all days for this recurrence</div>
          </button>
        </div>
      </div>
    </React.Fragment>
  )
}

export default RecurrenceOptions
