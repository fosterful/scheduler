import moment from 'moment'
import { RRule, RRuleSet, rrulestr } from 'rrule'

const expandRecurringBlockOuts = blockouts => {
  const recurringBlockoutParents = blockouts.filter(b => b.rrule)
  const expanded = recurringBlockoutParents.map(parent => {
    const rruleSet = new RRuleSet()
    const options = RRule.parseString(parent.rrule)
    options.dtstart = new Date(parent.start_at)
    rruleSet.rrule(new RRule(options))
    parent.exdate.forEach(exdate => rruleSet.exdate(new Date(exdate)))
    const occurenceDates = rruleSet.between(moment().startOf('month').toDate(), moment().endOf('month').toDate())
    return occurenceDates.map(o => {
      const diff = moment(parent.end_at).diff(moment(parent.start_at))
      const end_at = moment(o).add('milliseconds', diff)
      return {...parent, ...{ id: null, parent_id: parent.id, start_at: moment(o).format(), end_at: end_at.format() }}
    })
  })
  return blockouts.filter(b => !b.rrule).concat(expanded.flat())
}

export default expandRecurringBlockOuts