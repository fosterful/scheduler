import React from 'react'
import PropTypes from 'prop-types'
import Blockout from 'blockouts/Blockout'
import { sort } from 'ramda'
import blockoutsByDay from './blockoutsByDay'
import sortByDate from 'blockouts/BlockoutList/sortByDate'

const BlockoutList = ({ blockoutsWithDays }) =>
  <React.Fragment>
    {
      blockoutsByDay(blockoutsWithDays).map(([heading, days], index) =>
        <div key={index}>
          <div className='blockout-day-heading'>
            {moment(heading).format('dddd L')}
          </div>
          <div className='day-blockOuts'>
            {
              sort(sortByDate, days).map((blockout, index) =>
                <Blockout blockout={blockout} key={index} />
              )
            }
          </div>
        </div>
      )
    }
  </React.Fragment>

BlockoutList.propTypes = {
  blockoutsWithDays: PropTypes.array
}
export default BlockoutList
