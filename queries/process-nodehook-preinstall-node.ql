/**
 * @name Node command in preinstall hook
 * @description Preinstall hook of the package executes the node command, to run a javascript script
 * @kind problem
 * @id process-nodehook-preinstall-node
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
  scriptCode.indexOf("node") = 0
select json, scriptCode
