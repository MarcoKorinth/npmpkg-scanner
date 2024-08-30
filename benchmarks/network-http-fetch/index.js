async function main() {
  const response = await fetch('http://example.com/')
  console.log('request finished with status:', response.status)
}

main()
