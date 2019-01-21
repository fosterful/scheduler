import React from 'react'
import PropTypes from 'prop-types'
import SchedulerContext from 'blockouts/contexts/scheduler'

class Blockout extends React.Component {
  renderTime = _ => {
    const { blockout: { range: { start, end } } } = this.props
    const formatedStart = moment(start).format('h:mm a')
    const formatedEnd = moment(end).format('h:mm a')
    if (formatedStart === '12:00 am' && formatedEnd === '11:59 pm') {
      return 'All day'
    } else {
      return `${formatedStart} - ${formatedEnd}`
    }
  }

  renderReason = _ => {
    const { blockout: { reason } } = this.props
    return reason || 'no reason'
  }

  render () {
    const { blockout } = this.props
    return (
      <SchedulerContext.Consumer>
        {({ setModalInfo }) => (
          <div
            className='blockout-container'
            onClick={setModalInfo.bind(this, { component: 'EditBlockoutModal', data: { blockout: blockout } })}
          >
            Blockout Date<br />
            <div className='blockout-reason'>{this.renderReason()}</div>
            <div className='blockout-time'>{this.renderTime()}</div>
          </div>
        )}
      </SchedulerContext.Consumer>
    )
  }
}

Blockout.propTypes = {
  blockout: PropTypes.object
}
export default Blockout
