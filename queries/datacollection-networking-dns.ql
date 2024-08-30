/**
 * @name Datacollection of DNS servers
 * @description Package sends a network request, which includes the systems DNS servers
 * @kind path-problem
 * @id datacollection-networking-dns
 * @security-severity 3.0
 * @problem.severity warning
 * @package-examples font-scrubber
 */

import javascript
import DataFlow::PathGraph

class DNSAccessConfiguration extends TaintTracking::Configuration {
  DNSAccessConfiguration() { this = "DNSAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::ModuleImportNode m | m.getPath().matches("dns") |
      source = m.getAMethodCall("getServers")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ClientRequest request | sink = request.getADataNode())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::PropWrite propWrite, string property | propWrite.writes(succ, property, pred))
  }
}

from DNSAccessConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, sink.getNode().getEnclosingExpr().toString()
