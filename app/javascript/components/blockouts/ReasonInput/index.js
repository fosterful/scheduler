import React from 'react'
import BlockoutFormContext from 'blockouts/contexts/blockoutForm'

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
