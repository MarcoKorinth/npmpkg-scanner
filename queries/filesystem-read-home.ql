/**
 * @name Read access to users home directory
 * @description Package reads contents of the users home directory
 * @kind path-problem
 * @id filesystem-read-home
 * @security-severity 6.0
 * @problem.severity warning
 * @package-examples font-scrubber
 */

import javascript
import DataFlow::PathGraph

class HomeDirAccessConfiguration extends TaintTracking::Configuration {
  HomeDirAccessConfiguration() { this = "HomeDirAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::ModuleImportNode m | m.getPath().matches("os") |
      source = m.getAMethodCall("homedir")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FileSystemAccess fa |
      sink = fa.getAPathArgument() and not fa instanceof FileSystemWriteAccess
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::PropWrite propWrite, string property | propWrite.writes(succ, property, pred))
  }
}

from HomeDirAccessConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, sink.getNode().getEnclosingExpr().toString()
