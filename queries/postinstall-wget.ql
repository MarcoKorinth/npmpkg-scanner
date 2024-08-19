/**
 * @name Wget command in postinstall hook
 * @description Postinstall hook of the package executes the wget command, which is commonly used to download files
 * @kind problem
 * @id postinstall-wget
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
  scriptCode.indexOf("wget") = 0
select json, scriptCode
