/* =====================================================================================================================
   GQL_NAMES.g4
   =====================================================================================================================

   This file defines the productions of OpenGQL for various names.

   See OpenGQL.g4 for further information on the OpenGQL grammar.
*/
grammar GQL_NAMES;

import GQL_IDENTS;

// =====================================================================================================================
// 21 Lexical elements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 21.1 Names and Variables
// ---------------------------------------------------------------------------------------------------------------------

objectName
    : anyIdent
    ;

objectNameOrBindingVariable
    : varIdent
    ;

directoryName
    : anyIdent
    ;

schemaName
    : anyIdent
    ;

graphName
    : anyIdent
    ;

delimitedGraphName
    // DELIMITED_IDENTIFIER
    : DOUBLE_QUOTED_CHARACTER_SEQUENCE
    | ACCENT_QUOTED_CHARACTER_SEQUENCE
    ;

/* Disable DDL and DML

graphTypeName
    : identifier
    ;
*/

/* Disable graph element type names

nodeTypeName
    : identifier
    ;

edgeTypeName
    : identifier
    ;
*/

bindingTableName
    : anyIdent
    | delimitedBindingTableName
    ;

delimitedBindingTableName
    // DELIMITED_IDENTIFIER
    : DOUBLE_QUOTED_CHARACTER_SEQUENCE
    | ACCENT_QUOTED_CHARACTER_SEQUENCE
    ;

procedureName
    : anyIdent
    ;

// Extension: constraints
constraintName
    : anyIdent
    ;

labelName
    : anyIdent
    ;

propertyName
    : anyIdent
    ;

fieldName
    : anyIdent
    ;

/* Clarify distinction between variable declaration and reference

elementVariable
    : bindingVariable
    ;

pathVariable
    : bindingVariable
    ;
*/

/* Remove now unused subpath variable

subpathVariable
    : variableIdentifier
    ;
*/

bindingVariable
    : varIdent
    ;

