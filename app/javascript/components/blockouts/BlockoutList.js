import React from 'react'
import PropTypes from 'prop-types'
import Blockout from './Blockout'
import moment from 'moment'
import * as R from 'ramda'

class BlockoutList extends React.Component {
  sortByDate = (a, b) => moment(a[0]).diff(moment(b[0]))

  blockoutsByDay = R.pipe(R.groupBy(b => b.range.start.clone().startOf('day').toISOString()),
                          R.toPairs,
                          R.sort(this.sortByDate))
  renderDays = _ => {
    const blockoutsWithDays = this.props.blockoutsWithDays.flat()
    return this.blockoutsByDay(blockoutsWithDays).map((pair, index) => {
      return (
        <div key={index}>
          <div className='day-heading'>
            {moment(pair[0]).format('dddd L')}
          </div>
          <div className='day-blockOuts'>
            {this.renderDay(pair[1])}
          </div>
        </div>
      )
    })
  }

  renderDay = day => {
    return R.sort(this.sortByDate, day).map((blockout, index) =>
      <Blockout blockout={blockout} key={index} />
    )
  }

  render () {
    return (
      <React.Fragment>
        {this.renderDays()}
      </React.Fragment>
    )
  }
}

BlockoutList.propTypes = {
  blockoutsWithDays: PropTypes.array
}
export default BlockoutList
