const axios = require('axios')

async function main() {
  const url = 'http://example.com/'

  // type 1:
  const response = await axios({
    url: url,
  })

  // type 2:
  const response2 = await axios.get(url)

  console.log('request 1 finished with status:', response.status)
  console.log('request 2 finished with status:', response2.status)
}

main()
