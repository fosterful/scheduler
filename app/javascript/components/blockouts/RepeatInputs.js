import React from "react"
import BlockoutFormContext from './blockout-form-context'
import DayPickerInput from 'react-day-picker/DayPickerInput';
import { RRule, RRuleSet, rrulestr } from 'rrule'
import moment from 'moment'

class RepeatInputs extends React.Component {
  state = {
    interval: '',
    frequency: 'DAILY',
    byWeekDay: '',
    until: '',
    untilDate: undefined
  }

  componentDidUpdate = _ => {
    const { computeRrule, state: { fromDateWas }, context: { inputs: { fromDate } } } = this
    if (fromDate != fromDateWas) {
      computeRrule()
      this.setState(state => ({ fromDateWas: fromDate }))
    }
  }

  getNumberWithOrdinal(n) {
    var s=["th","st","nd","rd"],
    v=n%100;
    return n+(s[(v-20)%10]||s[v]||s[0]);
  }

  computeRrule = _ => {
    const { state: { interval, frequency, byWeekDay, until, untilDate }, context: { inputs: { startAt } } } = this
    if (interval) {
      const weekDayMapping = [RRule.SU, RRule.MO, RRule.TU, RRule.WE, RRule.TH, RRule.FR, RRule.SA]
      const options = {
        freq: RRule[frequency],
        interval: interval,
        until: until ? untilDate : null
      }

      if (byWeekDay && frequency === 'MONTHLY') {
        options.byweekday = weekDayMapping[moment(startAt).format('d')]
        options.bysetpos = Math.ceil(moment(startAt).date() / 7)
      }

      const rrule = new RRule(options)
      this.context.setFormInputs({ rrule: rrule.toString().replace('RRULE:', '') })
    } else {
      this.context.setFormInputs({ rrule: null })
    }
  }

  handleInputChange = (input) => {
    return ({ target: { value } }) => {
      this.setState(state => ({ [input]: value }), this.computeRrule)
    }
  }

  IntervalSelectOptions = _ =>
    <React.Fragment>
      <option value=''>Does not repeat</option>
      <option value='1'>Every</option>
      <option value='2'>Every two</option>
      <option value='3'>Every three</option>
      <option value='4'>Every four</option>
      <option value='5'>Every five</option>
      <option value='6'>Every six</option>
      <option value='7'>Every seven</option>
      <option value='8'>Every eight</option>
    </React.Fragment>

    IntervalSelect = _ => {
      const { IntervalSelectOptions, handleInputChange, state: { interval } } = this
      return (
        <div className="cell large-4">
          <select value={interval} onChange={handleInputChange('interval')}>
            <IntervalSelectOptions />
          </select>
        </div>
      )
    }

    FrequencySelect = _ => {
      const { handleInputChange, state: { interval, frequency } } = this
      if (!interval) return null
      return (
        <div className="cell large-3">
          <select value={frequency} onChange={handleInputChange('frequency')}>
            <option value='DAILY'>day</option>
            <option value='WEEKLY'>week</option>
            <option value='MONTHLY'>month</option>
            <option value='YEARLY'>year</option>
          </select>
        </div>
      )
    }

    ByWeekDaySelect = _ => {
      const { getNumberWithOrdinal, handleInputChange, state: { interval, frequency, byWeekDay }, context: { inputs: { startAt } } } = this
      if (!interval || frequency != 'MONTHLY') return null
      const weekOfMonth = getNumberWithOrdinal(Math.ceil(moment(startAt).date() / 7))
      const dayOfWeek = moment(startAt).format('dddd')
      return (
        <div className="cell large-4">
          <select value={byWeekDay} onChange={handleInputChange('byWeekDay')}>
            <option value=''>on the {moment(startAt).format('Do')} day</option>
            <option value='true'>on the {weekOfMonth} {dayOfWeek}</option>
          </select>
        </div>
      )
    }

    UntilSelect = _ => {
      const { handleInputChange, state: { interval, until } } = this
      if (!interval) return null
      return (
        <div className="cell large-3">
          <select value={until} onChange={handleInputChange('until')}>
            <option value=''>forever</option>
            <option value='until'>until</option>
          </select>
        </div>
      )
    }

    UntilDatePicker = _ => {
      const { handleInputChange, state: { interval, until, untilDate }, context: { inputs: { toDate } } } = this
      if (!interval || until != 'until') return null
      const handler = handleInputChange('untilDate')
      return (
        <div className="cell large-3">
          <DayPickerInput
            inputProps={{ type: 'text' }}
            value={untilDate}
            formatDate={date => moment(date).format('ll')}
            onDayChange={day => handler({ target: { value: day } })}
            dayPickerProps={{
              disabledDays: { before: toDate }
            }}
          />
        </div>
      )
    }

  render () {
    const { IntervalSelect, FrequencySelect, ByWeekDaySelect, UntilSelect, UntilDatePicker } = this
    return (
      <React.Fragment>
        <label>Repeat</label>
        <div className="grid-x blockout-repeat-inputs">
          <IntervalSelect />
          <FrequencySelect />
          <ByWeekDaySelect />
          <UntilSelect />
          <UntilDatePicker />
        </div>
      </React.Fragment>
    )
  }
}

RepeatInputs.contextType = BlockoutFormContext
export default RepeatInputs
