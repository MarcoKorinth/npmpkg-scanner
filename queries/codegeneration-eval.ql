/**
 * @name Code generation with eval function
 * @description Package contains runtime code generation with the eval function
 * @kind problem
 * @id codegeneration-eval-string
 * @security-severity 3.0
 * @problem.severity warning
 * @author Marco Korinth
 */

import javascript

from DirectEval e
select e, e.toString()
