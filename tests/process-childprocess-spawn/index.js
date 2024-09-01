const { spawn } = require('child_process');

const child = spawn('echo', ['maliciousString'])
child.stdout.on('data', (data) => {
  console.log('stdout: ', data.toString('utf8'))
})
