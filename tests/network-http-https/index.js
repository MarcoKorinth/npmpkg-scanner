const https = require('node:https')

const url = 'https://example.com/'

https.get(url, (res) => {
  console.log('request finished with status:', res.statusCode)
  res.destroy()
})
