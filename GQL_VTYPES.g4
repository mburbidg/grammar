grammar GQL_VTYPES;

import GQL_NAMES,
       GQL_PARTICLES;

// =====================================================================================================================
// 18 Type elements
// =====================================================================================================================

// Add graph type support
//
// Note:
//
// nodeTypeRef and edgeTypeRef are essentially severly simplified copies of the corresponding
// nodeTypeSpecification and edgeTypeSpecification productions from the GQL standard.
//
// This was done in order to decouble object types and value types as well as more directly
// realize additionally required restrictions on element reference value type syntax.
//
// The decoupling also simplifies evolving the graph type grammar independently from the
// value type grammar.
//

// ---------------------------------------------------------------------------------------------------------------------
// 18.2 <node type specification>
// ---------------------------------------------------------------------------------------------------------------------

nodeTypeRef
    : pattern=nodeTypeRefPattern
/* Remove support for graph element type names

    | nodeTypePhrase
*/
    ;

nodeTypeRefPattern
/* Remove support for graph element type names

    : (( NODE | VERTEX ) TYPE? nodeTypeName)? LEFT_PAREN localNodeTypeAlias? nodeTypeFiller? RIGHT_PAREN
*/

    : LEFT_PAREN filler=nodeTypeRefFiller RIGHT_PAREN
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

nodeTypeRefFiller
    : inner=elementTypeRefFiller
    ;

/* Add graph type support

   Inline duplicated productions

elementTypeRefFiller
    : elementTypeRefLabelSet
    | elementTypeRefPropertyTypes
    | elementTypeRefLabelSet elementTypeRefPropertyTypes
    ;
*/

elementTypeRefFiller
/* Invariantly referenced types must have a label in MSFTGQL

    : labelSetPhrase
    | propertyTypesSpecification
    | labelSetPhrase propertyTypesSpecification
*/
    : labels=labelSetPhrase propertyTypes=propertyTypesSpecification?
    ;

/* Add graph type support

   Inline duplicated productions

elementTypeRefLabelSet
    : labelSetPhrase
    ;

elementTypeRefPropertyTypes
    : propertyTypesSpecification
    ;
*/


// ---------------------------------------------------------------------------------------------------------------------
// 18.3 <edge type specification>
// ---------------------------------------------------------------------------------------------------------------------

edgeTypeRef
    : pattern=edgeTypeRefPattern
/* Remove support for graph element type names

    | edgeTypePhrase
*/
    ;

edgeTypeRefPattern
/* Remove support for graph element type names

    : (edgeKind? ( EDGE | RELATIONSHIP ) TYPE? edgeTypeName)? (edgeTypePatternDirected | edgeTypePatternUndirected)
*/

    : (edgeTypeRefPatternDirected | edgeTypeRefPatternUndirected)
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

edgeTypeRefPatternDirected
    : edgeTypeRefPatternPointingRight
    | edgeTypeRefPatternPointingLeft
    ;

edgeTypeRefPatternPointingRight
    : src=sourceNodeTypeRef arcTypeRefPointingRight dst=destinationNodeTypeRef
    ;

edgeTypeRefPatternPointingLeft
    : dst=destinationNodeTypeRef arcTypeRefPointingLeft src=sourceNodeTypeRef
    ;

edgeTypeRefPatternUndirected
    : fst=sourceNodeTypeRef arcTypeRefUndirected snd=destinationNodeTypeRef
    ;

arcTypeRefPointingRight
    : MINUS_LEFT_BRACKET filler=edgeTypeRefFiller BRACKET_RIGHT_ARROW
    ;

arcTypeRefPointingLeft
    : LEFT_ARROW_BRACKET filler=edgeTypeRefFiller RIGHT_BRACKET_MINUS
    ;

arcTypeRefUndirected
    : TILDE_LEFT_BRACKET filler=edgeTypeRefFiller RIGHT_BRACKET_TILDE
    ;

sourceNodeTypeRef
/* Add graph type support

    : LEFT_PAREN alias=nodeTypeAlias RIGHT_PAREN          #sourceNodeTypeByAlias
    | LEFT_PAREN filler=nodeTypeRefFiller? RIGHT_PAREN    #sourceNodeTypeByFiller
*/
    : endpoint=endpointNodeTypeRef
    ;

destinationNodeTypeRef
/* Add graph type support

    : LEFT_PAREN alias=nodeTypeAlias RIGHT_PAREN           #destinationNodeTypeByAlias
    | LEFT_PAREN filler=nodeTypeRefFiller? RIGHT_PAREN     #destinationNodeTypeByFiller
*/
    : endpoint=endpointNodeTypeRef
    ;

endpointNodeTypeRef
    : LEFT_PAREN filler=nodeTypeRefFiller RIGHT_PAREN    #endpointNodeTypeRefByFiller
    ;

edgeTypeRefFiller
    : inner=elementTypeRefFiller
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

   These only make sense in a graph type context and should be removed here until graph types are supported.

sourceNodeTypeAlias
    : regularIdentifier
    ;

destinationNodeTypeAlias
    : regularIdentifier
    ;
*/

/* M4: Add graph type support

nodeTypeAlias
    : varIdent
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 18.4 <label set phrase> and <label set specification>
// ---------------------------------------------------------------------------------------------------------------------

labelSetPhrase
    : LABEL labelName                               #labelSetByName
/* Inline isOrColon

    | isOrColon labelSetSpecification
*/
    | ( IS | COLON | LABELS ) labelSetSpecification  #labelSetBySpec
    ;

labelSetSpecification
    : labels+=labelName (AMPERSAND labels+=labelName)*
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 18.5 <property types specification>
// ---------------------------------------------------------------------------------------------------------------------

propertyTypesSpecification
    : LEFT_BRACE (propTypes+=propertyType (COMMA propTypes+=propertyType)*)? RIGHT_BRACE
    ;


// ---------------------------------------------------------------------------------------------------------------------
// 18.6 <property type>
// ---------------------------------------------------------------------------------------------------------------------

propertyType
    : propertyName ( DOUBLE_COLON | TYPED )? propertyValueType
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 18.7 <property value type>
// ---------------------------------------------------------------------------------------------------------------------

propertyValueType
    : valueType
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 18.8 <binding table type>
// ---------------------------------------------------------------------------------------------------------------------

/* Simplify reference value types

bindingTableType
    : BINDING? TABLE fieldTypeSetSpecification
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 18.9 <value type>
// ---------------------------------------------------------------------------------------------------------------------

valueType
    : predefinedType                                                                      #predefinedTypeLabel
    // <constructed value type>
    | pathValueType                                                                       #pathValueTypeLabel
/* Remove max length specification from list value types

    Technically this is a non-conformant change. However, the lack of GQL Conformance Feature optionalizing this can be
    considered a bug.

    | listValueTypeName
        LEFT_ANGLE_BRACKET valueType RIGHT_ANGLE_BRACKET
        (LEFT_BRACKET maxLength RIGHT_BRACKET)? notNull?                                  #listValueTypeAlt1
    | valueType listValueTypeName (LEFT_BRACKET maxLength RIGHT_BRACKET)? notNull?        #listValueTypeAlt2
    | listValueTypeName (LEFT_BRACKET maxLength RIGHT_BRACKET)? notNull?                  #listValueTypeAlt3
*/
    | listValueTypeName LEFT_ANGLE_BRACKET valueType RIGHT_ANGLE_BRACKET notNull?         #listValueTypeAlt1
    | valueType listValueTypeName notNull?                                                #listValueTypeAlt2
    | listValueTypeName notNull?                                                          #listValueTypeAlt3
    | recordType                                                                          #recordTypeLabel
    // <dynamic union type>
    | ANY VALUE? notNull?                                                                 #openDynamicUnionTypeLabel
/* Remove any property value type

    | ANY? PROPERTY VALUE notNull?                                                        #dynamicPropertyValueTypeLabel
*/
    // <closed dynamic union type>
    | ANY VALUE?
      LEFT_ANGLE_BRACKET valueType (VERTICAL_BAR valueType)+ RIGHT_ANGLE_BRACKET          #closedDynamicUnionTypeAlt1
    | valueType (VERTICAL_BAR valueType)+                                                 #closedDynamicUnionTypeAlt2
    ;

predefinedType
    : booleanType
    | characterStringType
    | byteStringType
    | numericType
    | temporalType
    | referenceValueType
    | immaterialValueType
    ;

booleanType
    : (BOOL | BOOLEAN) notNull?
    ;

characterStringType
/* Simplify character string types

    : STRING (LEFT_PAREN (minLength COMMA)? maxLength RIGHT_PAREN)? notNull?
    | CHAR (LEFT_PAREN fixedLength RIGHT_PAREN)? notNull?
    | VARCHAR (LEFT_PAREN maxLength RIGHT_PAREN)? notNull?
*/
    : STRING notNull?
    | VARCHAR notNull?
    ;

byteStringType
/* Simplify byte string types

    : BYTES (LEFT_PAREN (minLength COMMA)? maxLength RIGHT_PAREN)? notNull?
    | BINARY (LEFT_PAREN fixedLength RIGHT_PAREN)? notNull?
    | VARBINARY (LEFT_PAREN maxLength RIGHT_PAREN)? notNull?
*/
    : BYTES notNull?
    | VARBINARY notNull?
    ;

/* Remove unused productions

minLength
    : unsignedInteger
    ;

maxLength
    : unsignedInteger
    ;

fixedLength
    : unsignedInteger
    ;
*/

numericType
    : exactNumericType
    | approximateNumericType
    ;

exactNumericType
    : binaryExactNumericType
    | decimalExactNumericType
    ;

binaryExactNumericType
    : signedBinaryExactNumericType
    | unsignedBinaryExactNumericType
    ;

signedBinaryExactNumericType
/* Simplifiy integer types

    : INT8 notNull?
    | INT16 notNull?
    | INT32 notNull?
    | INT64 notNull?
    | INT128 notNull?
    | INT256 notNull?
    | SMALLINT notNull?
    | INT (LEFT_PAREN precision RIGHT_PAREN)? notNull?
    | BIGINT notNull?
    | SIGNED? verboseBinaryExactNumericType
*/
    : ((SIGNED? INTEGER) | INT) notNull?
    | ((SIGNED? INTEGER64) | INT64) notNull?
    | ((SIGNED? INTEGER32) | INT32) notNull?
    ;

unsignedBinaryExactNumericType
/* Simplify unsigned integer types

    : UINT8 notNull?
    | UINT16 notNull?
    | UINT32 notNull?
    | UINT64 notNull?
    | UINT128 notNull?
    | UINT256 notNull?
    | USMALLINT notNull?
    | UINT (LEFT_PAREN precision RIGHT_PAREN)? notNull?
    | UBIGINT notNull?
    | UNSIGNED verboseBinaryExactNumericType
*/
    : ((UNSIGNED INTEGER) | UINT) notNull?
    | ((UNSIGNED INTEGER64) | UINT64) notNull?
    | ((UNSIGNED INTEGER32) | UINT32) notNull?
    ;

/* Simplify integer types

verboseBinaryExactNumericType
    : INTEGER8 notNull?
    | INTEGER16 notNull?
    | INTEGER32 notNull?
    | INTEGER64 notNull?
    | INTEGER128 notNull?
    | INTEGER256 notNull?
    | SMALL INTEGER notNull?
    | INTEGER (LEFT_PAREN precision RIGHT_PAREN)? notNull?
    | BIG INTEGER notNull?
    ;
*/

decimalExactNumericType
    : (DECIMAL | DEC) (LEFT_PAREN precision (COMMA scale)? RIGHT_PAREN)? notNull?
    ;

precision
    : unsignedDecimalInteger
    ;

scale
    : unsignedDecimalInteger
    ;

approximateNumericType
/* Simplify approximate numeric types

    : FLOAT16 notNull?
    | FLOAT64 notNull?
    | FLOAT128 notNull?
    | FLOAT256 notNull?
    | FLOAT (LEFT_PAREN precision (COMMA scale)? RIGHT_PAREN)? notNull?
    | REAL notNull?
    | DOUBLE PRECISION? notNull?
*/
    : FLOAT notNull?
    | FLOAT64 notNull?
    | FLOAT32 notNull?
    | DOUBLE PRECISION? notNull?
    ;

temporalType
    : temporalInstantType
    | temporalDurationType
    ;

temporalInstantType
    : datetimeType
    | localdatetimeType
    | dateType
    | timeType
    | localtimeType
    ;

datetimeType
    : ( ZONED DATETIME | TIMESTAMP WITH TIME ZONE ) notNull?
    ;

localdatetimeType
    : LOCAL DATETIME notNull?
    | TIMESTAMP (WITHOUT TIME ZONE)? notNull?
    ;

dateType
    : DATE notNull?
    ;

timeType
    : ZONED TIME notNull?
    | TIME WITH TIME ZONE notNull?
    ;

localtimeType
    : LOCAL TIME notNull?
    | TIME WITHOUT TIME ZONE notNull?
    ;

temporalDurationType
    : DURATION LEFT_PAREN temporalDurationQualifier RIGHT_PAREN notNull?
    ;

temporalDurationQualifier
    : YEAR TO MONTH
    | DAY TO SECOND
    ;

referenceValueType
/* Simplify reference value types

    : graphReferenceValueType
    | bindingTableReferenceValueType
    | nodeReferenceValueType
    | edgeReferenceValueType
*/
    : nodeReferenceValueType
    | edgeReferenceValueType
    ;

immaterialValueType
    : nullType
    | emptyType
    ;

nullType
    : NULL_TOKEN
    ;

emptyType
    : NULL_TOKEN notNull
    | NOTHING
    ;

/* Simplify reference value types

graphReferenceValueType
    : openGraphReferenceValueType
    | closedGraphReferenceValueType
    ;

closedGraphReferenceValueType
    : PROPERTY? GRAPH nestedGraphTypeSpecification notNull?
    ;

openGraphReferenceValueType
    : ANY PROPERTY? GRAPH notNull?
    ;

bindingTableReferenceValueType
    : bindingTableType notNull?
    ;
*/

nodeReferenceValueType
    : openNodeReferenceValueType
    | closedNodeReferenceValueType
    ;

openNodeReferenceValueType
    : ANY? ( NODE | VERTEX ) notNull?
    ;

closedNodeReferenceValueType
/* Add graph type support

    : nodeTypeSpecification notNull?
*/
    : nodeTypeRef notNull?
    ;

edgeReferenceValueType
    : openEdgeReferenceValueType
    | closedEdgeReferenceValueType
    ;

openEdgeReferenceValueType
    : ANY? ( EDGE | RELATIONSHIP ) notNull?
    ;

closedEdgeReferenceValueType
/* Add graph type support

    : edgeTypeSpecification notNull?
*/
    : edgeTypeRef notNull?
    ;

pathValueType
    : PATH notNull?
    ;

recordType
    : ANY? RECORD notNull?                          #openRecordType
    | RECORD? fieldTypeSetSpecification notNull?    #closedRecordType
    ;

fieldTypeSetSpecification
    : LEFT_BRACE (fieldTypes+=fieldType (COMMA fieldTypes+=fieldType)*)? RIGHT_BRACE
    ;

notNull
    :  NOT NULL_TOKEN
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 18.10 <field type>
// ---------------------------------------------------------------------------------------------------------------------

fieldType
    : fieldName ( DOUBLE_COLON | TYPED )? valueType
    ;
