import React from 'react'
import DatePicker from 'react-datepicker'

class AddNeedsIndexPicker extends React.Component {
  state = {
    startDate: this.props.startDate ? new Date(this.props.startDate) : null
  }

  handleChange = date => {
    return window.location="?start_date=" + date.toISOString().substring(0, 10)
  }

  render() {
    return (
      <DatePicker
        selected={this.state.startDate}
        onChange={this.handleChange}
        dateFormat="MMM d, yyyy"
        name="start_date"
      />
    )
  }
}

export default AddNeedsIndexPicker
