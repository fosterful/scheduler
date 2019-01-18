import blockoutsByDay from './blockoutsByDay'
import splitblockoutsWithDays from 'blockouts/helpers/splitBlockoutsByDay'
import expandRecurringBlockOuts from 'blockouts/helpers/expandRecurringBlockouts'
import moment from 'moment'

const notNormalizedBlockouts = [
  {
    'id': 131,
    'user_id': 1,
    'start_at': '2019-01-25T00:00:00.000-08:00',
    'end_at': '2019-01-25T23:59:59.999-08:00',
    'last_occurrence': null,
    'rrule': null,
    'exdate': [],
    'parent_id': null,
    'reason': null,
    'created_at': '2019-01-18T10:11:55.848-08:00',
    'updated_at': '2019-01-18T10:11:55.848-08:00'
  },
  {
    'id': 132,
    'user_id': 1,
    'start_at': '2019-01-28T00:00:00.000-08:00',
    'end_at': '2019-01-31T23:59:00.000-08:00',
    'last_occurrence': null,
    'rrule': null,
    'exdate': [],
    'parent_id': null,
    'reason': null,
    'created_at': '2019-01-18T10:12:14.811-08:00',
    'updated_at': '2019-01-18T10:12:14.811-08:00'
  },
  {
    'id': 129,
    'user_id': 1,
    'start_at': '2019-01-18T00:00:00.000-08:00',
    'end_at': '2019-01-18T23:59:59.999-08:00',
    'last_occurrence': null,
    'rrule': null,
    'exdate': [],
    'parent_id': null,
    'reason': null,
    'created_at': '2019-01-18T10:11:38.286-08:00',
    'updated_at': '2019-01-18T10:11:38.286-08:00'
  }
]

const blackouts = splitblockoutsWithDays(
  expandRecurringBlockOuts(notNormalizedBlockouts, moment('2019 01', 'YYYY MM')),
  moment('2019 01', 'YYYY MM')
)

describe('blockoutsByDay()', () => {
  test('it creates properly formatted days from a blockout', () => {
    const output = blockoutsByDay(blackouts)
    expect(output).toMatchSnapshot()
  })
})
