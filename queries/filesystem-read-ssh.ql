/**
 * @name filesystem-read-ssh
 * @description Detect read access to a ssh file
 * @kind path-problem
 * @id filesystem-read-ssh
 * @security-severity 10.0
 * @problem.severity warning
 * @package-examples font-scrubber
 */

import javascript
import DataFlow::PathGraph

class SensitiveFile extends string {
  // CharPred
  SensitiveFile() { this in ["ssh/id_rsa", "ssh/config", "ssh/known_hosts", "ssh/authorized_keys"] }
}

class SensitiveFileNameAccessConfiguration extends TaintTracking::Configuration {
  SensitiveFileNameAccessConfiguration() { this = "SensitiveFileNameAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(string path, SensitiveFile file | source.mayHaveStringValue(path) |
      path.matches("%" + file)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FileSystemReadAccess f | sink = f.getAPathArgument())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Storing the information in an object property
    exists(DataFlow::PropWrite propWrite, string property | propWrite.writes(succ, property, pred))
  }
}

from SensitiveFileNameAccessConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "($@);:;($@)", source.getNode(),
  source.getNode().getStringValue(), sink.getNode(), sink.toString()
