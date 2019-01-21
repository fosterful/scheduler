import { RRule, RRuleSet } from 'rrule'

const getDatesBetweenRruleSet = ({ rrule, startAt, exdates, lowerBound, upperBound }) => {
    const rruleSet = new RRuleSet()
    const options = RRule.parseString(rrule)
    options.dtstart = new Date(startAt)
    rruleSet.rrule(new RRule(options))
    exdates.forEach(exdate => rruleSet.exdate(new Date(exdate)))
    return rruleSet.between(lowerBound, upperBound, true)
}

export default getDatesBetweenRruleSet
