/* =====================================================================================================================
   GQL_TRANSACTIONS.g4
   =====================================================================================================================

   This file defines the productions of OpenGQL for transaction commands.

   See OpenGQL.g4 for further information on the OpenGQL grammar.
*/
grammar GQL_TRANSACTIONS;

import GQL_PROCEDURES;

transactionActivity
    : startTransactionCommand (proc=procedureSpecification endTransactionCommand?)?
    | proc=procedureSpecification endTransactionCommand
    | endTransactionCommand
    ;

/* Dummy rules, to allow for iterative changes to the grammar */

startTransactionCommand
    : 'START_TRANSACTION'
    ;

endTransactionCommand
    : 'END_TRANSACTION'
    ;

/* Reduce top-level programs to effectively be procedure specifications

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

