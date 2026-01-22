/* =====================================================================================================================
   GQL_PROGRAM.g4
   =====================================================================================================================

   This file defines the productions of OpenGQL for program and activities.

   See OpenGQL.g4 for further information on the OpenGQL grammar.
*/
grammar GQL_PROGRAM;

import GQL_SESSION,
       GQL_TRANSACTIONS,
       GQL_PROCEDURES;

gqlProgram
/* Allow empty gqlProgram (should be treated same as FINISH) */
    : programActivity? sessionCloseCommand? EOF
    ;

programActivity
    : { Features.sessionCmds }?     sessionActivity
    | { Features.transactionCmds }? transactionActivity
    |                               proc=procedureSpecification
    ;
