import React from "react"
import PropTypes from "prop-types"
import DayPicker from 'react-day-picker'
import moment from 'moment'
import Calendar from './Calendar'
import BlockoutList from './BlockoutList'
import AddBlockoutButton from "./AddBlockoutButton"
import Modal from "./Modal";
import splitblockoutsWithDays from './helpers/split_blockouts_by_day'
import expandRecurringBlockOuts from "./helpers/expand_recurring_blockouts";
import 'react-day-picker/lib/style.css'
import './scheduler.scss'

class Scheduler extends React.Component {
  expandedBlockouts = _ => expandRecurringBlockOuts(this.props.blockouts)
  blockoutsWithDays = blockouts => splitblockoutsWithDays(blockouts)

  render () {
    const expandedRecurringBlockouts = this.expandedBlockouts()
    const blockoutsWithDays = this.blockoutsWithDays(expandedRecurringBlockouts)
    return (
      <React.Fragment>
        <Modal info={{ component: 'foo', data: {foo: 'bar'} } && false} />
        <Calendar blockouts={blockoutsWithDays} />
        <AddBlockoutButton />
        <BlockoutList blockoutsWithDays={blockoutsWithDays} />
      </React.Fragment>
    )
  }
}

Scheduler.propTypes = {
  blockouts: PropTypes.array
}
export default Scheduler
