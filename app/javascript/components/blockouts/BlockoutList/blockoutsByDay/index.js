import { pipe, groupBy, toPairs, sort } from 'ramda'
import sortByDate from 'blockouts/BlockoutList/sortByDate'

const blockoutsByDay = pipe(
  groupBy(b => b.range.start.clone().startOf('day').toISOString()),
  toPairs,
  sort(sortByDate)
)

export default blockoutsByDay
