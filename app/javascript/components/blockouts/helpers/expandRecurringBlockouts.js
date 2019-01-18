import moment from 'moment'
import dateIsWithinMonth from 'blockouts/helpers/dateIsWithinMonth'
import getDatesBetweenRruleSet from 'blockouts/helpers/getDatesBetweenRruleSet'

const expandRecurringBlockOuts = (blockouts, calendarMonth) => {
  const recurringBlockoutParents = blockouts.filter(b => b.rrule)
  const expanded = recurringBlockoutParents.map(parent => {
    const dates = getDatesBetweenRruleSet({
      rrule: parent.rrule,
      startAt: parent.start_at,
      exdates: parent.exdate,
      lowerBound: calendarMonth.clone().subtract(1, 'month').toDate(),
      upperBound: calendarMonth.clone().add(1, 'month').endOf('month').toDate()
    })
    return dates.map(o => {
      const diff = moment(parent.end_at).diff(moment(parent.start_at))
      const end_at = moment(o).add(diff, 'milliseconds')
      return { ...parent, ...{ id: null, parent_id: parent.id, start_at: moment(o).format(), end_at: end_at.format() } }
    })
  })
  return blockouts.filter(b => dateIsWithinMonth(b.start_at, calendarMonth) && !b.rrule).concat(expanded.flat())
}

export default expandRecurringBlockOuts
