/**
 * @name postinstall-node
 * @description Detects postinstall script with node command
 * @kind problem
 * @id postinstall-node
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
  scriptCode.indexOf("node") = 0
select json, scriptCode
