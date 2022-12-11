; extends

(let_declaration
    pattern: (_)
    value: (_) @statement.inner) @statment.outer

(field_initializer
    name: (_)
    value: (_) @statement.inner) @statment.outer

(assignment_expression
    left: (_)
    right: (_) @statement.inner) @statment.outer

(closure_expression
    parameters: (_)
    body: (_) @function.inner) @function.outer
