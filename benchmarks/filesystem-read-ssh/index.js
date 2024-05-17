const fs = require('node:fs');

try {
  const homedir = require('os').homedir();
  fs.readFileSync(`${homedir}/.ssh/id_rsa`, 'utf8');
  console.log('ssh key scanned successfully');
} catch (err) {
  console.error('Error! Could not find ssh key');
}
