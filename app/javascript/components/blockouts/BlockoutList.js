import React from "react"
import PropTypes from "prop-types"
import Blockout from "./Blockout"
import moment from 'moment'
import * as R from 'ramda'

class BlockoutList extends React.Component {
  blockoutsByDays = _ => {
    const sortFunc = (a, b) => moment.utc(a[0]).diff(moment.utc(b[0])) 
    return R.pipe(R.groupBy(b => b.range.start.clone().startOf('day').toISOString()),
      R.toPairs,
      R.sort(sortFunc))(this.props.blockoutsWithDays.flat())
  }

  render () {
    const blockoutItems = this.blockoutsByDays().map((pair, index) => {
      console.log(pair[0])
      return (
        <li key={index}>{pair[0]}</li>
      )
    })
    // const blockoutItems = this.props.blockoutsWithDays.flat().map((blockoutWithDays, index) =>
    //   <Blockout blockoutWithDays={blockoutWithDays} key={index} />
    // )
    return (
      <React.Fragment>
        <ul>{blockoutItems}</ul>
      </React.Fragment>
    )
  }
}

BlockoutList.propTypes = {
  blockoutsWithDays: PropTypes.array
}
export default BlockoutList
