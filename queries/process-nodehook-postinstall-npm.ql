/**
 * @name Npm command in postinstall hook
 * @description Postinstall hook of the package executes the npm command. This might be used to execute other scripts in the package.json file.
 * @kind problem
 * @id process-nodehook-postinstall-npm
 * @security-severity 7.0
 * @problem.severity warning
 * @author Marco Korinth
 */

import javascript

from JsonObject json, string scriptName, string scriptCode
where
  exists(PackageJson manifest | json = manifest.getScripts()) and
  scriptName = "postinstall" and
  scriptCode = json.getPropStringValue(scriptName) and
  scriptCode.indexOf("npm") = 0
select json, scriptCode
