/* =====================================================================================================================
   GQL_IDENTS.g4
   =====================================================================================================================

   This file defines the productions of OpenGQL for identifiers and related lexical elements.

   See OpenGQL.g4 for further information on the OpenGQL grammar.
*/
grammar GQL_IDENTS;

import GQL_LEXER;

// =====================================================================================================================
// 21 Lexical elements
// =====================================================================================================================

// ---------------------------------------------------------------------------------------------------------------------
// 21.1 Names and Variables
// ---------------------------------------------------------------------------------------------------------------------

// any identifier syntax used for "names" (<identifier>s in Int'l Standard ISO/IEC 39075:2024(en) GQL)
anyIdent
/* Inline regularIdentifier definition in identifier

    : regularIdentifier
*/
    // <regular identifier>
    : REGULAR_IDENTIFIER                    #anyIdentPlain
    | nonReservedWords                      #anyIdentNonResWord
    // <delimited identifier>; consider using DELIMITED_IDENTIFIER here directly
    | DOUBLE_QUOTED_CHARACTER_SEQUENCE      #anyIdentInDQuotes
    | ACCENT_QUOTED_CHARACTER_SEQUENCE      #anyIdentInAccents
    ;

/* Introduce variableIdentifier

*/

// var identifier syntax is used for "variables" (<regular identifier>s in Int'l Standard ISO/IEC 39075:2024(en) GQL)
varIdent
    // <regular identifier>
    : REGULAR_IDENTIFIER                    #varIdentPlain
    | nonReservedWords                      #varIdentNonResWord
    ;

/* Inline regularIdentifier definition in variableIdentifier

regularIdentifier
    : REGULAR_IDENTIFIER
    | nonReservedWords
    ;
*/

// ---------------------------------------------------------------------------------------------------------------------
// 21.3 <token>, <separator>, and <identifier>
// ---------------------------------------------------------------------------------------------------------------------

nonReservedWords
    : ACYCLIC
    | BINDING
    | BINDINGS
    | CONNECTING
    | DAY               // Non-reserved in MSFTGQL only
    | DAYS              // MSFTGQL only
    | DESTINATION
    | DIFFERENT
    | DIRECTED
    | FIRST
    | GRAPH
    | GROUPS
    | HOUR              // Non-reserved in MSFTGQL only
    | HOURS             // MSFTGQL only
    | KEEP
    | LABELED
    | LAST
    | MICROSECOND       // MSFTGQL only
    | MICROSECONDS      // MSFTGQL only
    | MILLISECOND       // MSFTGQL only
    | MILLISECONDS      // MSFTGQL only
    | MINUTE            // Non-reserved in MSFTGQL only
    | MINUTES           // MSFTGQL only
    | MONTH             // Non-reserved in MSFTGQL only
    | MONTHS            // MSFTGQL only
    | NANOSECOND        // MSFTGQL only
    | NANOSECONDS       // MSFTGQL only
    | NFC
    | NFD
    | NFKC
    | NFKD
    | NO
    | NORMALIZED
    | ONLY
    | ORDINALITY
    | OVER              // Non-reserved in MSFTGQL only
    | PER               // Non-reserved in MSFTGQL only
    | PRIMARY
    | PROPERTY
    | READ
    | REPEATABLE
    | REQUIRE
    | SECOND            // Non-reserved in MSFTGQL only
    | SECONDS           // Non-reserved in MSFTGQL only
    | SHORTEST
    | SIMPLE
    | SOURCE
    | TABLE
    | TEMP
    | TIMEZONE          // Non-reserved in MSFTGQL only
    | TO
    | TRAIL
    | TRANSACTION
    | TYPE
    | UNDIRECTED
    | WALK
    | WEEK              // MSFTGQL only
    | WEEKS             // MSFTGQL only
    | WITHOUT
    | WRITE
    | YEAR              // MSFTGQL only
    | YEARS             // MSFTGQL only
    | ZONE
    ;