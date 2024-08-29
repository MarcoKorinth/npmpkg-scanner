/**
 * @name Read access to an ssh file
 * @description Package reads a file used by the ssh client or daemon
 * @kind path-problem
 * @id filesystem-read-ssh
 * @security-severity 10.0
 * @problem.severity warning
 * @package-examples font-scrubber
 */

import javascript
import DataFlow::PathGraph

class SshFile extends string {
  SshFile() { this in ["ssh/id_rsa", "ssh/config", "ssh/known_hosts", "ssh/authorized_keys"] }
}

class SshFileAccessConfiguration extends TaintTracking::Configuration {
  SshFileAccessConfiguration() { this = "SshFileAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(string path, SshFile file | source.mayHaveStringValue(path) | path.matches("%" + file))
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FileSystemReadAccess f | sink = f.getAPathArgument())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::PropWrite propWrite, string property | propWrite.writes(succ, property, pred))
  }
}

from SshFileAccessConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "// Affected file: " + source.toString() + "\n" + sink.getNode().getEnclosingExpr().toString()
