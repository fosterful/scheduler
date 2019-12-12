import React from 'react'
import DatePicker from 'react-datepicker'

class AddNeedsIndexPicker extends React.Component {
  statics = {
    utc_offset: new Date().getTimezoneOffset() * 60 * 1000
  }

  state = {
    date: this.props.date ? new Date(Date.parse(this.props.date) + this.statics.utc_offset) : null
  }

  handleChange = date => {
    if (date)
      return window.location="?date=" + date.toISOString().substring(0, 10)
    else
      return window.location=window.location.pathname
  }

  render() {
    return (
      <DatePicker
        selected={this.state.date}
        onChange={this.handleChange}
        dateFormat="MMM d, yyyy"
        name="start_date"
        placeholderText="Filter by date"
      />
    )
  }
}

export default AddNeedsIndexPicker
