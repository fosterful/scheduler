import React from "react"
import PropTypes from "prop-types"
import DayPicker from 'react-day-picker'
import Calendar from './Calendar'
import BlockoutList from './BlockoutList'
import AddBlockoutButton from "./AddBlockoutButton"
import Modal from "./Modal";
import splitblockoutsWithDays from './helpers/split_blockouts_by_day'
import 'react-day-picker/lib/style.css'
import './scheduler.scss'

class Scheduler extends React.Component {
  blockoutsWithDays = _ => splitblockoutsWithDays(this.props.blockouts)

  render () {
    const blockoutsWithDays = this.blockoutsWithDays()
    return (
      <React.Fragment>
        <Modal info={{ component: 'foo', data: {foo: 'bar'} }} />
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
