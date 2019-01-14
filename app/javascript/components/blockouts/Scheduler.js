import React from "react"
import PropTypes from "prop-types"
import DayPicker from 'react-day-picker'
import moment from 'moment'
import SchedulerContext from './scheduler-context'
import Calendar from './Calendar'
import BlockoutList from './BlockoutList'
import AddBlockoutButton from "./AddBlockoutButton"
import Modal from "./Modal";
import splitblockoutsWithDays from './helpers/split_blockouts_by_day'
import expandRecurringBlockOuts from "./helpers/expand_recurring_blockouts";
import 'react-day-picker/lib/style.css'
import './scheduler.scss'

class Scheduler extends React.Component {
  setCalendarMonth  = calendarMonth => this.setState(state => ({ calendarMonth: moment(calendarMonth).startOf('month') }))
  
  state = {
    calendarMonth: moment().startOf('month'),
    setCalendarMonth: this.setCalendarMonth
  }

  expandedBlockouts = (blockouts, calendarMonth) => expandRecurringBlockOuts(blockouts, calendarMonth)
  blockoutsWithDays = blockouts => splitblockoutsWithDays(blockouts)

  render () {
    const { props: { blockouts }, state: { calendarMonth } } = this
    const expandedRecurringBlockouts = this.expandedBlockouts(blockouts, calendarMonth)
    const blockoutsWithDays = this.blockoutsWithDays(expandedRecurringBlockouts)
    return (
      <SchedulerContext.Provider value={this.state}>
        <React.Fragment>
          <Modal info={{ component: 'foo', data: {foo: 'bar'} } && false} />
          <Calendar blockouts={blockoutsWithDays} />
          <AddBlockoutButton />
          <BlockoutList blockoutsWithDays={blockoutsWithDays} />
        </React.Fragment>
      </SchedulerContext.Provider>
    )
  }
}

Scheduler.propTypes = {
  blockouts: PropTypes.array
}
export default Scheduler
