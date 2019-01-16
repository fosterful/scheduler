import React from "react"
import PropTypes from "prop-types"
import SchedulerContext from './scheduler-context'
import BlockoutFormContext from './blockout-form-context'
import DateTimePicker from "./DateTimePicker";
import { RRule, RRuleSet, rrulestr } from 'rrule'
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

  inputsWithDefaults = _ => {
    const { state: { blockoutId, inputs } } = this
    return {...inputs, endAt: (inputs.endAt || moment(inputs.startAt).endOf('day').toDate())}
  }

  blockoutData = _ => {
    const { state: { blockout, blockoutId } } = this
    const inputs = this.inputsWithDefaults()
    return { ...inputs, id: blockoutId, rrule: blockout.rrule }
  }

  setError = errorMsg => this.setState(state => ({errorMsg: errorMsg}))

  updateBlockout = data => {
    const { state: { blockoutId }, context: { makeRequest } } = this
    return makeRequest({ url: `/blockouts/${blockoutId}.json`, method: 'PUT', data: { blockout: data } })
  }

  deleteBlockout = _ => {
    const { state: { blockoutId }, context: { makeRequest } } = this
    return makeRequest({ url: `/blockouts/${blockoutId}.json`, method: 'DELETE'})
  }

  updateHandler = _ => {
    const { state: { selectedRecurrenceOption } } = this
    switch(selectedRecurrenceOption) {
      case 'one':
        // Add Exclusion
        // Create new Blockout
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

  deleteHandler = async _ => {
    const { state: { selectedRecurrenceOption, blockoutId }, context: { updateBlockoutsState, removeBlockoutFromState, setModalInfo } } = this
    let result
    switch(selectedRecurrenceOption) {
      case 'one':
        result = await this.updateBlockout(this.excludeBlockoutParams())
        break;
      case 'future':
        result = await this.updateBlockout(this.excludefutureBlockoutsParams())
        break;
      case 'all':
        result = await this.deleteBlockout()
        break;
    }

    if (result.success) {
      selectedRecurrenceOption === 'all' ?
        removeBlockoutFromState(blockoutId) : updateBlockoutsState([result.data])
      setModalInfo({})
    } else {
      this.setError(result.error)
    }
  }

  excludeBlockoutParams = _ => {
    const { state: { blockout } } = this
    return { exdate: blockout.exdate.concat([blockout.range.start.toDate()]) }
  }

  excludefutureBlockoutsParams = _ => {
    const { state: { blockout } } = this
    const options = RRule.parseString(blockout.rrule)
    options.until = blockout.range.start.clone().subtract(1, 'day').startOf('day').toDate()
    const newRule = new RRule(options)
    return { rrule: newRule.toString().replace('RRULE:', '') }
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
