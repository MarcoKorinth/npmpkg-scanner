/**
 * @name Wget command in preinstall hook
 * @description Preinstall hook of the package executes the wget command, which is commonly used to download files
 * @kind problem
 * @id process-nodehook-preinstall-wget
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
  scriptCode.indexOf("wget") = 0
select json, scriptCode
