/**
 * @name Obfuscation with javascript-obfuscator tool
 * @description Package contains obfuscated code, which is likely generated with javascript-obfuscator tool
 * @kind problem
 * @id obfuscation-javascriptobfuscator
 * @security-severity 6.0
 * @problem.severity warning
 * @author Marco Korinth
 */

import javascript

from LocalVariable v
where v.getName().regexpMatch("^_0x[a-f0-9]*$")
select v, v.toString()
