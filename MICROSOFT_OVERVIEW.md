# Summary

* Full read-only GQL against a single, ambient graph (i.e., no catalog syntax outside procedure calls)
* Non-conformant relaxation of top-level grammar structure.
  MSFTGQL does not syntactically track the distinction between
  focused/ambient nor between query/data procedure/catalog procedure.
  As a result, the grammar over-parses.
  It is the responsibility of the consumer to reject non-conformant sequences of statements.
  The benefit of this approach is that it leads to substantially simpler and extensible parse trees and sidesteps the need to inject catalog
  information into the generated ANTLR parser.
  The downside of this approach is the need to perform additional checks.
  In practice though, the required effort for these additional checks is fairly small.
* Supported graph patterns at least as powerful as openCypher patterns
* Session commands have been removed
* Transactions commands have been removed
* Removal of list value type length bounds
* Removal of schema references
* Removal of support for local node type aliases

# Supported data types

* ANY (both open and closed variants)
* STRING (without length bounds)
* BYTES (without length bounds)
* BOOL/BOOLEAN
* INT/INT64/INT32
* UINT/UINT64/UINT32
* DECIMAL
* FLOAT/FLOAT64/FLOAT32
* LOCAL DATETIME/TIMESTAMP WITHOUT TIME ZONE
* ZONED DATETIME/TIMESTAMP WITH TIME ZONE
* DURATION(YEAR TO MONTH)
* DURATION(DAY TO SECOND)
* DATE
* LIST/ARRAY (without max length bound)
* RECORD (both open and closed variants)
* NODE (both open and closed variants)
* EDGE (both open and closed variants)
* PATH
* NULL (also NOT NULL modifier for all types)
* NOTHING

# Noteworthy removed optional features

* Catalog-modification statements (DDL)
* Data-modification statements (DML)
* AT schema clause for specifying the current working schema

* Match Blocks
* Path pattern disjunction, multiset alternation, and sub path variables
* Label wildcard syntax
* Nested quantified path patterns
* Simplified pattern syntax
* Questioned path primaries
* Counted path search
* Counted shortest path patterns and counted shortest path group patterns
* Graph pattern yield clause
* PROPERTY_EXISTS (Use n.prop IS NOT NULL instead)
* Disallow single underscore as a regular identifier
* Binding tables: procedure-local variable definitions and reference expressions
* Graph reference expressions: procedure-local variable definitions and reference expressions
* Data types not listed above

# Extensions

* General support for a GQL preamble for selecting a language dialect, extensions, and options
* string_predicates: CONTAINS, STARTS WITH, ENDS WITH
* string_functions: STRING_JOIN
* regexp: REGEXP_CONTAINS
* list_indexing: `<expr>[<index>]`
* list_functions: nodes, edges, range, keys, labels
* list_containment: `<expr> IN <expr>`

# Noteworthy changes in comparison to openGQL

* Includes additional, minimally modified test grammar for use by bin/test.sh *only*
* Simplified grammar for label expressions (no label wildcard support for now)
* Corrections to ensure the parse tee is non-ambiguous
* Inlining of various productions to produce a more compact parse tree
* Adjustments to ensure each complex rule alternative either is wrapped in a production or has a hash-mark label
* Various lexical corrections, in particular use of correct Unicode properties in various lexemes
* Consistent use of _TOKEN instead of _KW and _RESERVED_WORD
* Replaced identifier/regularIdentifier/delimitedIdentifier with anyIdent and varIdent for consistency and future
expansion
* Some minor rule name changes for consistency
