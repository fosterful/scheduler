import React from "react"
import PropTypes from "prop-types"

class EditBlockoutModal extends React.Component {
  render () {
    return (
      <React.Fragment>
        Blockout: { JSON.stringify(this.props.data.blockout) }
      </React.Fragment>
    )
  }
}

EditBlockoutModal.propTypes = {
  data: PropTypes.object
}

export default EditBlockoutModal
