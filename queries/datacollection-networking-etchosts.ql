/**
 * @name Reference to /etc/hosts file
 * @description Package references the `/etc/hosts` file which is used to map hostnames to IP addresses
 * @kind problem
 * @id datacollection-networking-etchosts
 * @security-severity 5.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

from JsonObject json, string suspiciousString
where
  // check package.json
  exists(PackageJson manifest, string scriptName |
    json = manifest.getScripts() and
    suspiciousString = json.getPropStringValue(scriptName) and
    suspiciousString.matches("%/etc/hosts%")
  )
  or
  // check code
  exists(StringLiteral str |
    suspiciousString = str.toString() and
    suspiciousString.matches("%/etc/hosts%")
  )
select suspiciousString, suspiciousString
