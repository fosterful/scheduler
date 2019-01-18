import React from 'react'
import SchedulerContext from 'blockouts/contexts/scheduler'
import BlockoutFormContext from 'blockouts/contexts/blockoutForm'
import DateTimePicker from 'blockouts/DateTimePicker'
import { RRule } from 'rrule'
import ReasonInput from 'blockouts/ReasonInput'
import Errors from 'blockouts/Errors'
import RecurrenceOptions from 'blockouts/RecurrenceOptions'
import moment from 'moment'
import getDatesBetweenRruleSet from 'blockouts/helpers/get_dates_between_rrule_set'
import { isEmpty } from 'ramda'

class EditBlockoutModal extends React.Component {
  constructor(props) {
    super(props)
    const { data: { blockout } } = props
    this.state = {
      blockout: blockout,
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
    const { state: { inputs } } = this
    return { ...inputs, endAt: (inputs.endAt || moment(inputs.startAt).endOf('day').toDate()) }
  }

  setError = errorMsg => this.setState(state => ({ errorMsg: errorMsg }))

  createBlockout = data => {
    const { context: { makeRequest } } = this
    return makeRequest({ url: `/blockouts.json`, method: 'post', data: { blockout: data } })
  }

  updateBlockout = data => {
    const { state: { blockout: { parent_id } }, context: { makeRequest } } = this
    return makeRequest({ url: `/blockouts/${parent_id}.json`, method: 'PUT', data: { blockout: data } })
  }

  deleteBlockout = _ => {
    const { state: { blockout: { parent_id } }, context: { makeRequest } } = this
    return makeRequest({ url: `/blockouts/${parent_id}.json`, method: 'DELETE' })
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
    const { state: { selectedRecurrenceOption, blockout }, context: { updateBlockoutsState, removeBlockoutFromState, setModalInfo, getParentBlockoutByID } } = this
    const parent = getParentBlockoutByID(blockout.parent_id)

    let result
    let allPossibleDates
    switch (selectedRecurrenceOption) {
      case 'one':
        const excludeBlockoutParams = this.excludeBlockoutParams()

        allPossibleDates = getDatesBetweenRruleSet({
          rrule: parent.rrule,
          startAt: parent.start_at,
          exdates: excludeBlockoutParams.exdate,
          lowerBound: new Date(parent.start_at),
          upperBound: moment(parent.start_at).add(3, 'years').endOf('day').toDate()
        })

         console.log(isEmpty(allPossibleDates) ? "It's gonna blow!" : 'All good in the hood')

        result = await this.updateBlockout(excludeBlockoutParams)
        break
      case 'future':
        const excludefutureBlockoutsParams = this.excludefutureBlockoutsParams()

        allPossibleDates = getDatesBetweenRruleSet({
          rrule: excludefutureBlockoutsParams.rrule,
          startAt: parent.start_at,
          exdates: parent.exdate,
          lowerBound: new Date(parent.start_at),
          upperBound: moment(parent.start_at).add(3, 'years').endOf('day').toDate()
        })

        console.log(isEmpty(allPossibleDates) ? "It's gonna blow!" : 'All good in the hood')

        result = await this.updateBlockout(excludefutureBlockoutsParams)
        break
      case 'all':
        result = await this.deleteBlockout()
        break
    }

    if (result.success) {
      selectedRecurrenceOption === 'all'
        ? removeBlockoutFromState(blockout.parent_id) : updateBlockoutsState([result.data])
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
