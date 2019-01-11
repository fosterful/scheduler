import React from "react"
import PropTypes from "prop-types"
import DayPicker from 'react-day-picker'
import 'react-day-picker/lib/style.css'
import './scheduler.scss'


class Calendar extends React.Component {
  render () {
    const modifiers = {
      highlighted: this.props.blockouts.flat().map(b => b.range.start.toDate())
    }
    return (
      <DayPicker modifiers={modifiers} />
    )
  }
}

Calendar.propTypes = {
  blockouts: PropTypes.array
}
export default Calendar
