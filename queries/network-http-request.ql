/**
 * @name HTTP request with request
 * @description Package makes an http request using the deprecated request library
 * @kind problem
 * @id network-http-request
 * @security-severity 5.0
 * @problem.severity warning
 * @author Marco Korinth
 */

import javascript

class HTTPMethod extends string {
  HTTPMethod() { this in ["get", "post", "put", "patch", "delete"] }
}

from DataFlow::CallNode node, string url
where
  exists(DataFlow::ModuleImportNode m, HTTPMethod method |
    m.getPath().matches("request") and
    node = m.getAMemberCall(method) and
    node.getNumArgument() > 0 and
    url = node.getArgument(0).getALocalSource().toString()
  )
select node, "// URL: " + url + "\n" + node.toString()
