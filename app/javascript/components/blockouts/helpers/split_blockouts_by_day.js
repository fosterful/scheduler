import Moment from 'moment'
import { extendMoment } from 'moment-range'
import dateIsWithinMonth from './date_is_within_month'

const moment = extendMoment(Moment)

const blockoutsWithDays = (blockouts, calendarMonth) => {
  return blockouts.map(blockout => {
    const start = moment(blockout.start_at)
    const end = moment(blockout.end_at)
    const range = moment.range(start, end)
    const interval = 'day'

    const dates = Array.from(range.by(interval))

    if (dates[dates.length - 1].isSame(range.end))
      { dates.pop() }

    const days = dates.map((date, index, dates) => {
      const rangeStart = date.clone()
      const rangeEnd = date.clone()

      if (index === 0 && dates.length > 1) {
        // Start of blockout
        rangeEnd.endOf(interval)
      } else if (dates.length - 1 === index) {
        // End of blockout
        dates.length > 1 && rangeStart.startOf(interval)
        rangeEnd.set({
          hour: end.get('hour'),
          minute: end.get('minute'),
          second: end.get('second')
        })
      } else {
        rangeStart.startOf(interval)
        rangeEnd.endOf(interval)
      }
      return { ...blockout, ...{ range: moment.range(rangeStart, rangeEnd) } }
    })
    return days.filter(b => dateIsWithinMonth(b.range.start, calendarMonth))
  })
}

export default blockoutsWithDays
