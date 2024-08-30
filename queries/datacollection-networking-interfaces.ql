/**
 * @name Datacollection of network interfaces
 * @description Package sends a network request, which includes information about the systems network interfaces
 * @kind path-problem
 * @id datacollection-networking-interfaces
 * @security-severity 6.0
 * @problem.severity warning
 * @package-examples font-scrubber
 */

import javascript
import DataFlow::PathGraph

class InterfacesAccessConfiguration extends TaintTracking::Configuration {
  InterfacesAccessConfiguration() { this = "InterfacesAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::ModuleImportNode m | m.getPath().matches("os") |
      source = m.getAMethodCall("networkInterfaces")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ClientRequest request | sink = request.getADataNode())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::PropWrite propWrite, string property | propWrite.writes(succ, property, pred))
  }
}

from InterfacesAccessConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, sink.getNode().getEnclosingExpr().toString()
