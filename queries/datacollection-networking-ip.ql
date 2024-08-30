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

from JsonObject json, string suspiciousString, IPDService ipdService
where
  // check package.json
  exists(PackageJson manifest, string scriptName, IPDService ipds |
    json = manifest.getScripts() and
    suspiciousString = json.getPropStringValue(scriptName) and
    suspiciousString.matches("%" + ipds + "%") and
    ipdService = ipds
  )
  or
  // check code
  exists(StringLiteral str, IPDService ipds |
    str.toString().matches("%" + ipds + "%") and
    suspiciousString = str.toString() and
    ipdService = ipds
  )
select suspiciousString, "IP detection service: " + ipdService.toString() + "\n" + suspiciousString
