/**
 * @name HTTP request with fetch
 * @description Package makes an http request using fetch
 * @kind problem
 * @id network-http-fetch
 * @security-severity 3.0
 * @problem.severity warning
 * @author Marco Korinth
 */

import javascript

from DataFlow::CallNode node, string url
where
  node.getCalleeNode() = DataFlow::globalVarRef("fetch") and
  node.getNumArgument() > 0 and
  url = node.getArgument(0).getALocalSource().toString()
select node, "// URL: " + url + "\n" + node.toString()
