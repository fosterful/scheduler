import React from "react"
import PropTypes from "prop-types"
import SchedulerContext from './scheduler-context'
import BlockoutFormContext from './blockout-form-context'
import DateTimePicker from "./DateTimePicker";
import ReasonInput from "./ReasonInput";
import RepeatInputs from "./RepeatInputs";
import moment from 'moment'


class EditBlockoutModal extends React.Component {
  constructor(props) {
    super(props)
    const { data: { blockout } } = props
    this.state = {
      inputs: {
        startAt: new Date(blockout.start_at),
        endAt: new Date(blockout.end_at),
        reason: blockout.reason
      },
      setFormInputs: this.setFormInputs
    }
  }

  setFormInputs = value => {
    this.setState(state => ({ inputs: { ...this.state.inputs, ...value } }))
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

  Errors = _ => {
    const { state: { errorMsg } } = this
    if (!errorMsg) return null
    return (
      <div className="callout alert">
        Error: { errorMsg }
      </div>
    )
  }

  render () {
    console.log(this.state)
    const { Errors, context: { setModalInfo } } = this
    return (
      <BlockoutFormContext.Provider value={this.state}>
        <div className='blockout-modal-header'>New Blockout</div>
        <div className='blockout-modal-inner-content'>
          <Errors />
          <DateTimePicker />
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

EditBlockoutModal.contextType = SchedulerContext
export default EditBlockoutModal
