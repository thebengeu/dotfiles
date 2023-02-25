;; extends
(assignment
  left: (identifier) @assignment.lhs
  type: (type) @assignment.rhs
  !right
)

(keyword_argument
  name: (identifier) @assignment.lhs
  value: (_) @assignment.rhs
)

(typed_parameter
  (identifier) @assignment.lhs
  type: (type) @assignment.rhs
)
