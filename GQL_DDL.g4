/* =====================================================================================================================
   GQL_DDL.g4
   =====================================================================================================================

   This file defines the productions of MSFTGQL catalog-modifying statements (aka DDL statements).

   See MSFTGQL.g4 for further information on the MSFTGQL grammar.
*/
grammar GQL_DDL;

import GQL_NAMES,
       GQL_PARTICLES,
       GQL_OTYPES;

// =====================================================================================================================
// 12 Catalog-modifying statements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 12.1 <linear catalog-modifying statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable DDL and DML

linearCatalogModifyingStatement
    : simpleCatalogModifyingStatement+
    ;

simpleCatalogModifyingStatement
    : primitiveCatalogModifyingStatement
    | callCatalogModifyingProcedureStatement
    ;
*/

primitiveCatalogModifyingStatement

/* Disable DDL and DML

    : createSchemaStatement
    | dropSchemaStatement
*/
    : createGraphStatement
    | dropGraphStatement
 /* Disable Cut out DDL and DML

    | createGraphTypeStatement
    | dropGraphTypeStatement
*/
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.2 <insert schema statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable out DDL and DML

createSchemaStatement
    : CREATE SCHEMA (IF NOT EXISTS)? catalogSchemaParentAndName
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 12.3 <drop schema statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable DDL and DML

dropSchemaStatement
    : DROP SCHEMA (IF EXISTS)? catalogSchemaParentAndName
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 12.4 <create graph statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable DDL and DML

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
*/

createGraphStatement
    : CREATE (PROPERTY? GRAPH (IF NOT EXISTS)? | OR REPLACE PROPERTY? GRAPH)
        // Mild simplifying deviation from GQL reflecting the fact that
        // there is no support for a complex catalog with multiple schemas yet
        graphName ofGraphType
    ;

ofGraphType
    : ( DOUBLE_COLON | TYPED )? (PROPERTY? GRAPH)? nestedGraphTypeSpecification
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.5 <drop graph statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable DDL and DML

dropGraphStatement
    : DROP PROPERTY? GRAPH (IF EXISTS)? catalogGraphParentAndName
    ;
*/
dropGraphStatement
    // Mild simplifying deviation from GQL reflecting the fact that
    // there is no support for a complex catalog with multiple schemas yet
    : DROP PROPERTY? GRAPH (IF EXISTS)? graphName
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 12.6 <create graph type statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable DDL and DML

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
*/

// ---------------------------------------------------------------------------------------------------------------------
// 12.7 <drop graph type statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable DDL and DML

dropGraphTypeStatement
    : DROP PROPERTY? GRAPH TYPE (IF EXISTS)? catalogGraphTypeParentAndName
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 12.8 <call catalog-modifying statement>
// ---------------------------------------------------------------------------------------------------------------------

/* Disable DDL and DML

callCatalogModifyingProcedureStatement
    : callProcedureStatement
    ;
*/
