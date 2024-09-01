/**
 * @name Usage of ip detection webservice
 * @description Package detects the systems public ip address using a webservice
 * @kind problem
 * @id datacollection-networking-ip
 * @security-severity 5.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

class IPDService extends string {
  IPDService() { this in ["ipconfig.io", "ifconfig.me"] }
}

from DbLocation loc, string suspiciousString, IPDService ipdService
where
  // check package.json
  exists(PackageJson manifest, string scriptName, IPDService ipds |
    suspiciousString = manifest.getScripts().getPropStringValue(scriptName) and
    suspiciousString.matches("%" + ipds + "%") and
    ipdService = ipds and
    loc = manifest.getLocation()
  )
  or
  // check code
  exists(StringLiteral str, IPDService ipds |
    str.toString().matches("%" + ipds + "%") and
    suspiciousString = str.toString() and
    ipdService = ipds and
    loc = str.getLocation()
  )
select loc, "// IP detection service: " + ipdService.toString() + "\n" + suspiciousString
