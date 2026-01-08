/* =====================================================================================================================
   GQL_LEXER.g4
   =====================================================================================================================

   This file defines the lexer grammar of MSFTGQL.

   See MSFTGQL.g4 for further information on the MSFTGQL grammar.
*/
lexer grammar GQL_LEXER;

BOOLEAN_LITERAL
    : 'TRUE'
    | 'FALSE'
    | 'UNKNOWN'
    ;

SINGLE_QUOTED_CHARACTER_SEQUENCE
    :           QUOTE ESCAPED_SINGLE_QUOTED_CHARACTER_REPRESENTATION*
                      (QUOTE_PAIR ESCAPED_SINGLE_QUOTED_CHARACTER_REPRESENTATION*)* QUOTE
    | NO_ESCAPE_QUOTE UNESCAPED_SINGLE_QUOTED_CHARACTER_REPRESENTATION*
                      (QUOTE_PAIR UNESCAPED_SINGLE_QUOTED_CHARACTER_REPRESENTATION*)* QUOTE
    ;

DOUBLE_QUOTED_CHARACTER_SEQUENCE
    :           DOUBLE_QUOTE ESCAPED_DOUBLE_QUOTED_CHARACTER_REPRESENTATION*
                             (DOUBLE_QUOTE_PAIR ESCAPED_DOUBLE_QUOTED_CHARACTER_REPRESENTATION*)* DOUBLE_QUOTE
    | NO_ESCAPE_DOUBLE_QUOTE UNESCAPED_DOUBLE_QUOTED_CHARACTER_REPRESENTATION*
                             (DOUBLE_QUOTE_PAIR UNESCAPED_DOUBLE_QUOTED_CHARACTER_REPRESENTATION*)* DOUBLE_QUOTE
    ;

ACCENT_QUOTED_CHARACTER_SEQUENCE
    :           GRAVE_ACCENT ESCAPED_ACCENT_QUOTED_CHARACTER_REPRESENTATION*
                             (GRAVE_ACCENT_PAIR ESCAPED_ACCENT_QUOTED_CHARACTER_REPRESENTATION*)* GRAVE_ACCENT
    | NO_ESCAPE_GRAVE_ACCENT UNESCAPED_ACCENT_QUOTED_CHARACTER_REPRESENTATION*
                             (GRAVE_ACCENT_PAIR UNESCAPED_ACCENT_QUOTED_CHARACTER_REPRESENTATION*)* GRAVE_ACCENT
    ;

fragment QUOTE_PAIR
    : '\'\''
    ;

fragment NO_ESCAPE_QUOTE
    : '@\''
    ;

fragment DOUBLE_QUOTE_PAIR
    : '""'
    ;

fragment NO_ESCAPE_DOUBLE_QUOTE
    : '@"'
    ;

fragment GRAVE_ACCENT_PAIR
    : '``'
    ;

fragment NO_ESCAPE_GRAVE_ACCENT
    : '@`'
    ;

/* Fix character sequence syntax

fragment SINGLE_QUOTED_CHARACTER_REPRESENTATION:
	(ESCAPED_CHARACTER | ~['\\\r\n] | '\'\'')+
	;

fragment DOUBLE_QUOTED_CHARACTER_REPRESENTATION:
	(ESCAPED_CHARACTER | ~["\\\r\n] | '""')+
	;

fragment ACCENT_QUOTED_CHARACTER_REPRESENTATION:
	(ESCAPED_CHARACTER | ~[`\\\r\n] | '``')+
	;
*/

fragment ESCAPED_SINGLE_QUOTED_CHARACTER_REPRESENTATION:
	ESCAPED_CHARACTER | WHITESPACE | ~['\\\r\n\p{Cc}\p{Cn}]
	;

fragment UNESCAPED_SINGLE_QUOTED_CHARACTER_REPRESENTATION:
	WHITESPACE | ~['\r\n\p{Cc}\p{Cn}]
	;

fragment ESCAPED_DOUBLE_QUOTED_CHARACTER_REPRESENTATION:
    // Identifier normal forms are not allowed to contain whitespace other than ' ', this needs to be checked separately
	ESCAPED_CHARACTER | WHITESPACE | ~["\\\r\n\p{Cc}\p{Cn}]
	;

fragment UNESCAPED_DOUBLE_QUOTED_CHARACTER_REPRESENTATION:
    // Identifier normal forms are not allowed to contain whitespace other than ' ', this needs to be checked separately
	WHITESPACE | ~["\r\n\p{Cc}\p{Cn}]
	;

fragment ESCAPED_ACCENT_QUOTED_CHARACTER_REPRESENTATION:
    // Identifier normal forms are not allowed to contain whitespace other than ' ', this needs to be checked separately
	ESCAPED_CHARACTER | WHITESPACE | ~[`\\\r\n\p{Cc}\p{Cn}]
	;

fragment UNESCAPED_ACCENT_QUOTED_CHARACTER_REPRESENTATION:
    // Identifier normal forms are not allowed to contain whitespace other than ' ', this needs to be checked separately
	WHITESPACE | ~[`\r\n\p{Cc}\p{Cn}]
	;

fragment ESCAPED_CHARACTER
    : ESCAPED_REVERSE_SOLIDUS
	| ESCAPED_QUOTE
	| ESCAPED_DOUBLE_QUOTE
	| ESCAPED_GRAVE_ACCENT
	| ESCAPED_TAB
	| ESCAPED_BACKSPACE
	| ESCAPED_NEW_LINE
	| ESCAPED_CARRIAGE_RETURN
	| ESCAPED_FORM_FEED
	| ESCAPED_UNICODE4_DIGIT_VALUE
	| ESCAPED_UNICODE6_DIGIT_VALUE
	;

fragment ESCAPED_REVERSE_SOLIDUS: REVERSE_SOLIDUS REVERSE_SOLIDUS;
fragment ESCAPED_QUOTE: REVERSE_SOLIDUS QUOTE;
fragment ESCAPED_DOUBLE_QUOTE: REVERSE_SOLIDUS DOUBLE_QUOTE;
fragment ESCAPED_GRAVE_ACCENT: REVERSE_SOLIDUS GRAVE_ACCENT;
fragment ESCAPED_TAB options { caseInsensitive=false; }: REVERSE_SOLIDUS 't';
fragment ESCAPED_BACKSPACE options { caseInsensitive=false; }: REVERSE_SOLIDUS 'b';
fragment ESCAPED_NEW_LINE options { caseInsensitive=false; }: REVERSE_SOLIDUS 'n';
fragment ESCAPED_CARRIAGE_RETURN options { caseInsensitive=false; }: REVERSE_SOLIDUS 'r';
fragment ESCAPED_FORM_FEED options { caseInsensitive=false; }: REVERSE_SOLIDUS 'f';
fragment ESCAPED_UNICODE4_DIGIT_VALUE:
	START_UNICODE4 HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
fragment ESCAPED_UNICODE6_DIGIT_VALUE:
	START_UNICODE6 HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;

fragment START_UNICODE4 options { caseInsensitive=false; }: REVERSE_SOLIDUS 'u';

fragment START_UNICODE6 options { caseInsensitive=false; }: REVERSE_SOLIDUS 'U';

// TODO: Finish this. It is tricky how it interacts with <separator> -- openGQL
// TODO: Check if allowing SPACE is sufficient -- openGQL

BYTE_STRING_LITERAL
    : 'X' QUOTE SPACE* (HEX_DIGIT SPACE* HEX_DIGIT SPACE*)* QUOTE
    ;

UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION_WITH_EXACT_NUMBER_SUFFIX
    : UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION EXACT_NUMBER_SUFFIX
    ;

UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION_WITHOUT_SUFFIX
    : UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION
    ;

UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION_WITH_APPROXIMATE_NUMBER_SUFFIX
    : UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION APPROXIMATE_NUMBER_SUFFIX
    ;

UNSIGNED_DECIMAL_IN_COMMON_NOTATION_WITH_EXACT_NUMBER_SUFFIX
    : UNSIGNED_DECIMAL_IN_COMMON_NOTATION EXACT_NUMBER_SUFFIX
    ;

UNSIGNED_DECIMAL_IN_COMMON_NOTATION_WITHOUT_SUFFIX
    : UNSIGNED_DECIMAL_IN_COMMON_NOTATION
    ;

UNSIGNED_DECIMAL_IN_COMMON_NOTATION_WITH_APPROXIMATE_NUMBER_SUFFIX
    : UNSIGNED_DECIMAL_IN_COMMON_NOTATION APPROXIMATE_NUMBER_SUFFIX
    ;

UNSIGNED_DECIMAL_INTEGER_WITH_EXACT_NUMBER_SUFFIX
    : UNSIGNED_DECIMAL_INTEGER EXACT_NUMBER_SUFFIX
    ;

UNSIGNED_DECIMAL_INTEGER_WITH_APPROXIMATE_NUMBER_SUFFIX
    : UNSIGNED_DECIMAL_INTEGER APPROXIMATE_NUMBER_SUFFIX
    ;

UNSIGNED_DECIMAL_INTEGER_WITH_UNSIGNED_SUFFIX    // MSFTGQL only
    : UNSIGNED_DECIMAL_INTEGER UNSIGNED_NUMBER_SUFFIX
    ;

UNSIGNED_DECIMAL_INTEGER
    : DIGIT (UNDERSCORE? DIGIT)*
    ;

fragment EXACT_NUMBER_SUFFIX
    : 'M'
    ;

fragment UNSIGNED_NUMBER_SUFFIX // MSFTGQL only
    : 'U'
    ;

fragment UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION
    : MANTISSA 'E' EXPONENT
    ;

fragment MANTISSA
    : UNSIGNED_DECIMAL_IN_COMMON_NOTATION
    | UNSIGNED_DECIMAL_INTEGER
    ;

fragment EXPONENT
    : SIGNED_DECIMAL_INTEGER
    ;

fragment UNSIGNED_DECIMAL_IN_COMMON_NOTATION
    : UNSIGNED_DECIMAL_INTEGER (PERIOD_SIGN UNSIGNED_DECIMAL_INTEGER?)
    | PERIOD_SIGN UNSIGNED_DECIMAL_INTEGER
    ;

fragment SIGNED_DECIMAL_INTEGER
    : (PLUS_SIGN | MINUS_SIGN)? UNSIGNED_DECIMAL_INTEGER
    ;

UNSIGNED_HEXADECIMAL_INTEGER
    : START_HEX ('_'? HEX_DIGIT)+
    ;

fragment START_HEX options { caseInsensitive=false; }: '0x';

// TODO: Disallow 0O
UNSIGNED_OCTAL_INTEGER
    : START_OCTAL ('_'? OCTAL_DIGIT)+
    ;

fragment START_OCTAL options { caseInsensitive=false; }: '0o';

// TODO: Disallow 0B
UNSIGNED_BINARY_INTEGER
    : START_BINARY ('_'? BINARY_DIGIT)+
    ;

fragment START_BINARY options { caseInsensitive=false; }: '0b';

fragment APPROXIMATE_NUMBER_SUFFIX
    : 'F'
    | 'D'
    ;

// Reserved words [openGQL]
ABS: 'ABS';
ABSTRACT: 'ABSTRACT';                   // MSFTGQL only; pre-reserved word in GQL though
ACOS: 'ACOS';
ALL: 'ALL';
ALL_DIFFERENT: 'ALL_DIFFERENT';
AND: 'AND';
ANY: 'ANY';
ARRAY: 'ARRAY';
AS: 'AS';
ASC: 'ASC';
ASCENDING: 'ASCENDING';
ASIN: 'ASIN';
AT: 'AT';
ATAN: 'ATAN';
AVG: 'AVG';
BIG: 'BIG';
BIGINT: 'BIGINT';
BINARY: 'BINARY';
BOOL: 'BOOL';
BOOLEAN: 'BOOLEAN';
BOTH: 'BOTH';
BTRIM: 'BTRIM';
BY: 'BY';
BYTE_LENGTH: 'BYTE_LENGTH';
BYTES: 'BYTES';
CALL: 'CALL';
CARDINALITY: 'CARDINALITY';
CASE: 'CASE';
CAST: 'CAST';
CEIL: 'CEIL';
CEILING: 'CEILING';
CHAR: 'CHAR';
CHAR_LENGTH: 'CHAR_LENGTH';
CHARACTER_LENGTH: 'CHARACTER_LENGTH';
CHARACTERISTICS: 'CHARACTERISTICS';
CLOSE: 'CLOSE';
COALESCE: 'COALESCE';
COLLECT_LIST: 'COLLECT_LIST';
COMMIT: 'COMMIT';
CONTAINS: 'CONTAINS';                   // MSFTGQL only
COPY: 'COPY';
COS: 'COS';
COSH: 'COSH';
COT: 'COT';
COUNT: 'COUNT';
CREATE: 'CREATE';
CURRENT_DATE: 'CURRENT_DATE';
CURRENT_GRAPH: 'CURRENT_GRAPH';
CURRENT_PROPERTY_GRAPH: 'CURRENT_PROPERTY_GRAPH';
CURRENT_SCHEMA: 'CURRENT_SCHEMA';
CURRENT_TIME: 'CURRENT_TIME';
CURRENT_TIMESTAMP: 'CURRENT_TIMESTAMP';
DATE: 'DATE';
DATETIME: 'DATETIME';
DEC: 'DEC';
DECIMAL: 'DECIMAL';
DEGREES: 'DEGREES';
DELETE: 'DELETE';
DESC: 'DESC';
DESCENDING: 'DESCENDING';
DETACH: 'DETACH';
DISTINCT: 'DISTINCT';
DOUBLE: 'DOUBLE';
DROP: 'DROP';
DURATION: 'DURATION';
DURATION_BETWEEN: 'DURATION_BETWEEN';
EDGE: 'EDGE';                           // MSFTGQL only
EDGES: 'EDGES';                         // MSFTGQL only
ELEMENT: 'ELEMENT';                     // MSFTGQL only
ELEMENTS: 'ELEMENTS';                   // MSFTQGQL only
ELEMENT_ID: 'ELEMENT_ID';
ELSE: 'ELSE';
END: 'END';
ENDS: 'ENDS';                           // MSFTGQL only
ENUM: 'ENUM';                           // MSFTGQL only: Future ENUM type
EXACT: 'EXACT';                         // MSFTGQL only: Index kind
EXCEPT: 'EXCEPT';
EXISTS: 'EXISTS';
EXP: 'EXP';
FILTER: 'FILTER';
FINISH: 'FINISH';
FLOAT: 'FLOAT';
FLOAT16: 'FLOAT16';
FLOAT32: 'FLOAT32';
FLOAT64: 'FLOAT64';
FLOAT128: 'FLOAT128';
FLOAT256: 'FLOAT256';
FLOOR: 'FLOOR';
FOR: 'FOR';
FROM: 'FROM';
GROUP: 'GROUP';
GQL: 'GQL';                             // MSFTGQL only
HAVING: 'HAVING';
HOME_GRAPH: 'HOME_GRAPH';
HOME_PROPERTY_GRAPH: 'HOME_PROPERTY_GRAPH';
HOME_SCHEMA: 'HOME_SCHEMA';
IF: 'IF';
IN: 'IN';
INCLUDE: 'INCLUDE';                     // MSFTGQL only (cached property specification in index DDL)
INDEX: 'INDEX';                         // MSFTGQL only
INSERT: 'INSERT';
INT: 'INT';
INTEGER: 'INTEGER';
INT8: 'INT8';
INTEGER8: 'INTEGER8';
INT16: 'INT16';
INTEGER16: 'INTEGER16';
INT32: 'INT32';
INTEGER32: 'INTEGER32';
INT64: 'INT64';
INTEGER64: 'INTEGER64';
INT96: 'INT96';                         // MSFTGQL only: Reserved for Parquet INT96
INTEGER96: 'INTEGER96';                 // MSFTGQL only: Reserved for Parquet INT96
INT128: 'INT128';
INTEGER128: 'INTEGER128';
INT256: 'INT256';
INTEGER256: 'INTEGER256';
INTERSECT: 'INTERSECT';
INTERVAL: 'INTERVAL';                   // Reserved for future interval type by ISO/IEC 39075:2024(en)
IS: 'IS';
JSON: 'JSON';                           // MSFTGQL only: Reserved for porting SQL/JSON type
KEY: 'KEY';                             // MSFTGQL only
KEYS: 'KEYS';                           // MSFTGQL only
LABEL: 'LABEL';                         // MSFTGQL only
LABELS: 'LABELS';                       // MSFTGQL only
LEADING: 'LEADING';
LEFT: 'LEFT';
LET: 'LET';
LIKE: 'LIKE';
LIMIT: 'LIMIT';
LIST: 'LIST';
LN: 'LN';
LOCAL: 'LOCAL';
LOCAL_DATETIME: 'LOCAL_DATETIME';
LOCAL_TIME: 'LOCAL_TIME';
LOCAL_TIMESTAMP: 'LOCAL_TIMESTAMP';
LOG_TOKEN: 'LOG';
LOG10_TOKEN: 'LOG10';
LOWER: 'LOWER';
LTRIM: 'LTRIM';
MATCH: 'MATCH';
MAX: 'MAX';
MIN: 'MIN';
MOD: 'MOD';
NEXT: 'NEXT';
NODE: 'NODE';                           // MSFTGQL only
NODES: 'NODES';                         // MSFTGQL only
NODETACH: 'NODETACH';
NORMALIZE: 'NORMALIZE';
NOT: 'NOT';
NOTHING: 'NOTHING';
NULL_TOKEN: 'NULL';                     // NULL is a commonly used macro in C++. [openGQL]
NULLS: 'NULLS';
NULLIF: 'NULLIF';
OCTET_LENGTH: 'OCTET_LENGTH';
OF: 'OF';
OFFSET: 'OFFSET';
OPTIONAL: 'OPTIONAL';
OR: 'OR';
ORDER: 'ORDER';
OTHERWISE: 'OTHERWISE';
PARAMETER: 'PARAMETER';
PARAMETERS: 'PARAMETERS';
PATH: 'PATH';
PATH_LENGTH: 'PATH_LENGTH';
PATHS: 'PATHS';
PERCENTILE_CONT: 'PERCENTILE_CONT';
PERCENTILE_DISC: 'PERCENTILE_DISC';
POINT: 'POINT';                         // MSFTGQL only: Reserved for future point type
POWER: 'POWER';
PRECISION: 'PRECISION';
PROPERTY_EXISTS: 'PROPERTY_EXISTS';
RADIANS: 'RADIANS';
RANGE: 'RANGE';                         // MSFTGQL only
REAL: 'REAL';
RECORD: 'RECORD';
REGEXP_CONTAINS: 'REGEXP_CONTAINS';     // MSFTGQL only
REMOVE: 'REMOVE';
REPLACE: 'REPLACE';
RESET: 'RESET';
RETURN: 'RETURN';
RIGHT: 'RIGHT';
ROLLBACK: 'ROLLBACK';
RTRIM: 'RTRIM';
SAME: 'SAME';
SCHEMA: 'SCHEMA';
SELECT: 'SELECT';
SESSION: 'SESSION';
SESSION_USER: 'SESSION_USER';
SET: 'SET';
SIGNED: 'SIGNED';
SIN: 'SIN';
SINH: 'SINH';
SIZE: 'SIZE';
SKIP_TOKEN: 'SKIP';
SMALL: 'SMALL';
SMALLINT: 'SMALLINT';
SQRT: 'SQRT';
START: 'START';
STARTS: 'STARTS';                       // MSFTGQL only
STDDEV_POP: 'STDDEV_POP';
STDDEV_SAMP: 'STDDEV_SAMP';
STRING: 'STRING';
STRING_JOIN: 'STRING_JOIN';             // MSFTGQL only
SUM: 'SUM';
TAN: 'TAN';
TANH: 'TANH';
THEN: 'THEN';
TIME: 'TIME';
TIMESTAMP: 'TIMESTAMP';
TRAILING: 'TRAILING';
TO_JSON: 'TO_JSON';                     // MSFTGQL only
TO_JSON_STRING: 'TO_JSON_STRING';       // MSFTGQL only
PARSE_JSON_STRING: 'PARSE_JSON_STRING'; // MSFTGQL only
TRIM: 'TRIM';
TYPED: 'TYPED';
UBIGINT: 'UBIGINT';
UINT: 'UINT';
UINT8: 'UINT8';
UINT16: 'UINT16';
UINT32: 'UINT32';
UINT64: 'UINT64';
UINT128: 'UINT128';
UINT256: 'UINT256';
UNION: 'UNION';
UNSIGNED: 'UNSIGNED';
UPPER: 'UPPER';
USE: 'USE';
USMALLINT: 'USMALLINT';
VALUE: 'VALUE';
VARBINARY: 'VARBINARY';
VARCHAR: 'VARCHAR';
VARIABLE: 'VARIABLE';
VERTEX: 'VERTEX';                       // MSFTGQL only
VERTICES: 'VERTICES';                   // MSFTGQL only
WHEN: 'WHEN';
WHERE: 'WHERE';
WITH: 'WITH';
XOR: 'XOR';
YIELD: 'YIELD';
ZONED: 'ZONED';
ZONED_DATETIME: 'ZONED_DATETIME';
ZONED_TIME: 'ZONED_TIME';

// Pre-reserved words
AGGREGATE: 'AGGREGATE';
AGGREGATES: 'AGGREGATES';
ALTER: 'ALTER';
CATALOG: 'CATALOG';
CLEAR: 'CLEAR';
CLONE: 'CLONE';
CONSTRAINT: 'CONSTRAINT';
CONSTRUCT: 'CONSTRUCT';                 // MSFTGQL only
CURRENT_ROLE: 'CURRENT_ROLE';
CURRENT_USER: 'CURRENT_USER';
CYPHER: 'CYPHER';                       // MSFTGQL only
DATA: 'DATA';
DECLARE: 'DECLARE';                     // MSFTGQL only
DIRECTORY: 'DIRECTORY';
DRYRUN: 'DRYRUN';
EXISTING: 'EXISTING';
FUNCTION: 'FUNCTION';
FULLTEXT: 'FULLTEXT';                   // MSFTGQL only: Index kind
GQLSTATUS: 'GQLSTATUS';
GRANT: 'GRANT';
INSTANT: 'INSTANT';
INFINITY_TOKEN: 'INFINITY';             // INFINITY is a commonly used macro in C++
MERGE: 'MERGE';                         // MSFTGQL only
MICROSOFT: 'MICROSOFT';                 // MSFTGQL only
MSFTGQL: 'MSFTGQL';                     // MSFTGQL only
NUMBER: 'NUMBER';
NUMERIC: 'NUMERIC';
ON: 'ON';
OPEN: 'OPEN';
PARTITION: 'PARTITION';
PRAGMA: 'PRAGMA';                       // MSFTGQL only
PREPARE: 'PREPARE';                     // MSFTGQL only
PROCEDURE: 'PROCEDURE';
PRODUCT: 'PRODUCT';
PROJECT: 'PROJECT';
QUERY: 'QUERY';
RECORDS: 'RECORDS';
REFERENCE: 'REFERENCE';
RENAME: 'RENAME';
REVOKE: 'REVOKE';
RELATIONSHIP: 'RELATIONSHIP';           // MSFTQGL only
RELATIONSHIPS: 'RELATIONSHIPS';         // MSFTGQL only
SHOW: 'SHOW';                           // MSFTGQL only
SUBSTRING: 'SUBSTRING';
SYSTEM_USER: 'SYSTEM_USER';
TEXT: 'TEXT';                           // MSFTGQL only
TEMPORAL: 'TEMPORAL';
UNIQUE: 'UNIQUE';
UNIT: 'UNIT';
UPDATE: 'UPDATE';                       // MSFTQGL only
USING: 'USING';                         // MSFTGQL only (reserved for future use for specifying hints)
VALUES: 'VALUES';
VECTOR: 'VECTOR';                      // MSFTGQL only: Reserved for future vector type

// Non-reserved words
ACYCLIC: 'ACYCLIC';
BINDING: 'BINDING';
BINDINGS: 'BINDINGS';
CONNECTING: 'CONNECTING';
DAY: 'DAY';                             // Non-reserved in MSFTGQL only
DAYS: 'DAYS';                           // MSFTGQL only
DESTINATION: 'DESTINATION';
DIFFERENT: 'DIFFERENT';
DIRECTED: 'DIRECTED';
FIRST: 'FIRST';
GRAPH: 'GRAPH';
GROUPS: 'GROUPS';
HOUR: 'HOUR';                           // Non-reserved in MSFTGQL only
HOURS: 'HOURS';                         // MSFTGQL only
KEEP: 'KEEP';
LABELED: 'LABELED';
LAST: 'LAST';
MICROSECOND: 'MICROSECOND';             // MSFTGQL only
MICROSECONDS: 'MICROSECONDS';           // MSFTGQL only
MILLISECOND: 'MILLISECOND';             // MSFTGQL only
MILLISECONDS: 'MILLISECONDS';           // MSFTGQL only
MINUTE: 'MINUTE';                       // Non-reserved in MSFTGQL only
MINUTES: 'MINUTES';                     // MSFTGQL only
MONTH: 'MONTH';                         // Non-reserved in MSFTGQL only
MONTHS: 'MONTHS';                       // MSFTGQL only
NANOSECOND: 'NANOSECOND';               // MSFTGQL only
NANOSECONDS: 'NANOSECONDS';             // MSFTGQL only
NFC: 'NFC';
NFD: 'NFD';
NFKC: 'NFKC';
NFKD: 'NFKD';
NO: 'NO';
NORMALIZED: 'NORMALIZED';
ONLY: 'ONLY';
ORDINALITY: 'ORDINALITY';
OVER: 'OVER';                           // MSFTGQL only: Reserved for future use
PER: 'PER';                             // MSFTGQL only: Reserved for future use
PRIMARY: 'PRIMARY';                     // MSFTGQL only
PROPERTY: 'PROPERTY';
READ: 'READ';
REPEATABLE: 'REPEATABLE';
REQUIRE: 'REQUIRE';                     // MSFTGQL only
SECOND: 'SECOND';                       // Non-reserved in MSFTGQL only
SECONDS: 'SECONDS';                     // Non-reserved in MSFTGQL only
SHORTEST: 'SHORTEST';
SIMPLE: 'SIMPLE';
SOURCE: 'SOURCE';
TABLE: 'TABLE';
TEMP: 'TEMP';
TIMEZONE: 'TIMEZONE';                   // Non-reserved in MSFTGQL only
TO: 'TO';
TRAIL: 'TRAIL';
TRANSACTION: 'TRANSACTION';
TYPE: 'TYPE';
UNDIRECTED: 'UNDIRECTED';
WALK: 'WALK';
WEEK: 'WEEK';                           // MSFTGQL only
WEEKS: 'WEEKS';                         // MSFTGQL only
WITHOUT: 'WITHOUT';
WRITE: 'WRITE';
YEAR: 'YEAR';                           // MSFTGQL only
YEARS: 'YEARS';                         // MSFTGQL only
ZONE: 'ZONE';

fragment PARAMETER_NAME
    : SEPARATED_IDENTIFIER
    ;

// Since this is used in the definition of other lexial tokens only,
// nonReservedWords do not need to be handled here.
fragment SEPARATED_IDENTIFIER
    : DELIMITED_IDENTIFIER
    | EXTENDED_IDENTIFIER
    ;

REGULAR_IDENTIFIER
    : IDENTIFIER_START IDENTIFIER_EXTEND*
    // Forward-looking way to allow identifiers with leading underscores that still reserves single underscore based on
    // current discussions to use single underscore for default variables.
    | UNDERSCORE IDENTIFIER_EXTEND+
    ;

fragment EXTENDED_IDENTIFIER
    : IDENTIFIER_EXTEND+
    ;

fragment DELIMITED_IDENTIFIER
    : DOUBLE_QUOTED_CHARACTER_SEQUENCE
    | ACCENT_QUOTED_CHARACTER_SEQUENCE
    ;

SUBSTITUTED_PARAMETER_REFERENCE
    : DOUBLE_DOLLAR_SIGN PARAMETER_NAME
    ;

GENERAL_PARAMETER_REFERENCE
    : DOLLAR_SIGN PARAMETER_NAME
    ;

/* Correct identifier definition

fragment IDENTIFIER_START
    : ID_Start
    | Pc
    ;

fragment IDENTIFIER_EXTEND
    : ID_Continue
    ;

fragment ID_Start
    : [\p{ID_Start}]
    ;

fragment ID_Continue
    : [\p{ID_Continue}]
    ;
*/

fragment IDENTIFIER_START
    : XID_Start
    ;

fragment IDENTIFIER_EXTEND
    : XID_Continue
    ;

fragment XID_Start
    : [\p{XID_Start}]
    ;

fragment XID_Continue
    : [\p{XID_Continue}]
    ;

MULTISET_ALTERNATION_OPERATOR: '|+|';
BRACKET_RIGHT_ARROW: ']->';
BRACKET_TILDE_RIGHT_ARROW: ']~>';
CONCATENATION_OPERATOR: '||';
DOUBLE_COLON: '::';
DOUBLE_DOLLAR_SIGN: '$$';
DOUBLE_PERIOD: '..';
GREATER_THAN_OR_EQUALS_OPERATOR: '>=';
LEFT_ARROW: '<-';
LEFT_ARROW_TILDE: '<~';
LEFT_ARROW_BRACKET: '<-[';
LEFT_ARROW_TILDE_BRACKET: '<~[';
LEFT_MINUS_RIGHT: '<->';
LEFT_MINUS_SLASH: '<-/';
LEFT_TILDE_SLASH: '<~/';
LESS_THAN_OR_EQUALS_OPERATOR: '<=';
MINUS_LEFT_BRACKET: '-[';
MINUS_SLASH: '-/';
NOT_EQUALS_OPERATOR: '<>';
PLUS_EQUALS_OPERATOR: '+=';                     // MSFTGQL only
RIGHT_ARROW: '->';
RIGHT_BRACKET_MINUS: ']-';
RIGHT_BRACKET_TILDE: ']~';
RIGHT_DOUBLE_ARROW: '=>';
SLASH_MINUS: '/-';
SLASH_MINUS_RIGHT: '/->';
SLASH_TILDE: '/~';
SLASH_TILDE_RIGHT: '/~>';
TILDE_LEFT_BRACKET: '~[';
TILDE_RIGHT_ARROW: '~>';
TILDE_SLASH: '~/';

/* M1: Inline IMPLIES

IMPLIES
    : RIGHT_DOUBLE_ARROW
    | 'IMPLIES'
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 21.4 <GQL terminal character>
// ---------------------------------------------------------------------------------------------------------------------

AMPERSAND: '&';
ASTERISK: '*';
CARET: '^';                     // Outside GQL; reserved for future use
COLON: ':';
COMMA: ',';
// COMMERCIAL_AT: '@';          // Inlined and hence disabled as a separate token
DOLLAR_SIGN: '$';
DOUBLE_QUOTE: '"';
EQUALS_OPERATOR: '=';
EXCLAMATION_MARK: '!';
RIGHT_ANGLE_BRACKET: '>';
GRAVE_ACCENT: '`';
HASH_MARK: '#';                 // Outside GQL; reserved for future use
LEFT_BRACE: '{';
LEFT_BRACKET: '[';
LEFT_PAREN: '(';
LEFT_ANGLE_BRACKET: '<';
MINUS_SIGN: '-';
PERCENT_SIGN: '%';              // Renamed for clarity
PERIOD_SIGN: '.';               // Renamed for clarity (PERIOD is a reserved word in SQL)
PLUS_SIGN: '+';
QUESTION_MARK: '?';
QUOTE: '\'';
REVERSE_SOLIDUS: '\\';
RIGHT_BRACE: '}';
RIGHT_BRACKET: ']';
RIGHT_PAREN: ')';
SOLIDUS: '/';
TILDE: '~';
UNDERSCORE: '_';
VERTICAL_BAR: '|';

fragment HEX_DIGIT
    : [0-9a-f]
    ;

fragment DIGIT
    : [0-9]
    ;

fragment OCTAL_DIGIT
    : [0-7]
    ;

fragment BINARY_DIGIT
    : [0-1]
    ;

// Comments are to be treated as whitespace according to GQL
SP
  : (WHITESPACE|SIMPLE_COMMENT_MINUS|SIMPLE_COMMENT_SOLIDUS|BRACKETED_COMMENT)+
  -> channel(HIDDEN)
  ;

WHITESPACE
/* Prefer Unicode definition of white space

    : SPACE
    | TAB
    | LF
    | VT
    | FF
    | CR
    | FS
    | GS
    | RS
    | US
    | '\u1680'
    | '\u180e'
    | '\u2000'
    | '\u2001'
    | '\u2002'
    | '\u2003'
    | '\u2004'
    | '\u2005'
    | '\u2006'
    | '\u2008'
    | '\u2009'
    | '\u200a'
    | '\u2028'
    | '\u2029'
    | '\u205f'
    | '\u3000'
    | '\u00a0'
    | '\u2007'
    | '\u202f'
*/
    : [\p{White_Space}]
    ;

BRACKETED_COMMENT: '/*' .*? '*/' -> channel(HIDDEN);

SIMPLE_COMMENT_SOLIDUS: '//' ~[\r\n]* -> channel(HIDDEN);

SIMPLE_COMMENT_MINUS: '--' ~[\r\n]* -> channel(HIDDEN);

// fragment GS : [\u001D];

// fragment FS : [\u001C];

fragment CR : [\r];

// fragment Sc : [\p{Sc}];

fragment SPACE : [ ];

// fragment Pc : [\p{Pc}];

// fragment TAB : [\t];

fragment LF : [\n];

// fragment VT : [\u000B];

// fragment US : [\u001F];

// fragment FF: [\f];

// fragment RS: [\u001E];
