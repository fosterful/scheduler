import moment from 'moment'


const dateIsWithinMonth = (date, calendarMonth) => {
  return moment(date).isBetween(calendarMonth, calendarMonth.clone().endOf('Month'), null, '[]')
}


export default dateIsWithinMonth