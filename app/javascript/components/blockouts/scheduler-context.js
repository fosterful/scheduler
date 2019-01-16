import React from "react"

export default React.createContext({
  calendarMonth: null,
  setCalendarMonth: _ => {},
  modalInfo: {},
  setModalInfo: _ => {},
  authenticity_token: '',
  updateBlockouts: _ => {}
})