const fs = require('node:fs');
const os = require('os')

try {
  const homedir = os.homedir();
  const res = fs.readdirSync(homedir);
  console.log(res)
  console.log('Home directory read successfully');
} catch (err) {
  console.error('Error! Could not read home directory');
}
