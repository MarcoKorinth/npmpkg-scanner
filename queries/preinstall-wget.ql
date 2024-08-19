/**
 * @name Wget command in preinstall hook
 * @description Preinstall hook of the package executes the wget command, which is commonly used to download files
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
