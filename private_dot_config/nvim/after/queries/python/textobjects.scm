;; extends
(assignment
  left: (identifier) @assignment.lhs
  type: (type) @assignment.rhs
  !right
)

(comparison_operator
  (_) @assignment.lhs
  (_) @assignment.rhs
)

(keyword_argument
  name: (identifier) @assignment.lhs
  value: (_) @assignment.rhs
)

(typed_parameter
  (identifier) @assignment.lhs
  type: (type) @assignment.rhs
)
