/**
 * @name Curl command in preinstall hook
 * @description Preinstall hook of the package executes a HTTP(s)-request using curl
 * @kind problem
 * @id process-nodehook-preinstall-curl
 * @security-severity 7.0
 * @problem.severity warning
 * @author Marco Korinth
 */

import javascript

from JsonObject json, string scriptName, string scriptCode
where
  exists(PackageJson manifest | json = manifest.getScripts()) and
  scriptName = "preinstall" and
  scriptCode = json.getPropStringValue(scriptName) and
  scriptCode.indexOf("curl") = 0
select json, scriptCode
