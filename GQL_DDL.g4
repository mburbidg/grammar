/* =====================================================================================================================
   GQL_DDL.g4
   =====================================================================================================================

   This file defines the productions of OpenGQL catalog-modifying statements (aka DDL statements).

   See OpenGQL.g4 for further information on the OpenGQL grammar.
*/
grammar GQL_DDL;

import GQL_NAMES,
       GQL_PARTICLES,
       GQL_PROCEDURES,
       GQL_OTYPES;

// =====================================================================================================================
// 12 Catalog-modifying statements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 12.1 <linear catalog-modifying statement>
// ---------------------------------------------------------------------------------------------------------------------

linearCatalogModifyingStatement
    : simpleCatalogModifyingStatement+
    ;

simpleCatalogModifyingStatement
    : primitiveCatalogModifyingStatement
    | callCatalogModifyingProcedureStatement
    ;

primitiveCatalogModifyingStatement
    : createSchemaStatement
    | dropSchemaStatement
    | createGraphStatement
    | dropGraphStatement
    | createGraphTypeStatement
    | dropGraphTypeStatement
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.2 <insert schema statement>
// ---------------------------------------------------------------------------------------------------------------------

createSchemaStatement
    : CREATE SCHEMA (IF NOT EXISTS)? catalogSchemaParentAndName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.3 <drop schema statement>
// ---------------------------------------------------------------------------------------------------------------------

dropSchemaStatement
    : DROP SCHEMA (IF EXISTS)? catalogSchemaParentAndName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.4 <create graph statement>
// ---------------------------------------------------------------------------------------------------------------------

createGraphStatement
    : CREATE (PROPERTY? GRAPH (IF NOT EXISTS)? | OR REPLACE PROPERTY? GRAPH)
        catalogGraphParentAndName (openGraphType | ofGraphType) graphSource?
    ;

openGraphType
    : ( DOUBLE_COLON | TYPED )? ANY (PROPERTY? GRAPH)?
    ;

ofGraphType
    : graphTypeLikeGraph
    | ( DOUBLE_COLON | TYPED )? graphTypeReference
    | ( DOUBLE_COLON | TYPED )? (PROPERTY? GRAPH)? nestedGraphTypeSpecification
    ;

graphTypeLikeGraph
    : LIKE graphExpression
    ;

graphSource
    : AS COPY OF graphExpression
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.5 <drop graph statement>
// ---------------------------------------------------------------------------------------------------------------------

dropGraphStatement
    : DROP PROPERTY? GRAPH (IF EXISTS)? catalogGraphParentAndName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.6 <create graph type statement>
// ---------------------------------------------------------------------------------------------------------------------

createGraphTypeStatement
    : CREATE (PROPERTY? GRAPH TYPE (IF NOT EXISTS)? | OR REPLACE PROPERTY? GRAPH TYPE)
        catalogGraphTypeParentAndName graphTypeSource
    ;

graphTypeSource
    : AS? copyOfGraphType
    | graphTypeLikeGraph
    | AS? nestedGraphTypeSpecification
    ;

copyOfGraphType
    : COPY OF graphTypeReference
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.7 <drop graph type statement>
// ---------------------------------------------------------------------------------------------------------------------

dropGraphTypeStatement
    : DROP PROPERTY? GRAPH TYPE (IF EXISTS)? catalogGraphTypeParentAndName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.8 <call catalog-modifying statement>
// ---------------------------------------------------------------------------------------------------------------------

callCatalogModifyingProcedureStatement
    : callProcedureStatement
    ;
