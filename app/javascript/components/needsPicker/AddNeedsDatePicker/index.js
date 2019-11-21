import React from 'react'
import PropTypes from 'prop-types'
import NeedsPickerContext from 'needsPicker/contexts/picker'
import Calendar from 'needsPicker/Calendar'
import 'react-day-picker/lib/style.css'


class AddNeedsDatePicker extends React.Component{
  setCalendarMonth = calendarMonth => this.setState({
    calendarMonth: moment(calendarMonth).startOf('month') 
  })

  state = {
    calendarMonth: moment().startOf('month'),
    setCalendarMonth: this.setCalendarMonth,
    makeRequest: makeRequestFn(this.props.authenticity_token)
  }


  render () {
    const { state: { calendarMonth } } = this
    return (
      // Psuedo code for the context provider goes here
      <DatePickerContext.Provider value={{ ...this.state, ...}}
    )
  }
}

AddNeedsDatePicker.propTypes = {
  
}
export default AddNeedsDatePicker