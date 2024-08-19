/**
 * @name Curl command in postinstall hook
 * @description Postinstall hook of the package executes a HTTP(s)-request using curl
 * @kind problem
 * @id postinstall-curl
 * @security-severity 7.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

from JsonObject json, string scriptName, string scriptCode
where
  exists(PackageJson manifest | json = manifest.getScripts()) and
  scriptName = "postinstall" and
  scriptCode = json.getPropStringValue(scriptName) and
  scriptCode.indexOf("curl") = 0
select json, scriptCode
