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

endTransactionCommand
    : rollbackCommand
    | commitCommand
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

// ---------------------------------------------------------------------------------------------------------------------
// 8.2 <transaction characteristics>
// ---------------------------------------------------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------------------------------------------------
// 8.3 <rollback command>
// ---------------------------------------------------------------------------------------------------------------------

rollbackCommand
    : ROLLBACK
    ;

// ---------------------------------------------------------------------------------------------------------------------
// 8.4 <commit command>
// ---------------------------------------------------------------------------------------------------------------------

commitCommand
    : COMMIT
    ;

