/**
 * @name Bashscript in postinstall hook
 * @description Postinstall hook of the package executes a bash command
 * @kind problem
 * @id postinstall-bash
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
  scriptCode.indexOf("bash") = 0
select json, scriptCode
