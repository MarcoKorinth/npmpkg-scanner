const { exec } = require('child_process');

exec('echo maliciousString > maliciousFile.txt')
