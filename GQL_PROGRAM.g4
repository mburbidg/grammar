grammar GQL_PROGRAM;

import GQL_SESSION,
       GQL_PROCEDURES;

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

/* Reduce top-level programs to effectively be procedure specifications

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
