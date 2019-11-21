import React from "react";
import NeedsPickerContext from "needsPicker/contexts/picker";
import PropTypes from "prop-types";
import DayPicker from "react-day-picker";
import "react-day-picker/lib/style.css";

const Calendar = () => (
  <NeedsPickerContext.Consumer>
    {({ setCalendarMonth }) => <DayPicker onMonthChange={setCalendarMonth} />}
  </NeedsPickerContext.Consumer>
);

export default Calendar;
