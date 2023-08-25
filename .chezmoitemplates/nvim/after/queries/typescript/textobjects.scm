;; extends
(binary_expression
  left: (_) @assignment.lhs
  right: (_) @assignment.rhs
)

(pair
  key: (property_identifier) @assignment.lhs
  value: (_) @assignment.rhs
)

(type_alias_declaration
  name: (type_identifier) @assignment.lhs
  value: (generic_type) @assignment.rhs
)
