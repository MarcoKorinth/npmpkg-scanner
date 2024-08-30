const request = require('request')

async function main() {
  const url = 'http://example.com/'

  const response = await request.get(url)
  console.log('request finished with status:', response.status)
}

main()
