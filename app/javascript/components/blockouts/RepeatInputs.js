import React from "react"
import PropTypes from "prop-types"
import BlockoutFormContext from './blockout-form-context'


class RepeatInputs extends React.Component {
  render () {
    return (
      <BlockoutFormContext.Consumer>
        {({ inputs: { }, setFormInputs }) => (
          <div className="grid-x">
            <div className="cell small-3">Every</div>
            <div className="cell small-3">Frequency</div>
            <div className="cell small-3">Week/month</div>
            <div className="cell small-3">Until</div>
          </div>
        )}
      </BlockoutFormContext.Consumer>
    )
  }
}

export default RepeatInputs
