import React, { useState } from 'react'
import DatePicker from 'react-datepicker'

const DashboardReportsDateRangePicker = () => {
  const [start, setStart] = useState(null)
  const [end, setEnd] = useState(null)
  const [showErrorMessage, setShowErrorMessage] = useState(false)
  const [msg, setMsg] = useState(null)

  global.displayDateRangeErrorMessage = msg => {
    setShowErrorMessage(true)
    setMsg(msg)
  }

  global.hideDateRangeErrorMessage = () => setShowErrorMessage(false)

  return (
    <>
      <div className='margin-top-1'>
        <p>Choosing a date range will constrain reports to those dates:</p>
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
      {showErrorMessage && <div className='alert callout'>{msg}</div>}
    </>
  )
}

export default DashboardReportsDateRangePicker
