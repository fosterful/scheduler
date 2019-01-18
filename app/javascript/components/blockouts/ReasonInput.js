import React from 'react'
import PropTypes from 'prop-types'
import BlockoutFormContext from './blockout-form-context'

class ReasonInput extends React.Component {
  render () {
    return (
      <BlockoutFormContext.Consumer>
        {({ inputs: { reason }, setFormInputs }) => (
          <div className='grid-x'>
            <div className='cell'>
              <label>
                Reason
                <input type='text' value={reason || ''} onChange={event => setFormInputs({ reason: event.target.value })} />
              </label>
            </div>
          </div>
        )}
      </BlockoutFormContext.Consumer>
    )
  }
}

export default ReasonInput
