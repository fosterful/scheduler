import React from "react"
import PropTypes from "prop-types"
import SchedulerContext from './scheduler-context'
import BlockoutFormContext from './blockout-form-context'
import DateTimePicker from "./DateTimePicker";
import ReasonInput from "./ReasonInput";
import RepeatInputs from "./RepeatInputs";
import Errors from './Errors'
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

  submit = async _ => {
    const { state: { inputs }, context: { setModalInfo, makeRequest, updateBlockouts } } = this
    const inputsWithDefaults = {...inputs, endAt: (inputs.endAt || moment(inputs.startAt).endOf('day').toDate())}
    const data = { blockout: inputsWithDefaults }
    const result = await makeRequest({ url: '/blockouts.json', method: 'POST', data: data})

    if (result.success) {
      updateBlockouts([result.data])
      setModalInfo({})
    } else {
      this.setState(state => ({errorMsg: result.error}))
    }
  }

  render () {
    console.log(this.state)
    const { state: { errorMsg }, context: { setModalInfo } } = this
    return (
      <BlockoutFormContext.Provider value={this.state}>
        <div className='blockout-modal-header'>New Blockout Date</div>
        <div className='blockout-modal-inner-content'>
          <Errors errorMsg={errorMsg} />
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
              <button className='button primary' onClick={ this.submit }>Save</button>
            </div>
          </div>
        </div>
      </BlockoutFormContext.Provider>
    )
  }
}

NewBlockoutModal.contextType = SchedulerContext
export default NewBlockoutModal
