import React from "react"
import PropTypes from "prop-types"

class Modal extends React.Component {
  render () {
    return (
      <React.Fragment>
        <div style={{display: this.props.info ? 'block' : 'none'}}>I'm a modal</div>
      </React.Fragment>
    )
  }
}

Modal.propTypes = {
  info: PropTypes.object
}

export default Modal
