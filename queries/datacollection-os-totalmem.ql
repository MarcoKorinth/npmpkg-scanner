/**
 * @name Datacollection of systems total memory
 * @description Package sends a network request, which includes the amount of total memory
 * @kind path-problem
 * @id datacollection-os-totalmem
 * @security-severity 3.0
 * @problem.severity warning
 * @package-examples font-scrubber
 */

import javascript
import DataFlow::PathGraph

class TotalmemAccessConfiguration extends TaintTracking::Configuration {
  TotalmemAccessConfiguration() { this = "TotalmemAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::ModuleImportNode m | m.getPath().matches("os") |
      source = m.getAMethodCall("totalmem")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ClientRequest request | sink = request.getADataNode())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::PropWrite propWrite, string property | propWrite.writes(succ, property, pred))
  }
}

from TotalmemAccessConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, sink.getNode().getEnclosingExpr().toString()
