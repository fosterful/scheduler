import React, { useState } from 'react'
import DatePicker from 'react-datepicker'

const DashboardReportsDateRangePicker = () => {
  const [start, setStart] = useState(null)
  const [end, setEnd] = useState(null)
  const [showErrorMessage, setShowErrorMessage] = useState(false)
  const [msg, setMsg] = useState(null)

  const clearDates = () => {
    setStart(null)
    setEnd(null)
  }

  global.displayDateRangeErrorMessage = msg => {
    setShowErrorMessage(true)
    setMsg(msg)
  }

  global.hideDateRangeErrorMessage = () => setShowErrorMessage(false)

  return (
    <>
      <div className='margin-top-1'>
        <p>Choosing a date range will constrain reports to those dates:</p>
        <div class="date-flex-wrap">
          <DatePicker
            id='filter_start'
            selected={start}
            onChange={setStart}
            dateFormat='MMM d, yyyy'
            placeholderText='Start date'
          />
          <span className='margin-horizontal-1'>to</span>
          <DatePicker
            id='filter_end'
            selected={end}
            onChange={setEnd}
            dateFormat='MMM d, yyyy'
            placeholderText='End date'
          />
        </div>
        {(start || end) && (
          <span>
            <button className='button secondary margin-left-1' onClick={clearDates}>
              <i className='fas fa-times-circle' style={{ marginRight: '0.25rem' }} />
              Clear dates
            </button>
          </span>
        )}
      </div>
      {showErrorMessage && <div className='alert callout'>{msg}</div>}
    </>
  )
}

export default DashboardReportsDateRangePicker
