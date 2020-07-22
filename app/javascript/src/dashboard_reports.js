const updatePathAndClick = function (event) {
  event.preventDefault()

  const url = new URL($(this).attr('href'))
  const startDate = $('#filter_start').val()
  const endDate = $('#filter_end').val()

  if (startDate) url.searchParams.set('start_date', startDate)
  if (endDate) url.searchParams.set('end_date', endDate)

  window.location = url

  $('#get_report').one('click', updatePathAndClick)
}

$(document).ready(function () {
  $('#get_report').one('click', updatePathAndClick)
})
