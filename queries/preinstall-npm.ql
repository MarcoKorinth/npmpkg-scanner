/**
 * @name preinstall-npm
 * @description Detects preinstall script with npm command
 * @kind problem
 * @id preinstall-npm
 * @security-severity 7.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

from JsonObject json, string scriptName, string scriptCode
where
  exists(PackageJson manifest | json = manifest.getScripts()) and
  scriptName = "preinstall" and
  scriptCode = json.getPropStringValue(scriptName) and
  scriptCode.indexOf("npm") = 0
select json, scriptCode
