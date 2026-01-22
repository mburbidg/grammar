/* =====================================================================================================================
   GQL_PARTICLES.g4
   =====================================================================================================================

   This file defines various auxiliary productions of OpenGQL.

   See OpenGQL.g4 for further information on the OpenGQL grammar.
*/
grammar GQL_PARTICLES;

import GQL_NAMES;

// =====================================================================================================================
// 16 Common elements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 16.8 <label expression>
// ---------------------------------------------------------------------------------------------------------------------

labelExpression
/* Adjust label expressions

    : EXCLAMATION_MARK labelExpression                  #labelExpressionNegation
    | labelExpression AMPERSAND labelExpression         #labelExpressionConjunction
    | labelExpression VERTICAL_BAR labelExpression      #labelExpressionDisjunction
    | labelName                                         #labelExpressionName
    | PERCENT                                           #labelExpressionWildcard
    | LEFT_PAREN labelExpression RIGHT_PAREN            #labelExpressionParenthesized
*/
    : EXCLAMATION_MARK? labelPrimary                    #labelExprPrimary
    | labelExpression AMPERSAND labelExpression         #labelExprConjunction
    | labelExpression VERTICAL_BAR labelExpression      #labelExprDisjunction
    ;

labelPrimary
    : labelName                                         #labelPrimaryByName
    | LEFT_PAREN labelExpression RIGHT_PAREN            #labelPrimaryByExpr
    ;

// =====================================================================================================================
// 18 Type elements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 18.9 <value type>
// ---------------------------------------------------------------------------------------------------------------------

listValueTypeName
/* Disable syntax for group characteristic of list value types

   It is recommended to keep this production for future extensibility.

    : GROUP? listValueTypeNameSynonym
*/
    : LIST
    | ARRAY
    ;

/* Inline listValueTypeNameSynonym

listValueTypeNameSynonym
    : LIST
    | ARRAY
    ;
*/

// =====================================================================================================================
// 20 Value expressions and specifications
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 20.3 <value specification>
// ---------------------------------------------------------------------------------------------------------------------

nonNegativeIntegerSpecification
    : unsignedInteger
    | dynamicParameterSpecification
    ;

/* Inline generalValueSpecification

generalValueSpecification
    : dynamicParameterSpecification
    | SESSION_USER
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 20.4 <dynamic parameter specification>
// ---------------------------------------------------------------------------------------------------------------------

dynamicParameterSpecification
    : GENERAL_PARAMETER_REFERENCE
    ;

// =====================================================================================================================
// 21 Lexical elements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 21.2 <literal>
// ---------------------------------------------------------------------------------------------------------------------

unsignedInteger
    : UNSIGNED_DECIMAL_INTEGER
    | UNSIGNED_HEXADECIMAL_INTEGER
    | UNSIGNED_OCTAL_INTEGER
    | UNSIGNED_BINARY_INTEGER
    ;

unsignedDecimalInteger
    : UNSIGNED_DECIMAL_INTEGER
    ;
