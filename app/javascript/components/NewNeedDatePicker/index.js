import React from 'react'
import DatePicker from 'react-datepicker'

class AddNeedsPicker extends React.Component {
  state = {
    startDate: this.props.startAt ? new Date(this.props.startAt) : new Date()
  }

  handleChange = date => {
    this.setState({
      startDate: date
    })
  }

  render() {
    return (
      <DatePicker
        selected={this.state.startDate}
        onChange={this.handleChange}
        showTimeSelect
        timeIntervals={15}
        dateFormat="MMM d, yyyy h:mm aa"
        name="need[start_at]"
      />
    )
  }
}

export default AddNeedsPicker
