grammar GQL_SESSION;

import GQL_LITERALS,
       GQL_PROCEDURES;

sessionActivity
    : sessionResetCommand+
    | sessionSetCommand+ sessionResetCommand*
    ;

// =====================================================================================================================
// 7 Session management
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 7.1 <session set command>
// ---------------------------------------------------------------------------------------------------------------------

sessionSetCommand
    : SESSION SET (
        sessionSetSchemaClause
//        | sessionSetGraphClause
        | sessionSetTimeZoneClause
//        | sessionSetParameterClause
    )
    ;

sessionSetSchemaClause
    : SCHEMA schemaReference
    ;
//
//sessionSetGraphClause
//    : PROPERTY? GRAPH graphExpression
//    ;

sessionSetTimeZoneClause
    : TIME ZONE timeZoneString
    ;
//
//sessionSetParameterClause
//    : sessionSetGraphParameterClause
//    | sessionSetBindingTableParameterClause
//    | sessionSetValueParameterClause
//    ;
//
//sessionSetGraphParameterClause
//    : PROPERTY? GRAPH sessionSetParameterName optTypedGraphInitializer
//    ;
//
//sessionSetBindingTableParameterClause
//    : BINDING? TABLE sessionSetParameterName optTypedBindingTableInitializer
//    ;
//
//sessionSetValueParameterClause
//    : VALUE sessionSetParameterName optTypedValueInitializer
//    ;
//
//sessionSetParameterName
//    : (IF NOT EXISTS)? sessionParameterSpecification
//    ;

// ---------------------------------------------------------------------------------------------------------------------
// 7.2 <session reset command>
// ---------------------------------------------------------------------------------------------------------------------

sessionResetCommand
    : SESSION RESET sessionResetArguments?
    ;

sessionResetArguments
    : ALL? (PARAMETERS | CHARACTERISTICS)
    | SCHEMA
    | PROPERTY? GRAPH
    | TIME ZONE
    | PARAMETER? sessionParameterSpecification
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 7.3 <session close command>
// ---------------------------------------------------------------------------------------------------------------------

sessionCloseCommand
    : SESSION CLOSE
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 7.4 <session parameter specification>
// ---------------------------------------------------------------------------------------------------------------------

sessionParameterSpecification
    : GENERAL_PARAMETER_REFERENCE
    ;
