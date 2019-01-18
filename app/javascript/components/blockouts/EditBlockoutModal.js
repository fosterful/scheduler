import React from 'react'
import PropTypes from 'prop-types'
import SchedulerContext from 'components/blockouts/contexts/scheduler'
import BlockoutFormContext from 'components/blockouts/contexts/blockoutForm'
import DateTimePicker from './DateTimePicker'
import { RRule, RRuleSet, rrulestr } from 'rrule'
import ReasonInput from './ReasonInput'
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
    return { ...inputs, endAt: (inputs.endAt || moment(inputs.startAt).endOf('day').toDate()) }
  }

  blockoutData = _ => {
    const { state: { blockout, blockoutId } } = this
    const inputs = this.inputsWithDefaults()
    return { ...inputs, id: blockoutId, rrule: blockout.rrule }
  }

  setError = errorMsg => this.setState(state => ({ errorMsg: errorMsg }))

  createBlockout = data => {
    const { context: { makeRequest } } = this
    return makeRequest({ url: `/blockouts.json`, method: 'post', data: { blockout: data } })
  }

  updateBlockout = data => {
    const { state: { blockoutId }, context: { makeRequest } } = this
    return makeRequest({ url: `/blockouts/${blockoutId}.json`, method: 'PUT', data: { blockout: data } })
  }

  deleteBlockout = _ => {
    const { state: { blockoutId }, context: { makeRequest } } = this
    return makeRequest({ url: `/blockouts/${blockoutId}.json`, method: 'DELETE' })
  }

  updateHandler = async _ => {
    const { state: { selectedRecurrenceOption, blockout }, context: { updateBlockoutsState, setModalInfo } } = this

    let result
    let error
    const updatedBlockouts = []
    // TODO: Refactor me :-)
    switch (selectedRecurrenceOption) {
      case 'one':
        // Add Exclusion
        result = await this.updateBlockout(this.excludeBlockoutParams())
        if (result.success) {
          updatedBlockouts.push(result.data)
        } else { error = result.error; break }
        // Create new Blockout
        result = await this.createBlockout(this.inputsWithDefaults())
        if (result.success) {
          updatedBlockouts.push(result.data)
        } else { error = result.error }
        break
      case 'future':
        // Update parent rrule until
        result = await this.updateBlockout(this.excludefutureBlockoutsParams())
        if (result.success) {
          updatedBlockouts.push(result.data)
        } else { error = result.error; break }
        // Create new Blockout with recurrence
        result = await this.createBlockout({ ...this.inputsWithDefaults(), rrule: blockout.rrule })
        if (result.success) {
          updatedBlockouts.push(result.data)
        } else { error = result.error }
        break
      case 'all':
        result = await this.updateBlockout(this.inputsWithDefaults())
        if (result.success) {
          updatedBlockouts.push(result.data)
        } else { error = result.error }
        break
    }

    if (error) {
      this.setError(error)
    } else {
      updateBlockoutsState(updatedBlockouts)
      setModalInfo({})
    }
  }

  deleteHandler = async _ => {
    const { state: { selectedRecurrenceOption, blockoutId }, context: { updateBlockoutsState, removeBlockoutFromState, setModalInfo } } = this
    let result
    switch (selectedRecurrenceOption) {
      case 'one':
        result = await this.updateBlockout(this.excludeBlockoutParams())
        break
      case 'future':
        result = await this.updateBlockout(this.excludefutureBlockoutsParams())
        break
      case 'all':
        result = await this.deleteBlockout()
        break
    }

    if (result.success) {
      selectedRecurrenceOption === 'all'
        ? removeBlockoutFromState(blockoutId) : updateBlockoutsState([result.data])
      setModalInfo({})
    } else {
      this.setError(result.error)
    }
  }

  excludeBlockoutParams = _ => {
    const { state: { blockout } } = this
    return { exdate: blockout.exdate.concat([blockout.start_at]) }
  }

  excludefutureBlockoutsParams = _ => {
    const { state: { blockout } } = this
    const options = RRule.parseString(blockout.rrule)
    options.until = moment(blockout.start_at).subtract(1, 'day').startOf('day').toDate()
    const newRule = new RRule(options)
    return { rrule: newRule.toString().replace('RRULE:', '') }
  }

  selectRecurrenceOption = option => {
    return _ => this.setState(state => ({ selectedRecurrenceOption: option }))
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
          <div className='group'>
            <div className='float-left'>
              <button className='hollow button alert' onClick={this.deleteHandler}>Delete</button>
            </div>
            <div className='float-right'>
              <button className='clear button secondary' onClick={setModalInfo.bind(this, {})}>Cancel</button>
              <button className='button primary' onClick={this.updateHandler}>Save</button>
            </div>
          </div>
        </div>
      </BlockoutFormContext.Provider>
    )
  }
}

EditBlockoutModal.contextType = SchedulerContext
export default EditBlockoutModal
