import React from 'react'
import PropTypes from 'prop-types'
import DateTime from 'react-datetime'

class AddNeedsPicker extends React.Component {
  render() {
    return (
      <DateTime
        dateFormat='DD-MM-YYYY'
        inputProps={{ name: 'need[start_at]' }}
        timeConstraints={{ minutes: { step: 15 } }}
      />
    )
  }
}

AddNeedsPicker.propTypes = {}
export default AddNeedsPicker
