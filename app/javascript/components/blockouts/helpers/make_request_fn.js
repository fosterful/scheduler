import snakecaseKeys from 'snakecase-keys'

const makeRequestFn = authenticity_token => {
  return async ({ url, method, data }) => {
    const response = await fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': authenticity_token
      },
      body: JSON.stringify(snakecaseKeys(data))
    })
    
    if (response.status >= 200 && response.status < 300) {
      data = await response.json()
      return { success: true, data: data }
    } else if (response.status === 422) {
      const { error } = await response.json()
      return { success: false, error: error }
    } else {
      const error = new Error(response.statusText)
      error.response = response
      throw error
    }
  }
}


export default makeRequestFn