grammar GQL_OTYPES;

import GQL_NAMES,
       GQL_PARTICLES,
       GQL_LITERALS,
       GQL_VTYPES;

// =====================================================================================================================
// 18 Type elements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 18.1 <nested graph type specification>
// ---------------------------------------------------------------------------------------------------------------------

nestedGraphTypeSpecification
    : LEFT_BRACE graphTypeSpecification? RIGHT_BRACE
    ;

// M3 - Renamed for consistency

graphTypeSpecification
    : items+=graphTypeBodyItem (COMMA items+=graphTypeBodyItem)* COMMA?
    ;

graphTypeBodyItem
    : nodeTypeSpecification
    | edgeTypeSpecification
    | constraintDefinition      // Extension: constraints
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 18.2 <node type specification>
// ---------------------------------------------------------------------------------------------------------------------

nodeTypeSpecification
/* Remove support for graph element type names

    | nodeTypePhrase
*/
    : ABSTRACT? nodeTypePattern
    ;

nodeTypePattern
/* Remove support for graph element type names

    : (( NODE | VERTEX ) TYPE? nodeTypeName)? LEFT_PAREN localNodeTypeAlias? nodeTypeFiller? RIGHT_PAREN
*/

    : LEFT_PAREN alias=nodeTypeAlias? filler=nodeTypeFiller? RIGHT_PAREN
    ;

/* Remove support for graph element type names

nodeTypePhrase
    : ( NODE | VERTEX ) TYPE? nodeTypePhraseFiller (AS localNodeTypeAlias)?
    ;

nodeTypePhraseFiller
    : nodeTypeName nodeTypeFiller?
    | nodeTypeFiller
    ;
*/

nodeTypeFiller
    : nodeTypeKeyLabelSpecification ( RIGHT_DOUBLE_ARROW | 'IMPLIES' ) nodeTypeImpliedContent?
/* Adjust for graph type support

    | nodeTypeImpliedContent
*/
    // TODO: Use nodeTypeLabelSet instead and infer keys for greater conformance
    | nodeTypeKeyLabelSpecification nodeTypePropertyTypes?
    ;

nodeTypeKeyLabelSpecification
/* Adjust for graph type support
    : labelSetPhrase? ( RIGHT_DOUBLE_ARROW | 'IMPLIES')
*/
    : elementTypeKeyLabelSpecification
    ;

nodeTypeImpliedLabelSet
    : nodeTypeLabelSet
    ;

nodeTypeLabelSet
    : labelSetPhrase
    ;

nodeTypeImpliedPropertyTypes
    : nodeTypePropertyTypes                            #exactNodeTypePropTypes
    | PLUS_EQUALS_OPERATOR nodeTypePropertyTypes       #addedNodeTypePropTypes
    ;

nodeTypePropertyTypes
    : propertyTypesSpecification
    ;

nodeTypeImpliedContent
    : nodeTypeImpliedLabelSet
    | nodeTypeImpliedPropertyTypes
    | nodeTypeImpliedLabelSet nodeTypeImpliedPropertyTypes
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 18.3 <edge type specification>
// ---------------------------------------------------------------------------------------------------------------------

edgeTypeSpecification
/* Remove support for graph element type names

    | edgeTypePhrase
*/
    : ABSTRACT? edgeTypePattern
    ;

edgeTypePattern
/* Remove support for graph element type names

    : (edgeKind? ( EDGE | RELATIONSHIP ) TYPE? edgeTypeName)? (edgeTypePatternDirected | edgeTypePatternUndirected)
*/

    : (edgeTypePatternDirected | edgeTypePatternUndirected)
    ;

/* Remove support for graph element type names

edgeTypePhrase
    : edgeKind ( EDGE | RELATIONSHIP ) TYPE? edgeTypePhraseFiller endpointPairPhrase
    ;

edgeTypePhraseFiller
    : edgeTypeName edgeTypeFiller?
    | edgeTypeFiller
    ;
*/

edgeTypeFiller
    : edgeTypeKeyLabelSpecification ( RIGHT_DOUBLE_ARROW | 'IMPLIES' ) edgeTypeImpliedContent?
/* Adjust for graph type support

    | edgeTypeImpliedContent
*/
    // TODO: Use edgeTypeLabelSet instead and infer keys for greater conformance
    | edgeTypeKeyLabelSpecification edgeTypePropertyTypes?
    ;

edgeTypeKeyLabelSpecification
    : elementTypeKeyLabelSpecification
    ;

edgeTypeImpliedContent
    : edgeTypeImpliedLabelSet
    | edgeTypeImpliedPropertyTypes
    | edgeTypeImpliedLabelSet edgeTypeImpliedPropertyTypes
    ;

edgeTypeImpliedLabelSet
    : edgeTypeLabelSet
    ;

edgeTypeLabelSet
    : labelSetPhrase
    ;

edgeTypeImpliedPropertyTypes
    : edgeTypePropertyTypes                         #exactEdgeTypePropTypes
    | PLUS_EQUALS_OPERATOR edgeTypePropertyTypes    #addedEdgeTypePropTypes
    ;

edgeTypePropertyTypes
/* Add graph type support

    : propertyTypesSpecification
*/
    : propertyTypesSpecification
    ;

edgeTypePatternDirected
    : edgeTypePatternPointingRight
    | edgeTypePatternPointingLeft
    ;

edgeTypePatternPointingRight
    : src=sourceNodeTypeSpecification arcTypePointingRight dst=destinationNodeTypeSpecification
    ;

edgeTypePatternPointingLeft
    : dst=destinationNodeTypeSpecification arcTypePointingLeft src=sourceNodeTypeSpecification
    ;

edgeTypePatternUndirected
    : fst=sourceNodeTypeSpecification arcTypeUndirected snd=destinationNodeTypeSpecification
    ;

arcTypePointingRight
    : MINUS_LEFT_BRACKET alias=edgeTypeAlias? filler=edgeTypeFiller BRACKET_RIGHT_ARROW
    | MINUS_LEFT_BRACKET alias=edgeTypeAlias BRACKET_RIGHT_ARROW
    ;

arcTypePointingLeft
    : LEFT_ARROW_BRACKET alias=edgeTypeAlias? filler=edgeTypeFiller RIGHT_BRACKET_MINUS
    | LEFT_ARROW_BRACKET alias=edgeTypeAlias RIGHT_BRACKET_MINUS
    ;

arcTypeUndirected
    : TILDE_LEFT_BRACKET alias=edgeTypeAlias? filler=edgeTypeFiller RIGHT_BRACKET_TILDE
    | TILDE_LEFT_BRACKET alias=edgeTypeAlias RIGHT_BRACKET_TILDE
    ;

sourceNodeTypeSpecification
/* Factor out common endpoint node type specification

    : LEFT_PAREN alias=nodeTypeAlias RIGHT_PAREN                         #sourceNodeTypeByAlias
    | LEFT_PAREN filler=nodeTypeRefFiller RIGHT_PAREN                    #sourceNodeTypeByFiller
    | LEFT_PAREN LEFT_ANGLE_BRACKET alias=nodeTypeAlias RIGHT_PAREN      #sourceNodeSuperTypeByAlias
    | LEFT_PAREN LEFT_ANGLE_BRACKET filler=nodeTypeFiller RIGHT_PAREN #sourceNodeSuperTypeByFiller
    | LEFT_PAREN LEFT_ANGLE_BRACKET COLON RIGHT_PAREN                    #sourceNodeSuperTypeByAny
    ;
*/
    : endpoint=endpointNodeTypeSpecification
    ;


destinationNodeTypeSpecification
/* Factor out common endpoint node type specification

    : LEFT_PAREN alias=nodeTypeAlias RIGHT_PAREN                         #sourceNodeTypeByAlias
    | LEFT_PAREN filler=nodeTypeRefFiller RIGHT_PAREN                    #sourceNodeTypeByFiller
    | LEFT_PAREN LEFT_ANGLE_BRACKET alias=nodeTypeAlias RIGHT_PAREN      #sourceNodeSuperTypeByAlias
    | LEFT_PAREN LEFT_ANGLE_BRACKET filler=nodeTypeFiller RIGHT_PAREN    #sourceNodeSuperTypeByFiller
    | LEFT_PAREN LEFT_ANGLE_BRACKET COLON RIGHT_PAREN                    #sourceNodeSuperTypeByAny
    ;
*/
    : endpoint=endpointNodeTypeSpecification
    ;

endpointNodeTypeSpecification
    : LEFT_PAREN alias=nodeTypeAlias RIGHT_PAREN                          #endpointNodeTypeByAlias
    | LEFT_PAREN filler=nodeTypeRefFiller RIGHT_PAREN                     #endpointNodeTypeByFiller
    | LEFT_PAREN LEFT_ANGLE_BRACKET alias=nodeTypeAlias RIGHT_PAREN       #endpointNodeSuperTypeByAlias
    | LEFT_PAREN LEFT_ANGLE_BRACKET filler=nodeTypeRefFiller RIGHT_PAREN  #endpointNodeSuperTypeByFiller
    | LEFT_PAREN LEFT_ANGLE_BRACKET COLON RIGHT_PAREN                     #endpointNodeSuperTypeByAny
    ;

/* Remove support for graph element type names

edgeKind
    : DIRECTED
    | UNDIRECTED
    ;

endpointPairPhrase
    : CONNECTING endpointPair
    ;

endpointPair
    : endpointPairDirected
    | endpointPairUndirected
    ;

endpointPairDirected
    : endpointPairPointingRight
    | endpointPairPointingLeft
    ;

endpointPairPointingRight
    : LEFT_PAREN sourceNodeTypeAlias connectorPointingRight destinationNodeTypeAlias RIGHT_PAREN
    ;

endpointPairPointingLeft
    : LEFT_PAREN destinationNodeTypeAlias LEFT_ARROW sourceNodeTypeAlias RIGHT_PAREN
    ;

endpointPairUndirected
    : LEFT_PAREN sourceNodeTypeAlias connectorUndirected destinationNodeTypeAlias RIGHT_PAREN
    ;

connectorPointingRight
    : TO
    | RIGHT_ARROW
    ;

connectorUndirected
    : TO
    | TILDE
    ;
*/

/* Remove support for local node type aliases

sourceNodeTypeAlias
    : regularIdentifier
    ;

destinationNodeTypeAlias
    : regularIdentifier
    ;
*/

nodeTypeAlias
    : varIdent
    ;

/* Mirror node type alias concept

 */
edgeTypeAlias
    : varIdent
    ;

/* Simplify and factor out
*/
elementTypeKeyLabelSpecification
    : ( IS | COLON ) labelName
    ;


// ---------------------------------------------------------------------------------------------------------------------
// vvv Extension: constraints
// ---------------------------------------------------------------------------------------------------------------------

constraintDefinition
    : CONSTRAINT constraintName constraintBody
    ;

constraintBody
    : FOR constraintPattern constraintRequirement
    ;

constraintPattern
    : schemaQueryPattern
    ;

schemaQueryPattern
    : nodeSchemaQueryPattern
    | edgeSchemaQueryPattern
    ;

nodeSchemaQueryPattern
    : LEFT_PAREN schemaQueryPatternFiller RIGHT_PAREN
    ;

edgeSchemaQueryPattern
    : edgeSchemaQueryPatternDirected
    | edgeConstrainPatternUndirected
    ;

edgeSchemaQueryPatternDirected
    : edgeSchemaQueryPatternPointingLeftAndRight
    | edgeSchemaQueryPatternPointingRight
    | edgeSchemaQueryPatternPointingLeft
    ;

edgeSchemaQueryPatternPointingLeftAndRight
    : src=sourceNodeSchemaQueryPattern schemaQueryPatternArcPointingLeftAndRight dst=destinationNodeSchemaQueryPattern
    ;

edgeSchemaQueryPatternPointingRight
    : src=sourceNodeSchemaQueryPattern schemaQueryPatternArcPointingRight dst=destinationNodeSchemaQueryPattern
    ;

edgeSchemaQueryPatternPointingLeft
    : dst=destinationNodeSchemaQueryPattern schemaQueryPatternArcPointingLeft src=sourceNodeSchemaQueryPattern
    ;

edgeConstrainPatternUndirected
    : fst=sourceNodeSchemaQueryPattern schemaQueryPatternArcUndirected snd=destinationNodeSchemaQueryPattern
    ;

schemaQueryPatternArcPointingLeftAndRight
    : LEFT_ARROW_BRACKET filler=schemaQueryPatternFiller? BRACKET_RIGHT_ARROW
    ;

schemaQueryPatternArcPointingRight
    : MINUS_LEFT_BRACKET filler=schemaQueryPatternFiller? BRACKET_RIGHT_ARROW
    ;

schemaQueryPatternArcPointingLeft
    : LEFT_ARROW_BRACKET filler=schemaQueryPatternFiller? RIGHT_BRACKET_MINUS
    ;

schemaQueryPatternArcUndirected
    : TILDE_LEFT_BRACKET filler=schemaQueryPatternFiller? RIGHT_BRACKET_TILDE
    ;

sourceNodeSchemaQueryPattern
    : LEFT_PAREN filler=schemaQueryPatternFiller? RIGHT_PAREN
    ;

destinationNodeSchemaQueryPattern
    : LEFT_PAREN filler=schemaQueryPatternFiller? RIGHT_PAREN
    ;

schemaQueryPatternFiller
    : bindingVariable
    | bindingVariable schemaQueryPatternLabels
    | schemaQueryPatternLabels
    ;

schemaQueryPatternLabels
    : ( IS | COLON | LABELS ) labelSetSpecification
    ;

constraintRequirement
    : REQUIRE keyList IS PRIMARY? KEY
//  | REQUIRE keyList IS UNIQUE // Values can be null unless ruled out by element property types
    ;

keyList
    : LEFT_PAREN items+=keyListItem (COMMA items+=keyListItem)* RIGHT_PAREN     #compoundKeyList
    | item=keyListItem                                                          #singleKeyList
    ;

keyListItem
    : bindingVariable                               #keyListItemByVar
    | bindingVariable PERIOD_SIGN propertyName      #keyListItemByProp
    ;

