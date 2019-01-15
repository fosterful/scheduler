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

  submit = _ => {
    console.log(snakecaseKeys(this.state.inputs))
    fetch('/users/123/blockouts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(snakecaseKeys(this.state.inputs))
    })
  }

  render () {
    return (
      <SchedulerContext.Consumer>
        {({ setModalInfo }) => (
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
                  <button className='button primary' onClick={this.submit}>Save</button>
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
