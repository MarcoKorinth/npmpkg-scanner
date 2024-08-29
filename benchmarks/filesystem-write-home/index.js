const fs = require('node:fs');
const os = require('os')

try {
  const homedir = os.homedir();
  fs.appendFileSync(`${homedir}/test.txt`, 'Hello World', 'utf-8')
  console.log('File created successfully');
} catch (err) {
  console.error('Error! Could not write to home directory');
}
