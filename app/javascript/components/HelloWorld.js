import React from "react"
import PropTypes from "prop-types"
class HelloWorld extends React.Component {
  render () {
    return (
      <React.Fragment>
        Welcome {this.props.email}, you are signed in. Your role is: {this.props.role}.
      </React.Fragment>
    );
  }
}

HelloWorld.propTypes = {
  email: PropTypes.string,
  role: PropTypes.string
};
export default HelloWorld
