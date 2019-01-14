import React from "react"
import PropTypes from "prop-types"

class NewBlockoutModal extends React.Component {
  render () {
    return (
      <React.Fragment>
        New blockout: { JSON.stringify(this.props.data) }
      </React.Fragment>
    )
  }
}

NewBlockoutModal.propTypes = {
  data: PropTypes.object
}

export default NewBlockoutModal
