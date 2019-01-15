import React from "react"
import PropTypes from "prop-types"
import snakecaseKeys from 'snakecase-keys'
import SchedulerContext from './scheduler-context'
import BlockoutFormContext from './blockout-form-context'
import DateTimePicker from "./DateTimePicker";
import ReasonInput from "./ReasonInput";
import RepeatInputs from "./RepeatInputs";
import moment from 'moment'

class NewBlockoutModal extends React.Component {
  setFormInputs = value => {
    this.setState(state => ({ inputs: { ...this.state.inputs, ...value } }))
  }

  state = {
    inputs: {
      startAt: moment().startOf('day').toDate(),
    },
    setFormInputs: this.setFormInputs
  }

  submit = async (authenticity_token) => {
    response = await fetch('/blockouts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': authenticity_token
      },
      body: JSON.stringify({ blockout: snakecaseKeys(this.state.inputs) })
    })
    console.log(response)
  }

  render () {
    return (
      <SchedulerContext.Consumer>
        {({ setModalInfo, authenticity_token }) => (
          <BlockoutFormContext.Provider value={this.state}>
            <div className='blockout-modal-header'>New Blockout</div>
            <div className='blockout-modal-inner-content'>
              <DateTimePicker />
              <hr />
              <RepeatInputs />
              <hr />
              <ReasonInput />
            </div>
            <div className='blockout-modal-footer'>
              <div className="group">
                <div className="float-right">
                  <button className='clear button secondary' onClick={ setModalInfo.bind(this, {}) }>Cancel</button>
                  <button className='button primary' onClick={this.submit.bind(this, authenticity_token)}>Save</button>
                </div>
              </div>
            </div>
          </BlockoutFormContext.Provider>
        )}
      </SchedulerContext.Consumer>
    )
  }
}

export default NewBlockoutModal
