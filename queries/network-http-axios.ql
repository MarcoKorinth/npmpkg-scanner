/**
 * @name HTTP request with axios
 * @description Package makes an http request using the axios library
 * @kind problem
 * @id network-http-axios
 * @security-severity 3.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

class HTTPMethod extends string {
  HTTPMethod() { this in ["get", "post", "put", "patch", "delete"] }
}

from DataFlow::CallNode node, string url
where
  exists(DataFlow::ModuleImportNode m |
    m.getPath().matches("axios") and
    (
      exists(HTTPMethod method |
        node = m.getAMemberCall(method) and
        node.getNumArgument() > 0 and
        url = node.getArgument(0).getALocalSource().toString()
      )
      or
      exists(ObjectExpr options, ValueProperty urlProperty |
        node = m.getACall() and
        node.getNumArgument() > 0 and
        options = node.getArgument(0).getALocalSource().asExpr() and
        urlProperty = options.getPropertyByName("url") and
        url = DataFlow::valueNode(urlProperty.getInit()).getALocalSource().toString()
      )
    )
  )
select node, "// URL: " + url + "\n" + node.toString()
