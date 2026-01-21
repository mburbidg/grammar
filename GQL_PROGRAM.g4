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
