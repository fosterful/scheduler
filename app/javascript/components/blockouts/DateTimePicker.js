import React from "react"
import PropTypes from "prop-types"
import Moment from 'moment'
import { extendMoment } from 'moment-range'
import DayPickerInput from 'react-day-picker/DayPickerInput';
import BlockoutFormContext from './blockout-form-context'

const moment = extendMoment(Moment)

class DateTimePicker extends React.Component {

  timeOptions = _ => {
    const begin = moment().hour(6).minute(30).second(0)
    const end   = moment().hour(23).minute(30).second(0)
    const range = moment.range(begin, end)
    const times = Array.from(range.by('minutes', {step: 30}))
    const options = times.map(t => ({value: t.format('HH:mm'), text: t.format('h:mm a')}))
    options.unshift({value: moment().startOf('day').format('HH:mm'), text: 'Start of Day'})
    options.push({value: moment().endOf('day').format('HH:mm'), text: 'End of Day'})
    return options
  }

  state ={
    allDay: true,
    fromDate: undefined,
    toDate: undefined,
    fromTime: '00:00',
    toTime: '23:59',
    timeOptions: this.timeOptions()
  }

  componentDidMount() {
    const { context: { inputs: { startAt, endAt } } } = this
    const update = {}
    if (startAt) {
      update.fromDate = startAt
      const startAtTime = moment(startAt).format('HH:mm')
      if (startAtTime != '00:00') {
        update.fromTime = startAtTime
        update.allDay = false
      }
    }

    if (endAt) {
      update.toDate = endAt
      const endAtTime = moment(endAt).format('HH:mm')
      if (endAtTime != '23:59') {
        update.toTime = endAtTime
        update.allDay = false
      }
    }
    this.setState(state => update)
  }

  toggleAllDay = _ => {
    if (this.state.allDay) {
      this.setState(state => ({ allDay: false }))
    } else {
      this.setState(state => ({ allDay: true, fromTime: '00:00', toTime: '23:59' }), this.computeResult)
    }
  }

  renderTimeSelectOptions = _ => {
    return this.state.timeOptions.map(({value, text}, index) => {
      return <option value={value} key={index}>{text}</option>
    })
  }

  renderTimeSelect = (input, value) => {
    if (!this.state.allDay) {
      const handler = this.handleInputChange(input)
      return (
        <select value={value} onChange={event => handler(event.target.value)}>
          {this.renderTimeSelectOptions(input)}
        </select>
      )
    }
  }

  computeResult = _ => {
    const { state: { fromDate, toDate, fromTime, toTime } } = this
    const update = {}

    const startAtStr = `${moment(fromDate).format('YYYY-MM-DD')}T${fromTime}:00`
    update.startAt = moment(startAtStr, moment.ISO_8601).toDate()

    if (toDate) {
      const endAtStr = `${moment(toDate).format('YYYY-MM-DD')}T${toTime}:00`
      update.endAt = moment(endAtStr, moment.ISO_8601).toDate()
    }

    this.context.setFormInputs(update)
  }

  handleInputChange = (input) => {
    return value => {
      this.setState(state => ({ [input]: value }), this.computeResult)
    }
  }

  render () {
    const { toggleAllDay, handleInputChange, renderTimeSelect, state: { allDay, fromDate, toDate, fromTime, toTime } } = this
    return (
      <div className="grid-x grid-margin-x blockout-date-time-picker">
        <div className="cell small-2">
          <label>
            All Day
            <input type='checkbox' checked={allDay} onChange={ toggleAllDay } />
          </label>
        </div>
        <div className="cell small-5">
          <label htmlFor=''>Start Date</label>
          <DayPickerInput
            inputProps={{ type: 'text' }}
            value={fromDate}
            formatDate={date => moment(date).format('ll')}
            onDayChange={handleInputChange('fromDate')}
            dayPickerProps={{
              selectedDays: [fromDate, { fromDate, toDate }],
              disabledDays: { after: toDate }
            }}
          />
          {renderTimeSelect('fromTime', fromTime, handleInputChange)}
        </div>
        <div className="cell small-5">
          <label htmlFor=''>End Date</label>
          <DayPickerInput
            inputProps={{ type: 'text' }}
            value={toDate}
            formatDate={date => moment(date).format('ll')}
            onDayChange={handleInputChange('toDate')}
            dayPickerProps={{
              selectedDays: [fromDate, { fromDate, toDate }],
              disabledDays: { before: fromDate }
            }}
          />
          {renderTimeSelect('toTime', toTime, handleInputChange)}
        </div>
      </div>
    )
  }
}

DateTimePicker.propTypes = {
  data: PropTypes.object
}

DateTimePicker.contextType = BlockoutFormContext
export default DateTimePicker
