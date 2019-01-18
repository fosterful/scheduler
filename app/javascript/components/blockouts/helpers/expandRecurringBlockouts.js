import moment from 'moment'
import dateIsWithinMonth from 'blockouts/helpers/dateIsWithinMonth'
import { RRule, RRuleSet } from 'rrule'

const expandRecurringBlockOuts = (blockouts, calendarMonth) => {
  const recurringBlockoutParents = blockouts.filter(b => b.rrule)
  const expanded = recurringBlockoutParents.map(parent => {
    const rruleSet = new RRuleSet()
    const options = RRule.parseString(parent.rrule)
    options.dtstart = new Date(parent.start_at)
    rruleSet.rrule(new RRule(options))
    parent.exdate.forEach(exdate => rruleSet.exdate(new Date(exdate)))
    const lowerBound = calendarMonth.clone().subtract(1, 'month').toDate()
    const upperBound = calendarMonth.clone().add(1, 'month').endOf('month').toDate()
    return rruleSet.between(lowerBound, upperBound).map(o => {
      const diff = moment(parent.end_at).diff(moment(parent.start_at))
      const end_at = moment(o).add(diff, 'milliseconds')
      return { ...parent, ...{ id: null, parent_id: parent.id, start_at: moment(o).format(), end_at: end_at.format() } }
    })
  })
  return blockouts.filter(b => dateIsWithinMonth(b.start_at, calendarMonth) && !b.rrule).concat(expanded.flat())
}

export default expandRecurringBlockOuts
