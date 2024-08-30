/**
 * @name Datacollection of ENV-Variables
 * @description Package sends a network request, which includes environment variables
 * @kind path-problem
 * @id datacollection-env
 * @security-severity 7.0
 * @problem.severity warning
 * @package-examples font-scrubber
 */

import javascript
import DataFlow::PathGraph

class EnvVariablesAccessConfiguration extends TaintTracking::Configuration {
  EnvVariablesAccessConfiguration() { this = "EnvVariablesAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::GlobalVarRefNode var | var.getName().matches("process") |
      source = var.getAPropertyRead("env")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ClientRequest request | sink = request.getADataNode())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::PropWrite propWrite, string property | propWrite.writes(succ, property, pred))
  }
}

from EnvVariablesAccessConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, sink.getNode().getEnclosingExpr().toString()
