/**
 * @name Shellscript in preinstall hook
 * @description Preinstall hook of the package executes an sh command
 * @kind problem
 * @id process-nodehook-preinstall-sh
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
  scriptCode.indexOf("sh") = 0
select json, scriptCode
