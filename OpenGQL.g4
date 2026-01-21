/* =====================================================================================================================
   OpenGQL.g4
   =====================================================================================================================

   This file defines the OpenGQL grammar.
*/
grammar OpenGQL;

options { caseInsensitive = true; }

import GQL_PROGRAM;

gqlSource
    : gqlProgram WHITESPACE* EOF
    ;