/**
 * @name Node command in postinstall hook
 * @description Postinstall hook of the package executes the node command, to run a javascript script
 * @kind problem
 * @id process-nodehook-postinstall-node
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
