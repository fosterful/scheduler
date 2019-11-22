import React from "react";
import PropTypes from "prop-types";
import NeedsPickerContext from "needsPicker/contexts/picker";
import Calendar from "needsPicker/Calendar";
import "react-day-picker/lib/style.css";

class AddNeedsPicker extends React.Component {
  setCalendarMonth = calendarMonth =>
    this.setState({
      calendarMonth: moment(calendarMonth).startOf("month")
    });

  state = {
    calendarMonth: moment().startOf("month"),
    setCalendarMonth: this.setCalendarMonth
  };

  render() {
    const {
      state: { calendarMonth }
    } = this;
    return (
      <NeedsPickerContext.Provider
        value={{
          ...this.state,
          ...{ authenticityToken: this.props.authenticity_token }
        }}
      >
        <React.Fragment>
          <Calendar />
        </React.Fragment>
      </NeedsPickerContext.Provider>
    );
  }
}

AddNeedsPicker.propTypes = {};
export default AddNeedsPicker;
