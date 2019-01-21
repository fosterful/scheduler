const sortByDate = (a, b) => moment(a[0]).diff(moment(b[0]))

export default sortByDate
