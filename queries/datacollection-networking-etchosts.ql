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

from DbLocation loc, string suspiciousString
where
  // check package.json
  exists(PackageJson manifest, string scriptName |
    suspiciousString = manifest.getScripts().getPropStringValue(scriptName) and
    suspiciousString.matches("%/etc/hosts%") and
    loc = manifest.getLocation()
  )
  or
  // check code
  exists(StringLiteral str |
    suspiciousString = str.toString() and
    suspiciousString.matches("%/etc/hosts%") and
    loc = str.getLocation()
  )
select loc, suspiciousString
