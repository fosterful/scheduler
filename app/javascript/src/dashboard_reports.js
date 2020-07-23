const updatePathAndClick = function (event, getStateValue) {
  event.preventDefault()

  const $this = $(this)
  const url = new URL($this.attr('href'))
  const startDate = $('#filter_start').val()
  const endDate = $('#filter_end').val()

  if (startDate) url.searchParams.set('start_date', startDate)
  if (endDate) url.searchParams.set('end_date', endDate)
  if (getStateValue)
    url.searchParams.set(
      'state',
      $this.closest('.card').find('select option:selected').text()
    )

  window.location = url

  $this.one('click', updatePathAndClick)
}

$(document).ready(function () {
  $('.get_report').one('click', function (event) {
    updatePathAndClick.call(this, event, false)
  })

  $('.get_report_with_state').one('click', function (event) {
    updatePathAndClick.call(this, event, true)
  })
})
