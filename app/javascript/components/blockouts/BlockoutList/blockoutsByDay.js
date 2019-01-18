import { pipe, groupBy, toPairs, sort } from 'ramda'
import moment from 'moment'

const blockoutsByDay = pipe(
  groupBy(b => b.range.start.clone().startOf('day').toISOString()),
  toPairs,
  sort((a, b) => moment(a[0]).diff(moment(b[0])))
)

export default blockoutsByDay
