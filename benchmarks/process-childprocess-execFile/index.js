const { execFile } = require('child_process');

const child = execFile(`${__dirname}/maliciousScript.sh`)
child.stdout.on('data', (data) => {
  console.log('stdout:', data.toString('utf8'))
})
