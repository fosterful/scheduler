import moment from 'moment'

const bindClick = ($el, getStateValue) =>
  $el.one('click', function (event) {
    updatePathAndClick.call(this, event, getStateValue)
  })

const updatePathAndClick = function (event, getStateValue) {
  event.preventDefault()
  global.hideDateRangeErrorMessage()

  const $this = $(this)
  const url = new URL($this.attr('href'))
  const startDate = $('#filter_start').val()
  const endDate = $('#filter_end').val()

  if (startDate && endDate && moment(startDate).isAfter(endDate)) {
    global.displayDateRangeErrorMessage('Start date must be before end date')

    return bindClick($this, getStateValue)
  }

  if (startDate) url.searchParams.set('start_date', startDate)
  if (endDate) url.searchParams.set('end_date', endDate)

  if (getStateValue)
    url.searchParams.set(
      'state',
      $this.closest('.card').find('select option:selected').text()
    )

  window.location = url

  bindClick($this, getStateValue)
}

$(document).ready(function () {
  bindClick($('.get_report'), false)

  bindClick($('.get_report_with_state'), true)
})
