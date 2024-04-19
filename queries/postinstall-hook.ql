/**
 * @name postinstall-hook
 * @description Detects postinstall scripts in package.json
 * @kind problem
 * @id js/postinstall-script
 * @security-severity 7.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

from JsonObject json, string scriptName, string scriptCode
where exists( PackageJson manifest | json = manifest.getScripts() )
  and scriptName = [ "postinstall" ]
  and scriptCode = json.getPropStringValue(scriptName)
select json, "Detected \"" + scriptName + "\" script with code \"" + scriptCode + "\""
