grammar GQL_PROGRAM;

import GQL_SESSION,
       GQL_TRANSACTIONS,
       GQL_PROCEDURES;

gqlProgram
/* Allow empty gqlProgram (should be treated same as FINISH) */
    : programActivity? sessionCloseCommand? EOF
    ;

programActivity
    : { Features.sessionCmds }? sessionActivity
    |                           transactionActivity
    ;

sessionActivity
    : sessionResetCommand+
    | sessionSetCommand+ sessionResetCommand*
    ;

transactionActivity
/* Reduce top-level transaction activities to effectively be procedure specifications */
    : { Features.transactionCmds }? startTransactionCommand (proc=procedureSpecification endTransactionCommand?)?
    | { Features.transactionCmds }? proc=procedureSpecification endTransactionCommand
    | { Features.transactionCmds }? endTransactionCommand
    |                               proc=procedureSpecification
    ;
