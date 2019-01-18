import React from 'react'
import PropTypes from 'prop-types'
import moment from 'moment'
import SchedulerContext from 'blockouts/contexts/scheduler'
import Calendar from 'blockouts/Calendar'
import BlockoutList from 'blockouts/BlockoutList'
import AddBlockoutButton from 'blockouts/AddBlockoutButton'
import Modal from 'blockouts/Modal'
import splitblockoutsWithDays from 'blockouts/helpers/splitBlockoutsByDay'
import expandRecurringBlockOuts from 'blockouts/helpers/expandRecurringBlockouts'
import makeRequestFn from 'blockouts/helpers/makeRequest'
import 'react-day-picker/lib/style.css'

class Scheduler extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      blockouts: props.blockouts,
      calendarMonth: moment().startOf('month'),
      setCalendarMonth: this.setCalendarMonth,
      modalInfo: {},
      setModalInfo: this.setModalInfo,
      updateBlockoutsState: this.updateBlockoutsState,
      makeRequest: makeRequestFn(props.authenticity_token),
      removeBlockoutFromState: this.removeBlockoutFromState
    }
  }

  setCalendarMonth = calendarMonth => this.setState(state => ({ calendarMonth: moment(calendarMonth).startOf('month') }))
  setModalInfo = info => this.setState(state => ({ modalInfo: info }))

  updateBlockoutsState = blockoutsToUpdate => {
    const { state: { blockouts } } = this
    const ids = blockoutsToUpdate.map(b => b.id)
    const updatedBlockouts = blockouts.filter(b => !ids.includes(b.id)).concat(blockoutsToUpdate)
    this.setState(state => ({ blockouts: updatedBlockouts }))
  }

  removeBlockoutFromState = blockoutId => {
    const { state: { blockouts } } = this
    const updatedBlockouts = blockouts.filter(b => b.id != blockoutId)
    this.setState(state => ({ blockouts: updatedBlockouts }))
  }

  expandedBlockouts = (blockouts, calendarMonth) => expandRecurringBlockOuts(blockouts, calendarMonth)
  blockoutsWithDays = (blockouts, calendarMonth) => splitblockoutsWithDays(blockouts, calendarMonth)

  render () {
    const { props: { authenticity_token }, state: { blockouts, calendarMonth } } = this
    const expandedRecurringBlockouts = this.expandedBlockouts(blockouts, calendarMonth)
    const blockoutsWithDays = this.blockoutsWithDays(expandedRecurringBlockouts, calendarMonth)
    return (
      <SchedulerContext.Provider value={{ ...this.state, ...{ authenticity_token: authenticity_token } }}>
        <React.Fragment>
          <Modal />
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
