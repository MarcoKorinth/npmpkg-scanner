/**
 * @name preinstall-wget
 * @description Detects preinstall script with wget command
 * @kind problem
 * @id preinstall-wget
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
  scriptCode.indexOf("wget") = 0
select json, scriptCode
