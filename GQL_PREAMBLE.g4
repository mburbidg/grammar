/* =====================================================================================================================
   GQL_PREAMBLE.g4
   =====================================================================================================================

   This file defines the productions of MSFTGQL for the GQL-preamble (a vendor extension).

   See MSFTGQL.g4 for further information on the MSFTGQL grammar.
*/
grammar GQL_PREAMBLE;

import GQL_NAMES,
       GQL_LITERALS;

gqlPreamble
    : GQL dialect=dialectSpecification? (extensions+=extensionSpecification)*
    ;

dialectSpecification
    : dialectName? (LEFT_PAREN optionsList=preambleOptionList? RIGHT_PAREN)+
    ;

dialectName
    : varIdent
    ;

extensionSpecification
    : PLUS_SIGN? name=extensionName (LEFT_PAREN optionsList=preambleOptionList? RIGHT_PAREN)?
    ;

extensionName
    : varIdent
    ;

preambleOptionList
    : (options+=preambleOption) (COMMA options+=preambleOption)*
    ;

preambleOption
    : EXCLAMATION_MARK? preambleOptionName                         #preambleFlagOption
    | preambleOptionName EQUALS_OPERATOR value=preambleOptionValue #preambleLongOption
    ;

preambleOptionName
    : varIdent
    ;

preambleOptionValue
    : valueLiteral
    ;
