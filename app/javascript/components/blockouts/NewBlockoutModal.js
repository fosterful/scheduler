import React from "react"
import PropTypes from "prop-types"
import SchedulerContext from './scheduler-context'
import BlockoutFormContext from './blockout-form-context'
import DateTimePicker from "./DateTimePicker";
import ReasonInput from "./ReasonInput";
import RepeatInputs from "./RepeatInputs";

class NewBlockoutModal extends React.Component {
  setFormInputs = value => {
    this.setState(state => ({ inputs: { ...this.state.inputs, ...value } }))
  }

  state = {
    inputs: { fromDate: new Date(), fromTime: '00:00', toTime: '23:59', reason: ''},
    setFormInputs: this.setFormInputs
  }

  render () {
    console.log(this.state.inputs)
    return (
      <SchedulerContext.Consumer>
        {({ setModalInfo }) => (
          <BlockoutFormContext.Provider value={this.state}>
            <div className='blockout-modal-header'>New Blockout</div>
            <div className='blockout-modal-inner-content'>
              <DateTimePicker />
              <RepeatInputs />
              <ReasonInput />
            </div>
            <div className='blockout-modal-footer'>
              <div className="group">
                <div className="float-right">
                  <button className='clear button secondary' onClick={ setModalInfo.bind(this, {}) }>Cancel</button>
                  <button className='button primary'>Save</button>
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
