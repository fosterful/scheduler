import React from "react"
import PropTypes from "prop-types"
import moment from 'moment'

class Blockout extends React.Component {
  render () {
    return (
      <React.Fragment>
        <li>
          <small>
            {moment(this.props.blockout.range.start).format('Do, h:mm a')} - {moment(this.props.blockout.range.end).format('Do, h:mm a')}
          </small>
        </li>
      </React.Fragment>
    )
  }
}

Blockout.propTypes = {
  blockout: PropTypes.object
}
export default Blockout
