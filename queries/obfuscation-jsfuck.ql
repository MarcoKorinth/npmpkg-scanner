/**
 * @name Obfuscation with JSFuck
 * @description Package contains obfuscated code in JSFuck syntax
 * @kind problem
 * @id obfuscation-jsfuck
 * @security-severity 6.0
 * @problem.severity warning
 * @package-examples eslint-scope
 */

import javascript

// https://www.jsfuck.com/
predicate isJSFuck(AstNode node) {
  node.toString().regexpMatch("[\\.\\+\\!\\(\\)\\[\\]\\\\ ]{10,}")
}

from AstNode node
where isJSFuck(node) and not isJSFuck(node.getParent())
select node, "Detected JSF code (\"" + node.toString() + "\")"
