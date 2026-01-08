/* =====================================================================================================================
   MSFTGQL_TEST.g4
   =====================================================================================================================

   This grammar supports testing of multiple GQL programs (as defined by the MSFTGQL grammar) in a single file.

   It should be used for testing purposes only.

   See MSFTGQL.g4 for further information on the MSFTGQL grammar.
*/

grammar MSFTGQL_TEST;

options { caseInsensitive = true; }

import GQL_PROGRAM;

// All additions in this file are outside the GQL standard. It should be used for running tests only.

gqlProgramTestSequence
    : gqlProgram gqlProgramTest* WHITESPACE* EOF
    | (gqlProgramTest | gqlGraphTypeTest)* WHITESPACE* EOF
    ;

gqlProgramTest
    : TEST_COMMENT_START TEST_COMMENT_CONTINUE* gqlProgram
    ;

gqlGraphTypeTest
    : TEST_GRAPH_TYPE_COMMENT_START TEST_COMMENT_CONTINUE* graphTypeSpecification
    ;

TEST_COMMENT_START: ';; TEST: ' .*? CR? LF;
TEST_GRAPH_TYPE_COMMENT_START: ';; TEST <graph type specification>: ' .*? CR? LF;
TEST_COMMENT_CONTINUE: ';;' .*? CR? LF;

