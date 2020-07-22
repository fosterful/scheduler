import React, { useState } from 'react'
import DatePicker from 'react-datepicker'

const DashboardReportsDateRangePicker = () => {
  const [start, setStart] = useState(null)
  const [end, setEnd] = useState(null)

  return (
    <>
      <DatePicker
        id='filter_start'
        selected={start}
        onChange={setStart}
        dateFormat='MMM d, yyyy'
        placeholderText='Start date'
      />
      to
      <DatePicker
        id='filter_end'
        selected={end}
        onChange={setEnd}
        dateFormat='MMM d, yyyy'
        placeholderText='End date'
      />
    </>
  )
}

export default DashboardReportsDateRangePicker
