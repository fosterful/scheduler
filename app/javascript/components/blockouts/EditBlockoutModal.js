import React from "react"
import PropTypes from "prop-types"
import SchedulerContext from './scheduler-context'
import BlockoutFormContext from './blockout-form-context'
import DateTimePicker from "./DateTimePicker";
import ReasonInput from "./ReasonInput";
import Errors from './Errors'
import RecurrenceOptions from './recurrence_options'
import moment from 'moment'

class EditBlockoutModal extends React.Component {
  constructor(props) {
    super(props)
    const { data: { blockout } } = props
    this.state = {
      blockout: blockout,
      blockoutId: blockout.id || blockout.parent_id,
      selectedRecurrenceOption: blockout.rrule ? 'one' : 'all',
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
    const { state: { blockoutId, inputs }, context: { setModalInfo, makeRequest, updateBlockouts } } = this
    const inputsWithDefaults = {...inputs, endAt: (inputs.endAt || moment(inputs.startAt).endOf('day').toDate())}
    const data = { blockout: inputsWithDefaults }
    const result = await makeRequest({ url: `/blockout/${blockoutId}.json`, method: 'PUT', data: data})

    if (result.success) {
      updateBlockouts([result.data])
      setModalInfo({})
    } else {
      this.setState(state => ({errorMsg: result.error}))
    }
  }

  deleteBlockout = async _ => {
    const { state: { blockoutId }, context: { setModalInfo, makeRequest, removeBlockout } } = this
    const result = await makeRequest({ url: `/blockouts/${blockoutId}.json`, method: 'DELETE'})
   
    if (result.success) {
      removeBlockout(blockoutId)
      setModalInfo({})
    } else {
      this.setState(state => ({errorMsg: result.error}))
    }
  }

  updateHandler = _ => {
    const { state: { selectedRecurrenceOption } } = this
    switch(selectedRecurrenceOption) {
      case 'one':
        // Add Exclusion
        // Create new Blockout
        console.log('update one')
        break;
      case 'future':
        // Update parent rrule until
        // Create new Blockout with recurrence
        console.log('update future')
        break;
      case 'all':
        // Update parent
        console.log('update all')
        break;
    }
  }

  deleteHandler = _ => {
    const { state: { selectedRecurrenceOption } } = this
    switch(selectedRecurrenceOption) {
      case 'one':
        // Add exclusion
        console.log('delete one')
        break;
      case 'future':
        // Update parent rrule until selected date
        console.log('delete future')
        break;
      case 'all':
        this.deleteBlockout()
        break;
    }
  }

  selectRecurrenceOption = option => {
    return _ => this.setState(state => ({ selectedRecurrenceOption: option})) 
  }

  render () {
    const { selectRecurrenceOption, state: { blockout, errorMsg, selectedRecurrenceOption }, context: { setModalInfo } } = this
    return (
      <BlockoutFormContext.Provider value={this.state}>
        <div className='blockout-modal-header'>Edit Blockout Date</div>
        <div className='blockout-modal-inner-content'>
          <Errors errorMsg={errorMsg} />
          <DateTimePicker />
          <hr />
          <ReasonInput />
          <hr />
          {blockout.rrule && 
            <RecurrenceOptions
              selectRecurrenceOption={selectRecurrenceOption}
              selectedRecurrenceOption={selectedRecurrenceOption}
            />
          }
        </div>
        <div className='blockout-modal-footer'>
          <div className="group">
            <div className="float-left">
              <button className='hollow button alert' onClick={ this.deleteHandler }>Delete</button>
            </div>
            <div className="float-right">
              <button className='clear button secondary' onClick={ setModalInfo.bind(this, {}) }>Cancel</button>
              <button className='button primary' onClick={ this.updateHandler }>Save</button>
            </div>
          </div>
        </div>
      </BlockoutFormContext.Provider>
    )
  }
}

EditBlockoutModal.contextType = SchedulerContext
export default EditBlockoutModal
