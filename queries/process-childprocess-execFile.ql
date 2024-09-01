/**
 * @name File execution
 * @description Package uses execFile command to execute a file
 * @kind problem
 * @id process-childprocess-execFile
 * @security-severity 7.0
 * @problem.severity warning
 * @author Marco Korinth
 */

import javascript

class CommandName extends string {
  CommandName() { this in ["execFile", "execFileSync"] }
}

from DataFlow::CallNode node
where
  exists(DataFlow::ModuleImportNode m, CommandName cmdName |
    m.getPath().matches("child_process") and
    node = m.getAMemberCall(cmdName) and
    node.getNumArgument() > 0
  )
select node,
  "// Executed file: " + node.getArgument(0).toString() + "\n" + node.getEnclosingExpr().toString()
