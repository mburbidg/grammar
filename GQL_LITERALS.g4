grammar GQL_LITERALS;

import GQL_PARTICLES;

// =====================================================================================================================
// 21 Lexical elements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 21.2 <literal>
// ---------------------------------------------------------------------------------------------------------------------

/* M2: Further simplify literals

unsignedLiteral
    : unsignedNumericLiteral
    | generalLiteral
    ;

generalLiteral
    : BOOLEAN_LITERAL
    | characterStringLiteral
    | BYTE_STRING_LITERAL
    | temporalLiteral
    | durationLiteral
    | nullLiteral
    | listLiteral
    | recordLiteral
    ;
*/

valueLiteral
    : signedLiteral
/* M2: Inline generalValueSpecification
*/
    | recordLiteral
    | listValueLiteral
    | dynamicParameterSpecification
    | SESSION_USER
    ;

signedLiteral
    : (PLUS_SIGN | MINUS_SIGN)? unsignedNumericLiteral
    | nonNumericLiteral
    ;

recordLiteral
    : RECORD? LEFT_BRACE (fields+=fieldLiteral (COMMA fields+=fieldLiteral)*)? RIGHT_BRACE
    ;

fieldLiteral
    : fieldName COLON valueLiteral
    ;

listValueLiteral
    : listValueTypeName? LEFT_BRACKET (vals+=valueLiteral (COMMA vals+=valueLiteral)*)? RIGHT_BRACKET
    ;

// ^^^ Extension: GQL-preamble

/* Inline unsignedLiteral

unsignedLiteral
    : unsignedNumericLiteral
    | nonNumericLiteral
    ;
*/

nonNumericLiteral
    : BOOLEAN_LITERAL
    | characterStringLiteral
    | byteStringLiteral
    | temporalInstantLiteral
    | temporalDurationLiteral
    | nullLiteral
    ;

temporalInstantLiteral
    : dateLiteral
    | timeLiteral
    | datetimeLiteral
//    | sqlDatetimeLiteral
    ;

dateLiteral
    : DATE dateString
    ;

timeLiteral
    : TIME timeString
    ;

datetimeLiteral
    : (DATETIME | TIMESTAMP) datetimeString
    ;

/* Simpilify list value constructor grammar

listLiteral
    : listValueConstructorByEnumeration

recordLiteral
    : recordConstructorByEnumeration
    ;
*/

timeZoneString
    : characterStringLiteral
    ;

characterStringLiteral
    : SINGLE_QUOTED_CHARACTER_SEQUENCE  #characterStringLiteralInSQuotes
    | DOUBLE_QUOTED_CHARACTER_SEQUENCE  #characterStringLiteralInDQuotes
    ;

byteStringLiteral
    : BYTE_STRING_LITERAL
    ;

unsignedNumericLiteral
    : exactNumericLiteral
    | approximateNumericLiteral
    ;

exactNumericLiteral
    : UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION_WITH_EXACT_NUMBER_SUFFIX
    | UNSIGNED_DECIMAL_IN_COMMON_NOTATION_WITH_EXACT_NUMBER_SUFFIX
    | UNSIGNED_DECIMAL_IN_COMMON_NOTATION_WITHOUT_SUFFIX
    | UNSIGNED_DECIMAL_INTEGER_WITH_EXACT_NUMBER_SUFFIX
    | UNSIGNED_DECIMAL_INTEGER_WITH_UNSIGNED_SUFFIX    // MSFTGQL only
    | unsignedInteger
    ;

approximateNumericLiteral
    : UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION_WITH_APPROXIMATE_NUMBER_SUFFIX
    | UNSIGNED_DECIMAL_IN_SCIENTIFIC_NOTATION_WITHOUT_SUFFIX
    | UNSIGNED_DECIMAL_IN_COMMON_NOTATION_WITH_APPROXIMATE_NUMBER_SUFFIX
    | UNSIGNED_DECIMAL_INTEGER_WITH_APPROXIMATE_NUMBER_SUFFIX
    ;

nullLiteral
    : NULL_TOKEN
    ;

dateString
    : characterStringLiteral
    ;

timeString
    : characterStringLiteral
    ;

datetimeString
    : characterStringLiteral
    ;

temporalDurationLiteral
    : DURATION durationString
//    | sqlIntervalLiteral
    ;

durationString
    : characterStringLiteral
    ;
