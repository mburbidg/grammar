/* =====================================================================================================================
   GQL_PROCEDURES.g4
   =====================================================================================================================

   This file defines the productions of OpenGQL for procedures, expressions, and predicates.

   See OpenGQL.g4 for further information on the OpenGQL grammar.
*/
grammar GQL_PROCEDURES;

import GQL_IDENTS,
       GQL_NAMES,
       GQL_PARTICLES,
       GQL_LITERALS,
       GQL_VTYPES,
       GQL_OTYPES,
       GQL_DDL;

// =====================================================================================================================
// 9 Procedure specification
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 9.1 <nested procedure specification>
// ---------------------------------------------------------------------------------------------------------------------

nestedProcedureSpecification
    : LEFT_BRACE proc=procedureSpecification RIGHT_BRACE
    ;

// The rules <catalog-modifying procedure specification>, <data-modifying procedure specification> and
// <query specification> are identical productions. The GQL specification distinguishes them in the BNF,
// but an implementation has to make the distinction semantically, in code, based on the kind of statements contained in
// the <procedure specification>. They have been removed here. [openGQL]
procedureSpecification
/* Inline procedureBody */
    : atSchemaClause? varBlock=bindingVariableDefinitionBlock? stmBlock=statementBlock
    ;

nestedDataModifyingProcedureSpecification
    : LEFT_BRACE procedureSpecification RIGHT_BRACE
    ;

nestedQuerySpecification
/*  M1: Inline procedure body

    : LEFT_BRACE procedureBody RIGHT_BRACE
*/
    : LEFT_BRACE proc=procedureSpecification RIGHT_BRACE
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 9.2 <procedure body>
// ---------------------------------------------------------------------------------------------------------------------

/* - Inline and simplify procedure body
procedureBody
    : atSchemaClause? bindingVariableDefinitionBlock? statementBlock
    ;
*/

bindingVariableDefinitionBlock
    : bindingVariableDefinition+
    ;

bindingVariableDefinition
    : graphVariableDefinition
    | bindingTableVariableDefinition
    | valueVariableDefinition
    ;

statementBlock
    : statement nextStatement*
    // Putting this here is a mild deviation from GQL reflecting the fact that we want to support
    // at most one DDL statement right now
    | primitiveCatalogModifyingStatement
    ;

statement
/* Disable original DDL and DML

    : linearCatalogModifyingStatement
    | linearDataModifyingStatement
    | compositeQueryStatement
*/
/* Rename compositeQueryStatement to compositeStatement

    : compositeQueryStatement
 */
    : compositeStatement
/* Add <conditional statement> from latest draft
*/
    | conditionalStatement
    ;

nextStatement
    : NEXT yieldClause? statement
    ;


// =====================================================================================================================
// 10 Variable definitions
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 10.1 <graph variable definition>
// ---------------------------------------------------------------------------------------------------------------------

graphVariableDefinition
    : PROPERTY? GRAPH bindingVariable optTypedGraphInitializer
    ;

optTypedGraphInitializer
    : (( DOUBLE_COLON | TYPED )? graphReferenceValueType)? graphInitializer
    ;

graphInitializer
    : EQUALS_OPERATOR graphExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 10.2 <binding table variable definition>
// ---------------------------------------------------------------------------------------------------------------------

bindingTableVariableDefinition
    : BINDING? TABLE bindingVariable optTypedBindingTableInitializer
    ;

optTypedBindingTableInitializer
    : (( DOUBLE_COLON | TYPED )? bindingTableReferenceValueType)? bindingTableInitializer
    ;

bindingTableInitializer
    : EQUALS_OPERATOR bindingTableExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 10.3 <value variable definition>
// ---------------------------------------------------------------------------------------------------------------------

valueVariableDefinition
/* Inline optTypedValueInitializer

    : VALUE bindingVariable optTypedValueInitializer
*/
    : VALUE var=bindingVariable init=valueInitializer
    ;

optTypedValueInitializer
    : (( DOUBLE_COLON | TYPED )? valueType)? valueInitializer
    ;

valueInitializer
    : EQUALS_OPERATOR expr=valueExpression
    ;

// =====================================================================================================================
// 11 Object expressions
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 11.1 <graph expression>
// ---------------------------------------------------------------------------------------------------------------------

graphExpression
    : graphReference
    | objectExpressionPrimary
    | objectNameOrBindingVariable
    | currentGraph
    ;

currentGraph
    : CURRENT_PROPERTY_GRAPH
    | CURRENT_GRAPH
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 11.2 <binding table expression>
// ---------------------------------------------------------------------------------------------------------------------

bindingTableExpression
    : nestedBindingTableQuerySpecification
    | bindingTableReference
    | objectExpressionPrimary
    | objectNameOrBindingVariable
    ;

nestedBindingTableQuerySpecification
    : nestedQuerySpecification
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 11.3 <object expression primary>
// ---------------------------------------------------------------------------------------------------------------------

objectExpressionPrimary
    : VARIABLE prim=valueExpressionPrimary              #primaryExp
    | LEFT_PAREN expr=valueExpression RIGHT_PAREN       #parenExpr
    | scPrim=valueExpressionPrimarySpecialCase          #specialCase
    // Suggestion: Since regular literals have been removed from valueExpressionPrimarySpecialCase in MSFTGQL,
    // at least parameter specifications should be added here once this is commented in again
    ;


// =====================================================================================================================
// 13 Data-modifying statements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 13.1 <linear data-modifying statement>
// ---------------------------------------------------------------------------------------------------------------------

linearDataModifyingStatement
    : focusedLinearDataModifyingStatement
    | ambientLinearDataModifyingStatement
    ;

focusedLinearDataModifyingStatement
    : focusedLinearDataModifyingStatementBody
    | focusedNestedDataModifyingProcedureSpecification
    ;

focusedLinearDataModifyingStatementBody
    : useGraphClause simpleLinearDataAccessingStatement primitiveResultStatement?
    ;

focusedNestedDataModifyingProcedureSpecification
    : useGraphClause nestedDataModifyingProcedureSpecification
    ;

ambientLinearDataModifyingStatement
    : ambientLinearDataModifyingStatementBody
    | nestedDataModifyingProcedureSpecification
    ;

ambientLinearDataModifyingStatementBody
    : simpleLinearDataAccessingStatement primitiveResultStatement?
    ;

simpleLinearDataAccessingStatement
    : simpleDataAccessingStatement+
    ;

simpleDataAccessingStatement
    : simpleQueryStatement
    | simpleDataModifyingStatement
    ;

simpleDataModifyingStatement
    : primitiveDataModifyingStatement
    | callDataModifyingProcedureStatement
    ;

primitiveDataModifyingStatement
    : insertStatement
    | setStatement
    | removeStatement
    | deleteStatement
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 13.2 <insertStatement>
// ---------------------------------------------------------------------------------------------------------------------

insertStatement
    : INSERT insertGraphPattern
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 13.3 <set statement>
// ---------------------------------------------------------------------------------------------------------------------

setStatement
    : SET setItemList
    ;

setItemList
    : setItem (COMMA setItem)*
    ;

setItem
    : setPropertyItem
    | setAllPropertiesItem
    | setLabelItem
    ;

setPropertyItem
    : bindingVariableReference PERIOD_SIGN propertyName EQUALS_OPERATOR valueExpression
    ;

setAllPropertiesItem
    : bindingVariableReference EQUALS_OPERATOR LEFT_BRACE propertySpecificationList? RIGHT_BRACE
    ;

setLabelItem
    : bindingVariableReference ( IS | COLON ) labelName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 13.4 <remove statement>
// ---------------------------------------------------------------------------------------------------------------------

removeStatement
    : REMOVE removeItemList
    ;

removeItemList
    : removeItem (COMMA removeItem)*
    ;

removeItem
    : removePropertyItem
    | removeLabelItem
    ;

removePropertyItem
    : bindingVariableReference PERIOD_SIGN propertyName
    ;

removeLabelItem
    : bindingVariableReference ( IS | COLON ) labelName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 13.5 <delete statement>
// ---------------------------------------------------------------------------------------------------------------------

deleteStatement
    : (DETACH | NODETACH)? DELETE deleteItemList
    ;

deleteItemList
    : deleteItem (COMMA deleteItem)*
    ;

deleteItem
    : valueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 13.6 <call data-modifying procedure statement>
// ---------------------------------------------------------------------------------------------------------------------

callDataModifyingProcedureStatement
    : callProcedureStatement
    ;

// =====================================================================================================================
// 14 Query statements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 14.1 <composite query statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Rename compositeQueryStatement to compositeStatement

compositeQueryStatement
    : compositeQueryExpression
    ;
*/

compositeStatement
/* - Inline compositeQueryExpression
   - Replace linearQueryStatement with linearStatement and split out linearStatementBody

   : linearQueryStatement (queryConjunction linearQueryStatement)*
*/
    : linearStatement (queryConjunction linearStatement)*
    ;

/* Inline linearStatementBody

linearStatement
    : useGraphClause? nested=nestedProcedureSpecification       #linearStatementByProc
    | body=linearStatementBody                                  #linearStatementByBody
    | selectStatement                                           #linearStatementBySelect
    ;
*/
linearStatement
    : use=useGraphClause? nested=nestedProcedureSpecification                          #nestedLinearStatement
    | (stmList+=primitiveStatement)* resultStm=primitiveResultStatement                #ambientLinearStatement
    | (focusedStmList+=focusedPrimitiveStatement)+ resultStm=primitiveResultStatement  #focusedLinearStatement
    | select=selectStatement                                                           #selectLinearStatement
    ;

focusedPrimitiveStatement
    : use=useGraphClause (stmList+=primitiveStatement)*
    ;

/* Inline linearStatementBody

linearStatementBody
    : (stmList+=primitiveStatement)+ resultStm=primitiveResultStatement           #linearStatementBodyAlt1
    | ( useGraphClause primitiveStatement+)+ resultStm=primitiveResultStatement   #linearStatementBodyAlt2
    | resultStm=primitiveResultStatement                                          #linearStatementBodyAlt3
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 14.2 <composite query expression>
// ---------------------------------------------------------------------------------------------------------------------

/* Inline compositeQueryExpression

compositeQueryExpression
    : compositeQueryExpression queryConjunction compositeQueryPrimary
    | compositeQueryPrimary
    ;
*/

queryConjunction
    : setOperator
    | OTHERWISE
    ;

setOperator
    : UNION setQuantifier?
    | EXCEPT setQuantifier?
    | INTERSECT setQuantifier?
    ;

/* Inline compositeQueryExpression

compositeQueryPrimary
    : linearQueryStatement
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 14.3 <linear query statement> and <simple query statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable USE and SELECT
   Replace linearQueryStatement with linearStatement

linearQueryStatement
    : focusedLinearQueryStatement
    | ambientLinearQueryStatement
*/

/* Disable USE

focusedLinearQueryStatement
    : focusedLinearQueryStatementPart* focusedLinearQueryAndPrimitiveResultStatementPart
    | focusedPrimitiveResultStatement
    | focusedNestedQuerySpecification
    | selectStatement
    ;

focusedLinearQueryStatementPart
    : useGraphClause simpleLinearQueryStatement
    ;

focusedLinearQueryAndPrimitiveResultStatementPart
    : useGraphClause simpleLinearQueryStatement primitiveResultStatement
    ;

focusedPrimitiveResultStatement
    : useGraphClause primitiveResultStatement
    ;

focusedNestedQuerySpecification
    : useGraphClause nestedQuerySpecification
    ;
*/

/* Replace linearQueryStatement with linearStatement

ambientLinearQueryStatement
    : simpleLinearQueryStatement? primitiveResultStatement
    | nestedQuerySpecification
    ;

simpleLinearQueryStatement
    : simpleQueryStatement+
    ;
*/

simpleQueryStatement
    : primitiveQueryStatement
    | callQueryStatement
    ;

primitiveStatement
    : primitiveQueryStatement
//  | primitiveDataModifyingdStatement
//  | primitiveCatalogModifyingStatement
    | callProcedureStatement
    ;

primitiveQueryStatement
    : matchStatement
    | letStatement
    | forStatement
    | filterStatement
    | orderByAndPageStatement
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 14.4 <match statement>
// ---------------------------------------------------------------------------------------------------------------------

matchStatement
    : simpleMatchStatement
    | optionalMatchStatement
    ;

simpleMatchStatement
/* Inline graphPatternBindingTable

    : MATCH graphPatternBindingTable
*/
    : MATCH graphPattern /* graphPatternYieldClause? */
    ;

optionalMatchStatement
    : OPTIONAL optionalOperand
    ;

optionalOperand
    : simpleMatchStatement
/* Remove matchStatementBlock

    | LEFT_BRACE matchStatementBlock RIGHT_BRACE
    | LEFT_PAREN matchStatementBlock RIGHT_PAREN
*/
    ;

/* Remove matchStatementBlock

matchStatementBlock
    : matchStatement+
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 14.5 <call query statement>
// ---------------------------------------------------------------------------------------------------------------------

callQueryStatement
    : callProcedureStatement
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 14.6 <filter statement>
// ---------------------------------------------------------------------------------------------------------------------

filterStatement
    : FILTER (whereClause | pred=booleanValueExpression)
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 14.7 <let statement>
// ---------------------------------------------------------------------------------------------------------------------

letStatement
    : LET letVariableDefinitionList
    ;

letVariableDefinitionList
    : varDefs+=letVariableDefinition (COMMA varDefs+=letVariableDefinition)*
    ;

letVariableDefinition
    : varDef=valueVariableDefinition
    | var=bindingVariable EQUALS_OPERATOR expr=valueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 14.8 <for statement>
// ---------------------------------------------------------------------------------------------------------------------

forStatement
    : FOR item=forItem index=forOrdinalityOrOffset?
    ;

forItem
    : var=bindingVariable IN source=forItemSource
    ;

/* M2: Inline forItemALias

forItemAlias
    : var=bindingVariable IN
    ;
*/

forItemSource
    : expr=valueExpression
    ;

forOrdinalityOrOffset
    : WITH ORDINALITY var=bindingVariable   #forWithOrdinality
    | WITH OFFSET var=bindingVariable       #forWithOffset
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 14.9 <order by and page statement>
// ---------------------------------------------------------------------------------------------------------------------

orderByAndPageStatement
    : orderByClause offsetClause? limitClause?
    | offsetClause limitClause?
    | limitClause
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 14.10 <primitive result statement>
// ---------------------------------------------------------------------------------------------------------------------

primitiveResultStatement
    : FINISH                                    #resultByFinish
    | returnStatement orderByAndPageStatement?  #resultByReturn
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 14.11 <return statement>
// ---------------------------------------------------------------------------------------------------------------------

returnStatement
    : RETURN returnStatementBody
    ;

returnStatementBody
/* - Removal of spec-only RETURN NO BINDINGS
   - Factor out returnItemSpec

    : setQuantifier? (ASTERISK | returnItemList) groupByClause?
    | NO BINDINGS
*/
    : setQuantifier? returnItemSpec groupByClause?
    ;

/* Factor out returnItemSpec
*/
returnItemSpec
    : ASTERISK          #returnStar
    | returnItemList    #returnSome
    ;

returnItemList
    : items+=returnItem (COMMA items+=returnItem)*
    ;

// NOTE: Only optional if the expression is an identifier
returnItem
/* Inline aggregatingValueExpressiom

    : expr=aggregatingValueExpression alias=returnItemAlias?
*/
    : expr=valueExpression AS alias=anyIdent
    | varRef=bindingVariableReference (steps+=returnItemAccessStep)*
    | param=dynamicParameterSpecification (steps+=returnItemAccessStep)*
    ;

returnItemAccessStep
    : PERIOD_SIGN prop=propertyName                                   #retItemPropAccStep
    | LEFT_BRACKET index=unsignedInteger               RIGHT_BRACKET  #retItemLitIdxAccStep
    | LEFT_BRACKET var=bindingVariableReference        RIGHT_BRACKET  #retItemVarIdxAccStep
    | LEFT_BRACKET param=dynamicParameterSpecification RIGHT_BRACKET  #retItemParamIdxAccStep
    ;

/* Inline returnItemAlias

returnItemAlias
    : AS alias=anyIdent
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 14.12 <select statement>
// ---------------------------------------------------------------------------------------------------------------------

selectStatement
    : SELECT setQuantifier? (ASTERISK | selectItemList)
      (selectStatementBody whereClause? groupByClause? havingClause? orderByClause? offsetClause? limitClause?)?
    ;

selectItemList
    : items+=selectItem (COMMA items+=selectItem)*
    ;

selectItem
    : expr=valueExpression (AS alias=anyIdent)?
    ;

/* Inline selectItemAlias

selectItemAlias
    : AS anyIdent
    ;
*/

havingClause
    : HAVING pred=booleanValueExpression
    ;

selectStatementBody
    : FROM (selectGraphMatchList | selectQuerySpecification)
    ;

selectGraphMatchList
    : graphMatches+=selectGraphMatch (COMMA graphMatches+=selectGraphMatch)*
    ;

selectGraphMatch
/* Allow ambient graph matching in SELECT (This is a minor relaxation from GQL)

    : graphExpression matchStatement
*/
    : graphExpr=graphExpression? stm=matchStatement
    ;

selectQuerySpecification
/* Allow ambient graph matching in SELECT (This is a minor relaxation from GQL)

    : nested=nestedQuerySpecification
    | graphExpression nestedQuerySpecification
*/
    : graphExpr=graphExpression? nested=nestedQuerySpecification
    ;

// =====================================================================================================================
// 15 Procedure calling
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 15.1 <call procedure statement> and <procedure call>
// ---------------------------------------------------------------------------------------------------------------------

callProcedureStatement
    : OPTIONAL? CALL procedureCall
    ;

procedureCall
    : inlineProcedureCall
    | namedProcedureCall
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 15.2 <inline procedure call>
// ---------------------------------------------------------------------------------------------------------------------

inlineProcedureCall
    : variableScopeClause? nested=nestedProcedureSpecification
    ;

variableScopeClause
    : LEFT_PAREN bindingVariableReferenceList? RIGHT_PAREN
    ;

bindingVariableReferenceList
    : varRefs+=bindingVariableReference (COMMA varRefs+=bindingVariableReference)*
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 15.3 <named procedure call>
// ---------------------------------------------------------------------------------------------------------------------

namedProcedureCall
    : procedureReference
        LEFT_PAREN procedureArgumentList? RIGHT_PAREN yieldClause?
    ;

procedureArgumentList
    : args+=procedureArgument (COMMA args+=procedureArgument)*
    ;

procedureArgument
    : expr=valueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 15.4 <conditional statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Add <conditional statement> from latest draft
*/

conditionalStatement
    : searchedConditionalStatement
    ;

searchedConditionalStatement
    : conditionalStatementWhenClause+ conditionalStatementElseClause?
    ;

conditionalStatementWhenClause
    : WHEN pred=booleanValueExpression THEN conditionalStatementResult
    ;

conditionalStatementElseClause
    : ELSE conditionalStatementResult
    ;

conditionalStatementResult
    : linearStatement
    | nestedProcedureSpecification
    ;

// =====================================================================================================================
// 16 Common elements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 16.1 <at schema clasue>
// ---------------------------------------------------------------------------------------------------------------------

atSchemaClause
    : AT schemaReference
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.2 <use graph clause>
// ---------------------------------------------------------------------------------------------------------------------

useGraphClause
    : USE graphExpr=graphExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.3 <graph pattern binding table>
// ---------------------------------------------------------------------------------------------------------------------

/* Remove graphPatternYieldClause
   Inline graphPatternBindingTable

graphPatternBindingTable
    : graphPattern graphPatternYieldClause?
    ;

graphPatternYieldClause
    : YIELD graphPatternYieldItemList
    ;

graphPatternYieldItemList
    : graphPatternYieldItem (COMMA graphPatternYieldItem)*
    | NO BINDINGS
    ;

// <elemement variable reference> and <path variable reference> are identical productions, both consisting
// of a single non-terminal <binding variable reference>. Thus <graph pattern yield item> is ambiguous
// from a parsing standpoint. So here we simply use bindingVariableReference. Post parsing code must
// apply the semantics associated with each type of <binding variable reference>. [openGQL]
graphPatternYieldItem
    : bindingVariableReference
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 16.4 <graph pattern>
// ---------------------------------------------------------------------------------------------------------------------

graphPattern
/* Remove optional keep clause

    : matchMode? pathPatternList keepClause? graphPatternWhereClause?
*/
    : matchMode? pathPatternList whereClause?
    ;

matchMode
    : repeatableElementsMatchMode
    | differentEdgesMatchMode
    ;

repeatableElementsMatchMode
    : REPEATABLE ( ELEMENT BINDINGS? | ELEMENTS )
    ;

differentEdgesMatchMode
    : DIFFERENT ( ( EDGE | RELATIONSHIP ) BINDINGS? | EDGES | RELATIONSHIPS )
    ;

pathPatternList
    : pathPats+=pathPattern (COMMA pathPats+=pathPattern)*
    ;

pathPattern
    : pathVariableDeclaration? pathPatternPrefix? pathPatternExpression
    ;

pathVariableDeclaration
/* Clarify distinction between variable declaration and reference

    : pathVariable EQUALS_OPERATOR
*/
    : var=bindingVariable EQUALS_OPERATOR
    ;

/* Remove optional keep clause

keepClause
    : KEEP pathPatternPrefix
    ;
*/

/* Inline graphPatternWhereClause

graphPatternWhereClause
    : WHERE pred=searchCondition
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 16.5 <insert graph pattern>
// ---------------------------------------------------------------------------------------------------------------------

insertGraphPattern
    : insertPathPatternList
    ;

insertPathPatternList
    : insertPathPattern (COMMA insertPathPattern)*
    ;

insertPathPattern
    : insertNodePattern (insertEdgePattern insertNodePattern)*
    ;

insertNodePattern
    : LEFT_PAREN insertElementPatternFiller? RIGHT_PAREN
    ;

insertEdgePattern
    : insertEdgePointingLeft
    | insertEdgePointingRight
    | insertEdgeUndirected
    ;

insertEdgePointingLeft
    : LEFT_ARROW_BRACKET insertElementPatternFiller? RIGHT_BRACKET_MINUS
    ;

insertEdgePointingRight
    : MINUS_LEFT_BRACKET insertElementPatternFiller? BRACKET_RIGHT_ARROW
    ;

insertEdgeUndirected
    : TILDE_LEFT_BRACKET insertElementPatternFiller? RIGHT_BRACKET_TILDE
    ;

insertElementPatternFiller
    : elementVariableDeclaration labelAndPropertySetSpecification?
    | elementVariableDeclaration? labelAndPropertySetSpecification
    ;

labelAndPropertySetSpecification
    : ( IS | COLON ) labelSetSpecification elementPropertySetSpecification?
    | ((IS | COLON ) labelSetSpecification)? elementPropertySetSpecification
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.6 <path pattern prefix>
// ---------------------------------------------------------------------------------------------------------------------

pathPatternPrefix
    : pathModePrefix
    | pathSearchPrefix
    ;

pathModePrefix
    : pathMode pathOrPaths?
    ;

pathMode
    : WALK
    | TRAIL
    | SIMPLE
    | ACYCLIC
    ;

pathSearchPrefix
    : allPathSearch
/* Remove any path search

    | anyPathSearch
*/
    | shortestPathSearch
    ;

allPathSearch
    : ALL pathMode? pathOrPaths?
    ;

pathOrPaths
    : PATH
    | PATHS
    ;

/* Remove any path search

anyPathSearch
    : ANY numberOfPaths? pathMode? pathOrPaths?
    ;
*/


/* Remove counted shortest path and group search

numberOfPaths
    : nonNegativeIntegerSpecification
    ;
*/

shortestPathSearch
    : allShortestPathSearch
    | anyShortestPathSearch
/* Remove counted shortest path and group search

    | countedShortestPathSearch
    | countedShortestGroupSearch
*/
    ;

allShortestPathSearch
    : ALL SHORTEST pathMode? pathOrPaths?
    ;

anyShortestPathSearch
    : ANY SHORTEST pathMode? pathOrPaths?
    ;

/* Remove counted shortest path and group search

countedShortestPathSearch
    : SHORTEST numberOfPaths pathMode? pathOrPaths?
    ;

countedShortestGroupSearch
    : SHORTEST numberOfGroups? pathMode? pathOrPaths? (GROUP | GROUPS)
    ;

numberOfGroups
    : nonNegativeIntegerSpecification
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 16.7 <path pattern expression>
// ---------------------------------------------------------------------------------------------------------------------

pathPatternExpression
    : pathTerm                                              #ppePathTerm
/* Remove graph pattern choice operators

    | pathTerm (MULTISET_ALTERNATION_OPERATOR pathTerm)+    #ppeMultisetAlternation
    | pathTerm (VERTICAL_BAR pathTerm)+                     #ppePatternUnion
 */
    ;

pathTerm
    : pathFactor+
    ;

pathFactor
    : pathPrimary                           #pfPathPrimary
    | pathPrimary graphPatternQuantifier    #pfQuantifiedPathPrimary
/* Remove questioned path primary

    | pathPrimary QUESTION_MARK             #pfQuestionedPathPrimary
*/
    ;

pathPrimary
    : elementPattern                        #ppElementPattern
/* Remove parenthesized and simplified path pattern expressions

    | parenthesizedPathPatternExpression    #ppParenthesizedPathPatternExpression
    | simplifiedPathPatternExpression       #ppSimplifiedPathPatternExpression
*/
    ;

elementPattern
    : nodePattern
    | edgePattern
    ;

nodePattern
    : LEFT_PAREN filler=elementPatternFiller RIGHT_PAREN
    ;

elementPatternFiller
    : elementVariableDeclaration? isLabelExpression? elementPatternPredicate?
    ;

elementVariableDeclaration
/* - Remove graph pattern choice operators
   - Clarify distinction between variable declaration and reference

    : TEMP? elementVariable
*/
    : var=bindingVariable
    ;

isLabelExpression
/* Inline isOrColon

    : isOrColon labelExpression
*/
    : ( IS | COLON ) labelExpression
    ;

/* Inline isLabeledOrColon

isOrColon
    : IS
    | COLON
    ;
*/

/* - Consistent naming
   - Inline elementPatternWhereClause

elementPatternPredicate
    : elementPatternWhereClause
    | elementPropertySpecification
*/
elementPatternPredicate
    : whereClause
    | elementPropertySetSpecification whereClause?
    ;

/* Inline elementPatternWhereClause

elementPatternWhereClause
    : WHERE pred=searchCondition
    ;
*/

/* Rename propertyKeyValuePair => property and inline propertyList

elementPropertiesSpecification

    : LEFT_BRACE propertyKeyValuePairList RIGHT_BRACE
*/
elementPropertySetSpecification
    : LEFT_BRACE propertySpecificationList? RIGHT_BRACE
    ;

propertySpecificationList
    : props+=propertySpecification (COMMA props+=propertySpecification)*
    ;

/* Rename propertyKeyValuePair => property and inline propertyList

propertyKeyValuePairList
    : propertyKeyValuePair (COMMA propertyKeyValuePair)*
    ;

propertyKeyValuePair
    : propertyName COLON valueExpression
    ;
*/

/* Inline propertyList

propertyList
    : property (COMMA property)*
    ;
*/

propertySpecification
    : propertyName COLON expr=valueExpression
    ;

edgePattern
    : fullEdgePattern
    | abbreviatedEdgePattern
    ;

fullEdgePattern
    : fullEdgePointingLeft
    | fullEdgeUndirected
    | fullEdgePointingRight
    | fullEdgeLeftOrUndirected
    | fullEdgeUndirectedOrRight
    | fullEdgeLeftOrRight
    | fullEdgeAnyDirection
    ;

fullEdgePointingLeft
    : LEFT_ARROW_BRACKET filler=elementPatternFiller RIGHT_BRACKET_MINUS
    ;

fullEdgeUndirected
    : TILDE_LEFT_BRACKET filler=elementPatternFiller RIGHT_BRACKET_TILDE
    ;

fullEdgePointingRight
    : MINUS_LEFT_BRACKET filler=elementPatternFiller BRACKET_RIGHT_ARROW
    ;

fullEdgeLeftOrUndirected
    : LEFT_ARROW_TILDE_BRACKET filler=elementPatternFiller RIGHT_BRACKET_TILDE
    ;

fullEdgeUndirectedOrRight
    : TILDE_LEFT_BRACKET filler=elementPatternFiller BRACKET_TILDE_RIGHT_ARROW
    ;

fullEdgeLeftOrRight
    : LEFT_ARROW_BRACKET filler=elementPatternFiller BRACKET_RIGHT_ARROW
    ;

fullEdgeAnyDirection
    : MINUS_LEFT_BRACKET filler=elementPatternFiller RIGHT_BRACKET_MINUS
    ;

abbreviatedEdgePattern
    : LEFT_ARROW
    | TILDE
    | RIGHT_ARROW
    | LEFT_ARROW_TILDE
    | TILDE_RIGHT_ARROW
    | LEFT_MINUS_RIGHT
    | MINUS_SIGN
    ;

/* Remove parenthesized and simplified path pattern expressions

parenthesizedPathPatternExpression
    : LEFT_PAREN subpathVariableDeclaration? pathModePrefix?
        pathPatternExpression parenthesizedPathPatternWhereClause? RIGHT_PAREN
    ;

subpathVariableDeclaration
    : subpathVariable EQUALS_OPERATOR
    ;

parenthesizedPathPatternWhereClause
    : WHERE searchCondition
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 16.9 <path variable reference>
// ---------------------------------------------------------------------------------------------------------------------

/* Remove unused productions

pathVariableReference
    : bindingVariableReference
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 16.10 <element variable reference>
// ---------------------------------------------------------------------------------------------------------------------

/* Simplify

elementVariableReference
    : bvr=bindingVariableReference
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 16.11 <graph pattern quantifier>
// ---------------------------------------------------------------------------------------------------------------------

graphPatternQuantifier
    : ASTERISK
    | PLUS_SIGN
    | fixedQuantifier
    | generalQuantifier
    ;

fixedQuantifier
    : LEFT_BRACE val=unsignedInteger RIGHT_BRACE
    ;

generalQuantifier
    : LEFT_BRACE lowerBound? COMMA upperBound? RIGHT_BRACE
    ;

lowerBound
    : val=unsignedInteger
    ;

upperBound
    : val=unsignedInteger
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.12 <simplified path pattern expression>
// ---------------------------------------------------------------------------------------------------------------------

/* Remove parenthesized and simplified path pattern expressions

simplifiedPathPatternExpression
    : simplifiedDefaultingLeft
    | simplifiedDefaultingUndirected
    | simplifiedDefaultingRight
    | simplifiedDefaultingLeftOrUndirected
    | simplifiedDefaultingUndirectedOrRight
    | simplifiedDefaultingLeftOrRight
    | simplifiedDefaultingAnyDirection
    ;

simplifiedDefaultingLeft
    : LEFT_MINUS_SLASH simplifiedContents SLASH_MINUS
    ;

simplifiedDefaultingUndirected
    : TILDE_SLASH simplifiedContents SLASH_TILDE
    ;

simplifiedDefaultingRight
    : MINUS_SLASH simplifiedContents SLASH_MINUS_RIGHT
    ;

simplifiedDefaultingLeftOrUndirected
    : LEFT_TILDE_SLASH simplifiedContents SLASH_TILDE
    ;

simplifiedDefaultingUndirectedOrRight
    : TILDE_SLASH simplifiedContents SLASH_TILDE_RIGHT
    ;

simplifiedDefaultingLeftOrRight
    : LEFT_MINUS_SLASH simplifiedContents SLASH_MINUS_RIGHT
    ;

simplifiedDefaultingAnyDirection
    : MINUS_SLASH simplifiedContents SLASH_MINUS
    ;

simplifiedContents
    : simplifiedTerm
    | simplifiedPathUnion
    | simplifiedMultisetAlternation
    ;

simplifiedPathUnion
    : simplifiedTerm VERTICAL_BAR simplifiedTerm (VERTICAL_BAR simplifiedTerm)*
    ;

simplifiedMultisetAlternation
    : simplifiedTerm MULTISET_ALTERNATION_OPERATOR simplifiedTerm (MULTISET_ALTERNATION_OPERATOR simplifiedTerm)*
    ;

simplifiedTerm
    : simplifiedFactorLow                        #simplifiedFactorLowLabel
    | simplifiedTerm simplifiedFactorLow         #simplifiedConcatenationLabel
    ;

simplifiedFactorLow
    : simplifiedFactorHigh                               #simplifiedFactorHighLabel
    | simplifiedFactorLow AMPERSAND simplifiedFactorHigh #simplifiedConjunctionLabel
    ;

simplifiedFactorHigh
    : simplifiedTertiary
    | simplifiedQuantified
    | simplifiedQuestioned
    ;

simplifiedQuantified
    : simplifiedTertiary graphPatternQuantifier
    ;

simplifiedQuestioned
    : simplifiedTertiary QUESTION_MARK
    ;

simplifiedTertiary
    : simplifiedDirectionOverride
    | simplifiedSecondary
    ;

simplifiedDirectionOverride
    : simplifiedOverrideLeft
    | simplifiedOverrideUndirected
    | simplifiedOverrideRight
    | simplifiedOverrideLeftOrUndirected
    | simplifiedOverrideUndirectedOrRight
    | simplifiedOverrideLeftOrRight
    | simplifiedOverrideAnyDirection
    ;

simplifiedOverrideLeft
    : LEFT_ANGLE_BRACKET simplifiedSecondary
    ;

simplifiedOverrideUndirected
    : TILDE simplifiedSecondary
    ;

simplifiedOverrideRight
    : simplifiedSecondary RIGHT_ANGLE_BRACKET
    ;

simplifiedOverrideLeftOrUndirected
    : LEFT_ARROW_TILDE simplifiedSecondary
    ;

simplifiedOverrideUndirectedOrRight
    : TILDE simplifiedSecondary RIGHT_ANGLE_BRACKET
    ;

simplifiedOverrideLeftOrRight
    : LEFT_ANGLE_BRACKET simplifiedSecondary RIGHT_ANGLE_BRACKET
    ;

simplifiedOverrideAnyDirection
    : MINUS_SIGN simplifiedSecondary
    ;

simplifiedSecondary
    : simplifiedPrimary
    | simplifiedNegation
    ;

simplifiedNegation
    : EXCLAMATION_MARK simplifiedPrimary
    ;

simplifiedPrimary
    : labelName
    | LEFT_PAREN simplifiedContents RIGHT_PAREN
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 16.13 <where clause>
// ---------------------------------------------------------------------------------------------------------------------

whereClause
    : WHERE pred=booleanValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.14 <yield clause>
// ---------------------------------------------------------------------------------------------------------------------

yieldClause
    : YIELD yieldItemList
    ;

yieldItemList
    : yieldItem (COMMA yieldItem)*
    ;

/* M1: Simplifiy yieldItem

yieldItem
    : (yieldItemName yieldItemAlias?)
    ;

yieldItemName
    : fieldName
    ;

yieldItemAlias
    : AS bindingVariable
    ;
*/

yieldItem
    : fieldName (AS var=bindingVariable)?
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.15 <group by clasue>
// ---------------------------------------------------------------------------------------------------------------------

groupByClause
    : GROUP BY groupingElementList
    ;

groupingElementList
/* Inline groupingELement

    : elem+=groupingElement (COMMA elem+=groupingElement)*  #groupingElementListFromSome
*/
    : emptyGroupingSet                                                         #groupingElementListFromNone
    | elems+=bindingVariableReference (COMMA elems+=bindingVariableReference)* #groupingElementListFromSome
    ;

/* Inline groupingELement

groupingElement
    : varRef=bindingVariableReference
    ;
*/

emptyGroupingSet
    : LEFT_PAREN RIGHT_PAREN
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.16 <order by clasue>
// ---------------------------------------------------------------------------------------------------------------------

orderByClause
    : ORDER BY sortSpecificationList
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.17 <sort specification list>
// ---------------------------------------------------------------------------------------------------------------------

sortSpecificationList
    : sortSpecs+=sortSpecification (COMMA sortSpecs+=sortSpecification)*
    ;

sortSpecification
/* Inline sortKey and aggregatingValueExpression

    : sortKey orderingSpecification? nullOrdering?
*/
    : expr=valueExpression ordSpec=orderingSpecification? nullOrdering?
    ;

/* Inline sortKey and aggregatingValueExpression

sortKey
    : expr=aggregatingValueExpression
    ;
*/

orderingSpecification
    : ASC
    | ASCENDING
    | DESC
    | DESCENDING
    ;

nullOrdering
    : NULLS FIRST   #nullsFirstOrdering
    | NULLS LAST    #nullsLastOrdering
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.18 <limit clause>
// ---------------------------------------------------------------------------------------------------------------------

limitClause
    : LIMIT val=nonNegativeIntegerSpecification
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 16.19 <offset clause>
// ---------------------------------------------------------------------------------------------------------------------

offsetClause
    : ( OFFSET | SKIP_TOKEN ) val=nonNegativeIntegerSpecification
    ;

// =====================================================================================================================
// 17 Object references
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 17.1 <schema reference> and <catalog schema parent name>
// ---------------------------------------------------------------------------------------------------------------------

schemaReference
    : absoluteCatalogSchemaReference
    | relativeCatalogSchemaReference
    | referenceParameterSpecification
    ;

absoluteCatalogSchemaReference
    : SOLIDUS
    | absoluteDirectoryPath schemaName
    ;

catalogSchemaParentAndName
    : absoluteDirectoryPath schemaName
    ;

relativeCatalogSchemaReference
    : predefinedSchemaReference
    | relativeDirectoryPath schemaName
    ;

predefinedSchemaReference
    : HOME_SCHEMA
    | CURRENT_SCHEMA
    | PERIOD_SIGN
    ;

absoluteDirectoryPath
    : SOLIDUS simpleDirectoryPath?
    ;

relativeDirectoryPath
    : DOUBLE_PERIOD (SOLIDUS DOUBLE_PERIOD)* SOLIDUS simpleDirectoryPath?
    ;

simpleDirectoryPath
    : (directoryName SOLIDUS)+
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 17.2 <graph reference> and <catalog graph parent and name>
// ---------------------------------------------------------------------------------------------------------------------

graphReference
    : catalogObjectParentReference graphName
    | delimitedGraphName
    | homeGraph
    | referenceParameterSpecification
    ;

catalogGraphParentAndName

    : catalogObjectParentReference? graphName
    ;

homeGraph
    : HOME_PROPERTY_GRAPH
    | HOME_GRAPH
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 17.3 <graph type reference> and <catalog graph type parent and name>
// ---------------------------------------------------------------------------------------------------------------------

graphTypeReference
    : catalogGraphTypeParentAndName
    | referenceParameterSpecification
    ;

catalogGraphTypeParentAndName
    : catalogObjectParentReference? graphTypeName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 17.4 <binding table reference> and <catalog binding table parent name>
// ---------------------------------------------------------------------------------------------------------------------

bindingTableReference
    : catalogObjectParentReference bindingTableName
    | delimitedBindingTableName
    | referenceParameterSpecification
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 17.5 <procedure reference> and <catalog procedure parent and name>
// ---------------------------------------------------------------------------------------------------------------------

procedureReference
    : catalogProcedureParentAndName
    | referenceParameterSpecification
    ;

catalogProcedureParentAndName
    : catalogObjectParentReference? procedureName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 17.6 <catalog object parent reference>
// ---------------------------------------------------------------------------------------------------------------------

catalogObjectParentReference
/* Non-conformant removal of schema references to cater for lack of GQL catalog support

    : schemaReference SOLIDUS? (objectName PERIOD_SIGN)*
    | (objectName PERIOD_SIGN)+
*/
    : (objectName PERIOD_SIGN)+
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 17.7 <reference parameter specification>
// ---------------------------------------------------------------------------------------------------------------------

referenceParameterSpecification
    : SUBSTITUTED_PARAMETER_REFERENCE
    ;



// =====================================================================================================================
// 19 Predicates
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 19.1 <search condition>
// ---------------------------------------------------------------------------------------------------------------------

/* Inline searchCondition

searchCondition
    : expr=booleanValueExpression
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 19.2 <predicate>
// ---------------------------------------------------------------------------------------------------------------------

predicate
    : comparisonPredicate
    | nullPredicate
    | labeledPredicate
    | directedPredicate
    | sourceDestinationPredicate
    | normalizedPredicate
    | valueTypePredicate
    | existsPredicate
 // Keeping all_differentPredicate should aid in the implemenation of edge-isomorphism.
    | all_differentPredicate
    | samePredicate
/* M0: Remove optional predicates without Cypher equivalent

    | property_existsPredicate
*/
/* Add string_predicates
*/
    | containsPredicate
    | startsWithPredicate
    | endsWithPredicate
/* Add list_predicates
*/
    | listMembershipPredicate
/* Add regexp
*/
    | regexpContainsPredicate
    ;

// vvv Extension: string_predicates

containsPredicate
    : prim=characterOrByteStringValueExpression part2=containsPredicatePart2
    ;

containsPredicatePart2
    : NOT? CONTAINS characterOrByteStringValueExpression
    ;

startsWithPredicate
    : prim=characterOrByteStringValueExpression part2=startsWithPredicatePart2
    ;

startsWithPredicatePart2
    : NOT? STARTS WITH characterOrByteStringValueExpression
    ;

endsWithPredicate
    : prim=characterOrByteStringValueExpression part2=endsWithPredicatePart2
    ;

endsWithPredicatePart2
    : NOT? ENDS WITH characterOrByteStringValueExpression
    ;

characterOrByteStringValueExpression
    : characterStringValueExpression
    | byteStringValueExpression
    ;

// ^^^ Extension: string_predicates

// vvv Extension: list_predicates

listMembershipPredicate
    : elem=valueExpressionPrimary listMembershipPredicatePart2
    ;

listMembershipPredicatePart2
    : NOT? IN list=listValueExpression
    ;

// ^^^ Extension: list_predicates

// vvv Extension: regexp

regexpContainsPredicate
    : prim=characterStringValueExpression regexpContainsPredicatePart2
    | REGEXP_CONTAINS LEFT_PAREN prim=characterStringValueExpression COMMA regexpPattern RIGHT_PAREN
    ;

regexpContainsPredicatePart2
    : NOT? REGEXP_CONTAINS regexpPattern
    ;

/* Inline regexpContainsFunction

regexpContainsFunction
    : REGEXP_CONTAINS LEFT_PAREN characterStringValueExpression COMMA regexpPattern RIGHT_PAREN
    ;
*/

regexpPattern
    : characterStringValueExpression
    ;

// ^^^ Extension: regexp

// ---------------------------------------------------------------------------------------------------------------------
// 19.3 <comparison predicate>
// ---------------------------------------------------------------------------------------------------------------------

comparisonPredicate
    // M2: Preseve openGQL extension for chained comparisons
    : commonValueExpression (steps+=comparisonPredicatePart2+)
    ;

comparisonPredicatePart2
    : compOp commonValueExpression
    ;

compOp
    : EQUALS_OPERATOR
    | NOT_EQUALS_OPERATOR
    | LEFT_ANGLE_BRACKET
    | RIGHT_ANGLE_BRACKET
    | LESS_THAN_OR_EQUALS_OPERATOR
    | GREATER_THAN_OR_EQUALS_OPERATOR
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 19.4 <exists predicate>
// ---------------------------------------------------------------------------------------------------------------------

existsPredicate
/* Remove matchStatementBlock

    : EXISTS (LEFT_BRACE graphPattern RIGHT_BRACE
             | LEFT_PAREN graphPattern RIGHT_PAREN
             | LEFT_BRACE matchStatementBlock RIGHT_BRACE
             | LEFT_PAREN matchStatementBlock RIGHT_PAREN
             | nestedQuerySpecification)
*/
    : EXISTS
        (LEFT_BRACE pat=graphPattern RIGHT_BRACE | LEFT_PAREN pat=graphPattern RIGHT_PAREN )   #existsPredicateByPattern
    | EXISTS nested=nestedQuerySpecification                                                   #existsPredicateByProc
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 19.5 <null predicate>
// ---------------------------------------------------------------------------------------------------------------------

nullPredicate
    : prim=valueExpressionPrimary part2=nullPredicatePart2
    ;

nullPredicatePart2
    : IS NOT? NULL_TOKEN
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 19.6 <value type predicate>
// ---------------------------------------------------------------------------------------------------------------------

valueTypePredicate
    : prim=valueExpressionPrimary part2=valueTypePredicatePart2
    ;

valueTypePredicatePart2
    : IS NOT? ( DOUBLE_COLON | TYPED ) valueType
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 19.7 <normalized predicate>
// ---------------------------------------------------------------------------------------------------------------------

normalizedPredicate
    : expr=characterOrByteStringValueExpression normalizedPredicatePart2
    ;

normalizedPredicatePart2
    : IS NOT? normalForm? NORMALIZED
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 19.8 <directed predicate>
// ---------------------------------------------------------------------------------------------------------------------

directedPredicate
    : expr=edgeReferenceValueExpression part2=directedPredicatePart2
    ;

directedPredicatePart2
    : IS NOT? DIRECTED
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 19.9 <labled predicate>
// ---------------------------------------------------------------------------------------------------------------------

labeledPredicate
    : elemRef=elementReferenceValueExpression part2=labeledPredicatePart2
    ;

labeledPredicatePart2
/* Inline isLabeledOrColon

    : isLabeledOrColon labelExpression
*/
    : ( IS LABELED | COLON ) labelExpression    #isLabeledPredicate
    | IS NOT LABELED labelExpression            #isNotLabeledPredicate
    ;

/* Inline isLabeledOrColon

isLabeledOrColon
    : IS NOT? LABELED
    | COLON
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 19.10 <source/destination predicate>
// ---------------------------------------------------------------------------------------------------------------------

// NOTE: (node|edge)Reference have been renamed to (node|edge)VariableReference for consistency here.

sourceDestinationPredicate
    : node=nodeReferenceValueExpression srcPred=sourcePredicatePart2            #sourcePredicate
    | node=nodeReferenceValueExpression dstPred=destinationPredicatePart2       #destinationPredicate
    ;

/* Simplify identifier use

nodeVariableReference

    : elementVariableReference
*/

sourcePredicatePart2
    : IS NOT? SOURCE OF edge=edgeReferenceValueExpression
    ;

destinationPredicatePart2
    : IS NOT? DESTINATION OF edge=edgeReferenceValueExpression
    ;

/* Simplify identifier use

edgeVariableReference
    : elementVariableReference
*/

// ---------------------------------------------------------------------------------------------------------------------
// 19.11 <all different predicate>
// ---------------------------------------------------------------------------------------------------------------------

all_differentPredicate
    : ALL_DIFFERENT
        LEFT_PAREN exprs+=valueExpression (COMMA exprs+=valueExpression)+ RIGHT_PAREN
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 19.12 <same predicate>
// ---------------------------------------------------------------------------------------------------------------------

samePredicate
    : SAME
        LEFT_PAREN exprs+=valueExpression (COMMA exprs+=valueExpression)+ RIGHT_PAREN
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 19.13 <property exists predicate>
// ---------------------------------------------------------------------------------------------------------------------

/* Remove optional predicates

property_existsPredicate
    : PROPERTY_EXISTS LEFT_PAREN elementVariableReference COMMA propertyName RIGHT_PAREN
    ;
*/

// =====================================================================================================================
// 20 Value expressions and specifications
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 20.1 <value expression>
// ---------------------------------------------------------------------------------------------------------------------

valueExpression
    : operand=valueExpressionOperand                                #valExprOperand
    | NOT operand=valueExpressionOperand                            #notValExprOperand
    | lhs=valueExpression operator=AND rhs=valueExpression          #conjunctionValExpr
    | lhs=valueExpression operator=(OR | XOR) rhs=valueExpression   #disjunctionValExpr
    ;

valueExpressionOperand
    : predicate test=truthValueTest?                                #predicateValExpr
    | commonValueExpression test=truthValueTest?                    #commonValExpr
    ;

truthValueTest
    : IS val=truthValue         #isTruthValue
    | IS NOT val=truthValue     #isNotTruthValue
    ;

commonValueExpression
    // Numeric, datetime and duration types all support roughly the same expressions. So here
    // we define a rule that deals with all of them. It is up to the implementation to post
    // process the syntax tree and flag invalid type and function combinations.
    : sign=(PLUS_SIGN|MINUS_SIGN)? prim=valueExpressionPrimary                                   #primValExpr
    | lhs=commonValueExpression operator=(ASTERISK|SOLIDUS) rhs=commonValueExpression            #productValExpr
    | lhs=commonValueExpression operator=(PLUS_SIGN|MINUS_SIGN) rhs=commonValueExpression        #sumValExpr
    // Character strings, byte strings, lists and paths all support the same concatenation
    // operator. So here we define a rule that deals with all of them. Of course the types
    // cannot be combined. So it is up to implementation to post process the syntax tree
    // and flag invalid type and function combinations.
    | lhs=commonValueExpression CONCATENATION_OPERATOR rhs=commonValueExpression                 #concatenationValExpr
    | PROPERTY? GRAPH expr=graphExpression                                                            #graphExprPrimary
    | BINDING? TABLE expr=bindingTableExpression                                                      #tableExprPrimary
    | valueFunction                                                                              #valFun
    ;

// Modified to ensure unambiguous parse tree
valueFunction
    : unambigousNumericValueFunction
    | datetimeSubtraction
    | datetimeValueFunction
    | unambigousDurationValueFunction
    | characterOrByteStringFunction
    | listValueFunction
    | absoluteValueExpression
    ;

booleanValueExpression
    : expr=valueExpression
    ;

characterOrByteStringFunction
    : subCharacterOrByteString
    | trimSingleCharacterOrByteString
    | foldCharacterString
    | trimMultiCharacterCharacterString
    | normalizeCharacterString
/* Add string_functions
*/
    | stringJoinFunction
    | toJsonStringFunction
    | parseJsonStringFunction
    ;

subCharacterOrByteString
    : (LEFT | RIGHT) LEFT_PAREN expr=characterOrByteStringValueExpression COMMA stringLength RIGHT_PAREN
    ;

trimSingleCharacterOrByteString
    : TRIM LEFT_PAREN trimOperands RIGHT_PAREN
    ;

foldCharacterString
    : (UPPER | LOWER) LEFT_PAREN expr=characterStringValueExpression RIGHT_PAREN
    ;

trimMultiCharacterCharacterString
    : (BTRIM | LTRIM | RTRIM) LEFT_PAREN
    exprs+=characterStringValueExpression
    (COMMA exprs+=characterStringValueExpression)? RIGHT_PAREN
    ;

normalizeCharacterString
    : NORMALIZE LEFT_PAREN expr=characterStringValueExpression (COMMA normalForm)? RIGHT_PAREN
    ;

// vvv Extension: string_functions

stringJoinFunction
    : STRING_JOIN LEFT_PAREN expr=listValueExpression ( COMMA delim=stringJoinDelimiter )? RIGHT_PAREN
    ;

stringJoinDelimiter
    : characterOrByteStringValueExpression
    ;

// ^^^ Extension: string_functions

toJsonStringFunction
    : TO_JSON_STRING LEFT_PAREN arg=valueExpression RIGHT_PAREN
    ;

parseJsonStringFunction
    : PARSE_JSON_STRING LEFT_PAREN arg=valueExpression RIGHT_PAREN
    ;

elementReferenceValueExpression
    : prim=valueExpressionPrimary
    ;

nodeReferenceValueExpression
    : prim=valueExpressionPrimary
    ;

edgeReferenceValueExpression
    : prim=valueExpressionPrimary
    ;

/* Inline aggregatingValueExpressiom

aggregatingValueExpression
    : valueExpression
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 20.2 <value expression primary>
// ---------------------------------------------------------------------------------------------------------------------

valueExpressionPrimary
    : val=valueExpressionPrimaryCommon                                                      #valSpecExprPrimary
    | varRef=bindingVariableReference                                                       #varRefExprPrimary
    | prim=valueExpressionPrimary PERIOD_SIGN propertyName                                  #propExprPrimary
    | LEFT_PAREN expr=valueExpression RIGHT_PAREN                                           #parenExprPrimary
    ;

nonParenthesizedValueExpressionPrimary
    : common=valueExpressionPrimaryCommon
    | varRef=bindingVariableReference
    | prim=valueExpressionPrimary PERIOD_SIGN propertyName      // <property reference>
   ;

valueExpressionPrimarySpecialCase
    : common=valueExpressionPrimaryCommon
    | prim=valueExpressionPrimary PERIOD_SIGN propertyName      // <property reference>
    ;

valueExpressionPrimaryCommon
    : val=unsignedValueSpecification
// List and Record literals are reduntantly/abiguously part of the literal production
//    | listValueConstructor
//    | recordConstructor
    | pathValueSpecification
    | valueQueryExpression
    | caseExpression
    | castSpecification
    | elementIdFunction
    | letValueExpression
    | aggregateFunction
    ;

/* Restore ISO GQL grammar

    | aggregateFunction
    | unsignedValueSpecification
// List and Record literals are reduntantly/abiguously part of the literal production [openGQL]
//
//    | listValueConstructor
//    | recordConstructor
    | pathValueConstructor
    | valueExpressionPrimary PERIOD_SIGN propertyName      // <propertyReference>
    | valueQueryExpression
    | caseExpression
    | castSpecification
    | element_idFunction
    | letValueExpression
    | bindingVariableReference
    ;
*/

/* Inline parenthesizedValueExpression

parenthesizedValueExpression
    : LEFT_PAREN expr=valueExpression RIGHT_PAREN
    ;
*/

/* Inline nonParenthesizedValueExpressionPrimary

nonParenthesizedValueExpressionPrimary
    : nested=nonParenthesizedValueExpressionPrimarySpecialCase
    | bvr=bindingVariableReference
    ;
*/

/* - Rename nonParenthesizedValueExpressionPrimarySpecialCase for brevity
   - Inline valueExpressionPrimarySpecialCase

nonParenthesizedValueExpressionPrimarySpecialCase
    : unsignedValueSpecification
// Moved to unsignedValueSpecification
//
//  | listValueConstructor
//  | recordConstructor
//  | pathValueConstructor
    | propertyReference
    | aggregateFunction
    | valueQueryExpression
    | caseExpression
    | castSpecification
    | element_idFunction
    | letValueExpression
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 20.3 <value specification>
// ---------------------------------------------------------------------------------------------------------------------

unsignedValueSpecification
/* Inline unsignedLiteral

    : unsignedLiteral
*/
    : unsignedNumericLiteral
    | nonNumericLiteral
    | recordSpecification
    | listValueSpecification
    | pathValueSpecification
/* Inline generalValueSpecification
*/
    | dynamicParameterSpecification
    | SESSION_USER
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.5 <let value expression>
// ---------------------------------------------------------------------------------------------------------------------

// Optional but can be useful in AST rewrites.
letValueExpression
    : LET varDefList=letVariableDefinitionList IN expr=valueExpression END
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.6 <value query expression>
// ---------------------------------------------------------------------------------------------------------------------

valueQueryExpression
    : VALUE nested=nestedQuerySpecification
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.7 <case expression>
// ---------------------------------------------------------------------------------------------------------------------

caseExpression
    : caseAbbreviation
    | caseSpecification
    ;

caseAbbreviation
    : NULLIF LEFT_PAREN lhs+=valueExpression COMMA rhs+=valueExpression RIGHT_PAREN          #caseAbbreviationNullIf
    | COALESCE LEFT_PAREN exprs+=valueExpression (COMMA exprs+=valueExpression)+ RIGHT_PAREN #caseAbbreviationCoalesce
    ;

caseSpecification
    : simpleCase
    | searchedCase
    ;

simpleCase
/* Inline nonParenthesizedValueExpressionPrimary and caseOperand

    : CASE caseOperand simpleWhenClause+ elseClause? END
*/
    : CASE prim=valueExpressionPrimary simpleWhenClause+ elseClause? END
    ;

searchedCase
    : CASE searchedWhenClause+ elseClause? END
    ;

simpleWhenClause
    : WHEN whenOperandList THEN valueExpression
    ;

searchedWhenClause
    : WHEN pred=booleanValueExpression THEN valueExpression
    ;

elseClause
    : ELSE valueExpression
    ;

/* Inline nonParenthesizedValueExpressionPrimary and improved caseOperand

caseOperand
    : nested=nonParenthesizedValueExpressionPrimary
    | ref=elementVariableReference
*/

whenOperandList
    : whens+=whenOperand (COMMA whens+=whenOperand)*
    ;

whenOperand
/* Inline nonParenthesizedValueExpressionPrimary and improve whenOperand

    : nonParenthesizedValueExpressionPrimary
*/
    : prim=valueExpressionPrimary
    // M2: Preseve openGQL extension for chained comparisons
    | (steps+=comparisonPredicatePart2)+
    | nullPredicatePart2
    | valueTypePredicatePart2
    | normalizedPredicatePart2
    | directedPredicatePart2
    | labeledPredicatePart2
    | sourcePredicatePart2
    | destinationPredicatePart2
/* Add string_predicates
*/
    | containsPredicatePart2
    | startsWithPredicatePart2
    | endsWithPredicatePart2
/* Add
*/
    | listMembershipPredicatePart2
/* Add regexp
*/
    | regexpContainsPredicatePart2
    ;

/* Inline redundant result and resultExpression

result
    : resultExpression
    | nullLiteral
    ;

resultExpression
    : valueExpression
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 20.8 <cast specification>
// ---------------------------------------------------------------------------------------------------------------------

castSpecification
    : CAST LEFT_PAREN castOperand AS castTarget RIGHT_PAREN
    ;

castOperand
    : valueExpression
/* Remove double derivation of null for castOperand

    | nullLiteral
*/
    ;

castTarget
    : valueType
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.9 <aggregate function>
// ---------------------------------------------------------------------------------------------------------------------

aggregateFunction
    : COUNT LEFT_PAREN ASTERISK RIGHT_PAREN
    | generalSetFunction
    | binarySetFunction
    ;

generalSetFunction
    : generalSetFunctionType LEFT_PAREN setQuantifier? expr=valueExpression RIGHT_PAREN
    ;

binarySetFunction
    : binarySetFunctionType LEFT_PAREN dependentValueExpression COMMA independentValueExpression RIGHT_PAREN
    ;

generalSetFunctionType
    : AVG
    | COUNT
    | MAX
    | MIN
    | SUM
    | COLLECT_LIST
    | STDDEV_SAMP
    | STDDEV_POP
    ;

setQuantifier
    : DISTINCT
    | ALL
    ;

binarySetFunctionType
    : PERCENTILE_CONT
    | PERCENTILE_DISC
    ;

dependentValueExpression
    : setQuantifier? numericValueExpression
    ;

independentValueExpression
    : numericValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.10 <element_id function>
// ---------------------------------------------------------------------------------------------------------------------

elementIdFunction
    : ELEMENT_ID LEFT_PAREN elemRef=elementReferenceValueExpression RIGHT_PAREN
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.11 <property reference>
// ---------------------------------------------------------------------------------------------------------------------

/* Inline propertyReference

propertyReference :
    prim=valueExpressionPrimary PERIOD_SIGN prop=propertyName
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 20.12 <binding variable reference>
// ---------------------------------------------------------------------------------------------------------------------

bindingVariableReference
/* Inline binding variable

    : bindingVariable
*/
    : varIdent
    ;

// The path value expression was combined with list and string value expressions.
// See listStringOrPathValueExpression.

pathValueExpression
    : expr=commonValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.14 <path value constructor>
// ---------------------------------------------------------------------------------------------------------------------

pathValueSpecification
    : PATH LEFT_BRACKET pathElementListStart pathElementListStep* RIGHT_BRACKET
    ;

/* Inline pathElementList

pathElementList
    : pathElementListStart pathElementListStep*
    ;
*/

pathElementListStart
    : nodeReferenceValueExpression
    ;

pathElementListStep
    : COMMA edgeReferenceValueExpression COMMA nodeReferenceValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.15 <list value expression>
// ---------------------------------------------------------------------------------------------------------------------

// The list value expression was combined with path and string value expressions.
// See listStringOrPathValueExpression. [openGQL]

listValueExpression
    : expr=commonValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.16 <list value function>
// ---------------------------------------------------------------------------------------------------------------------

// NOTE: ByteString functions were moved to characterByteStringOrListFunction, some alternatives
// apply to characterString, byteString and list. Breaking them out separately resulted in
// ambiguity. [openGQL]

listValueFunction
    : trimListFunction
    | elementsFunction
/* Add list_functions
*/
    | rangeFunction
    | labelsFunction
    | keysFunction
    | nodesFunction
    | edgesFunction
    ;

trimListFunction
    : TRIM LEFT_PAREN listValueExpression COMMA numericValueExpression RIGHT_PAREN
    ;

elementsFunction
    : ELEMENTS LEFT_PAREN pathValueExpression RIGHT_PAREN
    ;

// vvv Extension: list_functions

rangeFunction
    : RANGE LEFT_PAREN rangeStart COMMA rangeEnd (COMMA rangeStep)? RIGHT_PAREN
    ;

rangeStart
    : numericValueExpression
    ;

rangeEnd
    : numericValueExpression
    ;

rangeStep
    : numericValueExpression
    ;

labelsFunction
    : LABELS LEFT_PAREN elementReferenceValueExpression RIGHT_PAREN
    ;

keysFunction
    // elementReferenceValueExpression |  recordExpression
    : KEYS LEFT_PAREN valueExpression RIGHT_PAREN
    ;

nodesFunction
    : ( NODES | VERTICES ) LEFT_PAREN pathValueExpression RIGHT_PAREN
    ;

edgesFunction
    : ( EDGES | RELATIONSHIPS ) LEFT_PAREN pathValueExpression RIGHT_PAREN
    ;

// ^^^ Extension: list_functions


// ---------------------------------------------------------------------------------------------------------------------
// 20.17 <list value constructor>
// ---------------------------------------------------------------------------------------------------------------------

/* M0: Simpilify list value constructor grammar
   M2: Rename ...constructor => ...specification for consistency

listValueConstructor
    : listValueConstructorByEnumeration
    ;

listValueConstructorByEnumeration

*/
listValueSpecification
    : listValueTypeName? LEFT_BRACKET valueExpressionList? RIGHT_BRACKET
    ;

valueExpressionList
    : exprs+=valueExpression (COMMA exprs+=valueExpression)*
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.18 <record constructor>
// ---------------------------------------------------------------------------------------------------------------------

/* Rename ...constructor => ...specification

recordConstructor
*/
recordSpecification
    : RECORD? LEFT_BRACE fieldSpecificationList? RIGHT_BRACE
    ;

/* - Inline fieldList
   - Inline fieldSetSpecification

fieldSetSpecification

    : LEFT_BRACE (fields+=fieldSpecification (COMMA fields+=fieldSpecification)*)? RIGHT_BRACE
    ;
*/

fieldSpecificationList
    : fieldSpecification (COMMA fieldSpecification)*
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.19 <field>
// ---------------------------------------------------------------------------------------------------------------------

/* Rename field to fieldSpecification for consistency

field
*/
fieldSpecification
    : fieldName COLON expr=valueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.20 <boolean value expression>
// ---------------------------------------------------------------------------------------------------------------------

// Most of <boolean value expression> is incorporated in valueExpression. [openGQL]

truthValue
    : BOOLEAN_LITERAL
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.21 <numeric value expression>
// ---------------------------------------------------------------------------------------------------------------------

/* Move numericValueExpression to be a type checking concern

numericValueExpression
    : sign=(PLUS_SIGN|MINUS_SIGN) it=numericValueExpression                                 #numericValueExpressionAlt1
    | lhs=numericValueExpression operator=(ASTERISK|SOLIDUS) rhs=numericValueExpression     #numericValueExpressionAlt2
    | rhs=numericValueExpression operator=(PLUS_SIGN|MINUS_SIGN) rhs=numericValueExpression #numericValueExpressionAlt3
    | prim=valueExpressionPrimary                                                           #numericValueExpressionPrim
    | numFun=numericValueFunction                                                           #numericValueExpressionFun
    ;
*/

numericValueExpression
    : expr=commonValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.22 <numeric value function>
// ---------------------------------------------------------------------------------------------------------------------

/* Comment out unused numericValueFunction

numericValueFunction
    : unambigousNumericValueFunction
    | absoluteValueExpression
    ;
*/

// Factored out to ensure unambigous parse tree
unambigousNumericValueFunction
    : lengthExpression
    | cardinalityExpression
    | modulusExpression
    | trigonometricFunction
    | generalLogarithmFunction
    | commonLogarithm
    | naturalLogarithm
    | exponentialFunction
    | powerFunction
    | squareRoot
    | floorFunction
    | ceilingFunction
    ;

lengthExpression
    : charLengthExpression
    | byteLengthExpression
    | pathLengthExpression
    ;

cardinalityExpression
    : CARDINALITY LEFT_PAREN cardinalityExpressionArgument RIGHT_PAREN  #cardinalityExpressionAlt1
    | SIZE LEFT_PAREN listValueExpression RIGHT_PAREN                   #cardinalityExpressionAlt2
    ;

cardinalityExpressionArgument
    : valueExpression
    ;

charLengthExpression
    : (CHAR_LENGTH | CHARACTER_LENGTH) LEFT_PAREN arg=characterStringValueExpression RIGHT_PAREN
    ;

byteLengthExpression
    : (BYTE_LENGTH | OCTET_LENGTH) LEFT_PAREN arg=byteStringValueExpression RIGHT_PAREN
    ;

pathLengthExpression
    : PATH_LENGTH LEFT_PAREN arg=pathValueExpression RIGHT_PAREN
    ;

// absoluteValueExpression applies to both numeric types and duration types. They have the same syntax. [openGQL]
absoluteValueExpression
    : ABS LEFT_PAREN expr=valueExpression RIGHT_PAREN
    ;

modulusExpression
    : MOD LEFT_PAREN numericValueExpressionDividend COMMA numericValueExpressionDivisor RIGHT_PAREN
    ;

numericValueExpressionDividend
    : numericValueExpression
    ;

numericValueExpressionDivisor
    : numericValueExpression
    ;

trigonometricFunction
    : trigonometricFunctionName LEFT_PAREN arg=numericValueExpression RIGHT_PAREN
    ;

trigonometricFunctionName
    : SIN
    | COS
    | TAN
    | COT
    | SINH
    | COSH
    | TANH
    | ASIN
    | ACOS
    | ATAN
    | DEGREES
    | RADIANS
    ;

generalLogarithmFunction
    : LOG_TOKEN LEFT_PAREN base=generalLogarithmBase COMMA arg=generalLogarithmArgument RIGHT_PAREN
    ;

generalLogarithmBase
    : arg=numericValueExpression
    ;

generalLogarithmArgument
    : arg=numericValueExpression
    ;

commonLogarithm
    : LOG10_TOKEN LEFT_PAREN arg=numericValueExpression RIGHT_PAREN
    ;

naturalLogarithm
    : LN LEFT_PAREN arg=numericValueExpression RIGHT_PAREN
    ;

exponentialFunction
    : EXP LEFT_PAREN arg=numericValueExpression RIGHT_PAREN
    ;

powerFunction
    : POWER LEFT_PAREN base=numericValueExpressionBase COMMA exp=numericValueExpressionExponent RIGHT_PAREN
    ;

numericValueExpressionBase
    : num=numericValueExpression
    ;

numericValueExpressionExponent
    : num=numericValueExpression
    ;

squareRoot
    : SQRT LEFT_PAREN arg=numericValueExpression RIGHT_PAREN
    ;

floorFunction
    : FLOOR LEFT_PAREN arg=numericValueExpression RIGHT_PAREN
    ;

ceilingFunction
    : (CEIL | CEILING) LEFT_PAREN arg=numericValueExpression RIGHT_PAREN
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.23 <string value expression>
// ---------------------------------------------------------------------------------------------------------------------

// The string value expressions were combined with list and path value expressions. [openGQL]

characterStringValueExpression
    : expr=commonValueExpression
    ;

byteStringValueExpression
    : expr=commonValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.24 <string value function>
// ---------------------------------------------------------------------------------------------------------------------

// NOTE: String functions were moved to characterByteStringOrListFunction, some alternatives
// apply to characterString, byteString and list. Breaking them out separately resulted in
// ambiguity. [openGQL]

trimOperands
    : (trimSpecification? trimCharacterOrByteString? FROM)? trimCharacterOrByteStringSource
    ;

trimCharacterOrByteStringSource
    : expr=characterOrByteStringValueExpression
    ;

trimSpecification
    : LEADING
    | TRAILING
    | BOTH
    ;

trimCharacterOrByteString
    : expr=characterOrByteStringValueExpression
    ;

normalForm
    : NFC
    | NFD
    | NFKC
    | NFKD
    ;

stringLength
    : num=numericValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.25 <byte string function>
// ---------------------------------------------------------------------------------------------------------------------

// NOTE: ByteString functions were moved to characterByteStringOrListFunction, some alternatives
// apply to characterString, byteString and list. Breaking them out separately resulted in
// ambiguity. [openGQL]

// ---------------------------------------------------------------------------------------------------------------------
// 20.26 <datetime value expression>
// ---------------------------------------------------------------------------------------------------------------------

// The implementation should enforce that the data type is a datetime value. [openGQL]
datetimeValueExpression
     : expr=commonValueExpression
     ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.27 <datetime value function>
// ---------------------------------------------------------------------------------------------------------------------

datetimeValueFunction
    : dateFunction
    | timeFunction
    | datetimeFunction
    | localtimeFunction
    | localdatetimeFunction
    ;

dateFunction
    : CURRENT_DATE
    | DATE LEFT_PAREN dateFunctionParameters? RIGHT_PAREN
    ;

timeFunction
    : CURRENT_TIME
    | ZONED_TIME LEFT_PAREN timeFunctionParameters? RIGHT_PAREN
    ;

localtimeFunction
    : LOCAL_TIME (LEFT_PAREN timeFunctionParameters? RIGHT_PAREN)?
    ;

datetimeFunction
    : CURRENT_TIMESTAMP                                                     #dateTimeFunctionAlt1
    | ZONED_DATETIME LEFT_PAREN datetimeFunctionParameters? RIGHT_PAREN     #dateTimeFunctionAlt2
    ;

localdatetimeFunction
    : LOCAL_TIMESTAMP
    | LOCAL_DATETIME LEFT_PAREN datetimeFunctionParameters? RIGHT_PAREN
    ;

dateFunctionParameters
/* Liberalize function parameters

    : dateString
    | recordConstructor
*/
    : expr=commonValueExpression
    ;

timeFunctionParameters
/* Liberalize function parameters

    : timeString
    | recordConstructor
*/
    : expr=commonValueExpression
    ;

datetimeFunctionParameters
/* Liberalize function parameters

    : datetimeString
    | recordConstructor
*/
    : expr=commonValueExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 20.28 <duration value expression>
// ---------------------------------------------------------------------------------------------------------------------

// The implemenation should enforce that the data type is a duration value. [openGQL]

/* Remove unusued production

durationValueExpression
    : valueExpression
    ;
*/

datetimeSubtraction
/* Simplify datetimeSubtraction

    : DURATION_BETWEEN LEFT_PAREN datetimeSubtractionParameters RIGHT_PAREN temporalDurationQualifier?
*/
    : DURATION_BETWEEN LEFT_PAREN lhs=datetimeValueExpression COMMA rhs=datetimeValueExpression RIGHT_PAREN
        temporalDurationQualifier?
    ;


/* Simplify datetimeSubtraction

datetimeSubtractionParameters
    : datetimeValueExpression1 COMMA datetimeValueExpression2
    ;

datetimeValueExpression1
    : datetimeValueExpression
    ;

datetimeValueExpression2
    : datetimeValueExpression
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 20.29 <duration value function>
// ---------------------------------------------------------------------------------------------------------------------

/* Remove unused production

durationValueFunction
    : nonAmbDurationValueFunction
    | absoluteValueExpression
    ;
*/

// Factored out to ensure unambiguous parse trees
unambigousDurationValueFunction
    : durationFunction
    ;

durationFunction
    : DURATION LEFT_PAREN durationFunctionParameters RIGHT_PAREN
    ;

durationFunctionParameters
/* Liberalize function parameters

    : durationString
    | recordConstructor
*/
    : expr=commonValueExpression
    ;




