import React from 'react'
import PropTypes from 'prop-types'
import DateTime from 'react-datetime'

class AddNeedsPicker extends React.Component {
  render() {
    const {
      props: { startAt }
    } = this
    return (
      <DateTime
        defaultValue={(startAt && new Date(startAt)) || undefined}
        dateFormat='DD-MM-YYYY'
        inputProps={{ name: 'need[start_at]' }}
        timeConstraints={{ minutes: { step: 15 } }}
      />
    )
  }
}

AddNeedsPicker.propTypes = {
  startAt: PropTypes.string
}
export default AddNeedsPicker
