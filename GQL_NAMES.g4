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

/* Disable primary object expressions

objectNameOrBindingVariable
    : regularIdentifier
    ;
*/

/* Disable schema references

directoryName
    : identifier
    ;

schemaName
    : identifier
    ;
*/

graphName
    : anyIdent
    ;

/* Disable primary object expressions

delimitedGraphName
    : delimitedIdentifier
    ;
*/

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

/* Disable primary object expressions for now

bindingTableName
    : identifier
    ;

delimitedBindingTableName
     : delimitedIdentifier
     ;
*/

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

