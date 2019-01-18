import React from 'react'
import PropTypes from 'prop-types'
import Blockout from 'blockouts/Blockout'
import moment from 'moment'
import { sort } from 'ramda'
import blockoutsByDay from './blockoutsByDay'

class BlockoutList extends React.Component {
  render () {
    return (
      <React.Fragment>
        {
          blockoutsByDay(this.props.blockoutsWithDays).map(([heading, days], index) =>
            <div key={index}>
              <div className='day-heading'>
                {moment(heading).format('dddd L')}
              </div>
              <div className='day-blockOuts'>
                {
                  sort(this.sortByDate, days).map((blockout, index) =>
                    <Blockout blockout={blockout} key={index} />
                  )
                }
              </div>
            </div>
          )
        }
      </React.Fragment>
    )
  }
}

BlockoutList.propTypes = {
  blockoutsWithDays: PropTypes.array
}
export default BlockoutList
