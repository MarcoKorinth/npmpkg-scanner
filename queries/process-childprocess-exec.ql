/**
 * @name Execution of system command
 * @description Package uses exec command to execute a system command
 * @kind problem
 * @id process-childprocess-exec
 * @security-severity 7.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

class CommandName extends string {
  CommandName() { this in ["exec", "execSync"] }
}

from DataFlow::CallNode node
where
  exists(DataFlow::ModuleImportNode m, CommandName cmdName |
    m.getPath().matches("child_process") and
    node = m.getAMemberCall(cmdName) and
    node.getNumArgument() > 0
  )
select node,
  "// Executed command: " + node.getArgument(0).toString() + "\n" +
    node.getEnclosingExpr().toString()
