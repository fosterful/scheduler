import React from "react"

const Errors = ({ errorMsg }) => {
  if (!errorMsg) return null
  return (
    <div className="callout alert">
      Error: { errorMsg }
    </div>
  )
}

export default Errors