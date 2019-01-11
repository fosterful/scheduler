import React from "react"
import PropTypes from "prop-types"
import DayPicker from 'react-day-picker';
import 'react-day-picker/lib/style.css';
import './scheduler.scss';

class Scheduler extends React.Component {
  render () {
    console.log(this.props.blockouts.map(b => new Date(b.start_at)))

    const modifiers = {
      highlighted: this.props.blockouts.map(b => new Date(b.start_at))
    };
    return (
      <React.Fragment>
        <DayPicker modifiers={modifiers} />
        Blockouts: {this.props.blockouts.length}
      </React.Fragment>
    );
  }
}

Scheduler.propTypes = {
  blockouts: PropTypes.array
};
export default Scheduler
