/**
 * @name HTTP request with https
 * @description Package makes an http request using the http(s) library
 * @kind problem
 * @id network-http-https
 * @security-severity 5.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

class ImportName extends string {
  ImportName() { this in ["node:https", "node:http"] }
}

from DataFlow::CallNode node, string url
where
  exists(DataFlow::ModuleImportNode m, ImportName importName |
    m.getPath().matches(importName) and
    node = m.getAMemberCall("get") and
    node.getNumArgument() > 0 and
    url = node.getArgument(0).getALocalSource().toString()
  )
select node, "// URL: " + url + "\n" + node.toString()
