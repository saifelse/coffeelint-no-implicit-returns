module.exports = class NoImplicitReturns

  rule:
    name: 'no_implicit_returns'
    strict: true
    level: 'error'
    message: 'Explicit return required for multi-line function'
    description: 'Checks for explicit returns in multi-line functions'

  processFunction: (code, astApi) ->
    firstLine = code.locationData.first_line + 1
    lastLine = code.locationData.last_line + 1

    expressions = code.body.expressions
    lastExpr = code.body.lastNonComment expressions
    if not lastExpr?
      return
    lastType = lastExpr.constructor.name
    lastExprLine = lastExpr.locationData.first_line + 1

    if code.isCtorBody
      # Ignore constructors
      return

    # An expression is a pure statement if it jumps().
    # Base cases: return, continue (not in loop), break (not in a loop or block)
    #   are jumps/pure.
    # Inductive step: everything else jumps if they contain a child node that
    #   jumps.
    isPureStatement = lastExpr.jumps()

    if expressions.length > 1 and not isPureStatement
      # Multi-line but doesn't end with a pure statement
      @errors.push astApi.createError
        context: code.variable
        lineNumber: firstLine
        lineNumberEnd: firstLine
    else if expressions.length == 1
      if firstLine == lastLine and lastType == 'Return'
        # Single line that ends with a return
        @errors.push astApi.createError
          context: code.variable
          message: 'Explicit return not required for single-line function'
          level: 'warn'
          lineNumber: firstLine
          lineNumberEnd: firstLine
      isStrict = astApi.config[@rule.name].strict
      if isStrict and firstLine != lastLine and not isPureStatement and firstLine != lastExprLine
        # Single-expression function that spans multiple lines with a leading newline.
        @errors.push astApi.createError
          message: 'Remove leading newline or add explicit return'
          context: code.variable
          lineNumber: firstLine
          lineNumberEnd: firstLine
    return

  lintNode: (node, astApi) ->
    # Iterate over all 'Class' and 'Code' nodes.
    node.traverseChildren false, (child) =>
      if child.constructor.name == 'Class'
        # Mark constructor since it does not need a return.
        child.walkBody child.determineName(), {}
        child.ctor?.isCtorBody = true
      if child.constructor.name == 'Code'
        # For each function, process it and recurse.
        @processFunction child, astApi
        @lintNode child.body, astApi
      return
    return

  lintAST: (node, astApi) ->
    @lintNode node, astApi
    return
