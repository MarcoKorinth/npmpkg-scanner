/**
 * @name Datacollection of computers architecture
 * @description Package sends a network request, which includes the computers architecture
 * @kind path-problem
 * @id datacollection-os-arch
 * @security-severity 3.0
 * @problem.severity warning
 * @package-examples font-scrubber
 */

import javascript
import DataFlow::PathGraph

class ArchAccessConfiguration extends TaintTracking::Configuration {
  ArchAccessConfiguration() { this = "ArchAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::ModuleImportNode m | m.getPath().matches("os") |
      source = m.getAMethodCall("arch")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ClientRequest request | sink = request.getADataNode())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::PropWrite propWrite, string property | propWrite.writes(succ, property, pred))
  }
}

from ArchAccessConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, sink.getNode().getEnclosingExpr().toString()
