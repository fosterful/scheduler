import React from "react"
import PropTypes from "prop-types"
import Blockout from "./Blockout"

class BlockoutList extends React.Component {
  render () {
    const blockoutItems = this.props.blockoutsByDay.flat().map((blockout, index) =>
      <Blockout blockout={blockout} key={index} />
    )
    return (
      <React.Fragment>
        <ul>{blockoutItems}</ul>
      </React.Fragment>
    )
  }
}

BlockoutList.propTypes = {
  blockoutsByDay: PropTypes.array
}
export default BlockoutList
