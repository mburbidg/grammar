grammar GQL_PROGRAM;

import GQL_PROCEDURES;

gqlProgram
/* - Reduce top-level programs to effectively be procedure specifications
   with an optional preamble
   - Allow empty gqlProgram (should be treated same as FINISH)
   - Add a GQL-preamble

    : programActivity sessionCloseCommand? EOF
    | sessionCloseCommand EOF
*/
    : programActivity?
    ;

programActivity
/* Reduce top-level programs to effectively be procedure specifications

    : sessionActivity
    | transactionActivity
*/
    : proc=procedureSpecification
    ;

/* Reduce top-level programs to effectively be procedure specifications

sessionActivity
    : sessionResetCommand+
    | sessionSetCommand+ sessionResetCommand*
    ;

transactionActivity
    : startTransactionCommand (procedureSpecification endTransactionCommand?)?
    | procedureSpecification endTransactionCommand?
    | endTransactionCommand
    ;

endTransactionCommand
    : rollbackCommand
    | commitCommand
    ;
*/


// =====================================================================================================================
// 7 Session management
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 7.1 <session set command>
// ---------------------------------------------------------------------------------------------------------------------

/* Reduce top-level programs to effectively be procedure specifications

sessionSetCommand
    : SESSION SET
        (sessionSetSchemaClause | sessionSetGraphClause | sessionSetTimeZoneClause | sessionSetParameterClause)
    ;

sessionSetSchemaClause
    : SCHEMA schemaReference
    ;

sessionSetGraphClause
    : PROPERTY? GRAPH graphExpression
    ;

sessionSetTimeZoneClause
    : TIME ZONE setTimeZoneValue
    ;

setTimeZoneValue
    : timeZoneString
    ;

sessionSetParameterClause
    : sessionSetGraphParameterClause
    | sessionSetBindingTableParameterClause
    | sessionSetValueParameterClause
    ;

sessionSetGraphParameterClause
    : PROPERTY? GRAPH sessionSetParameterName optTypedGraphInitializer
    ;

sessionSetBindingTableParameterClause
    : BINDING? TABLE sessionSetParameterName optTypedBindingTableInitializer
    ;

sessionSetValueParameterClause
    : VALUE sessionSetParameterName optTypedValueInitializer
    ;

sessionSetParameterName
    : (IF NOT EXISTS)? sessionParameterSpecification
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 7.2 <session reset command>
// ---------------------------------------------------------------------------------------------------------------------

/* Reduce top-level programs to be procedure specifications
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
*/

// ---------------------------------------------------------------------------------------------------------------------
// 7.3 <session close command>
// ---------------------------------------------------------------------------------------------------------------------

/* Reduce top-level programs to be procedure specifications

sessionCloseCommand
    : SESSION CLOSE
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 7.4 <session parameter specification>
// ---------------------------------------------------------------------------------------------------------------------

/* Reduce top-level programs to be procedure specifications

sessionParameterSpecification
    : GENERAL_PARAMETER_REFERENCE
    ;


// =====================================================================================================================
// 8 Transaction management
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 8.1 <start transaction command>
// ---------------------------------------------------------------------------------------------------------------------

startTransactionCommand
    : START TRANSACTION transactionCharacteristics?
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 8.2 <transaction characteristics>
// ---------------------------------------------------------------------------------------------------------------------

/* Reduce top-level programs to be procedure specifications

transactionCharacteristics
    : transactionMode (COMMA transactionMode)*
    ;

transactionMode
    : transactionAccessMode
    ;

transactionAccessMode
    : READ ONLY
    | READ WRITE
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 8.3 <rollback command>
// ---------------------------------------------------------------------------------------------------------------------

/* Reduce top-level programs to be procedure specifications

rollbackCommand
    : ROLLBACK
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 8.4 <commit command>
// ---------------------------------------------------------------------------------------------------------------------

commitCommand
    : COMMIT
    ;
*/
