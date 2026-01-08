/* =====================================================================================================================
   MSFTGQL.g4
   =====================================================================================================================

   This file defines the Microsoft GQL grammar for use by Fabric Graph and related products.

   It is based on the original work by the GDC's openGQL project which in turn aims to faithfully follow
   the grammar of the International Standard ISO/IEC 39075:2024(en) GQL. Related comments tracing back to
   the openGQL source are marked with [openGQL].

   Certain aspects of the structure of the original GQL grammar mainly cater for the specification needs of
   the International Standard. The MSFTGQL grammar primarily targets use by implementations though. Therefore,
   it was adjusted relative to the openGQL grammar for increased brevity and useability of resulting parse trees.
   In consequence, MSFTGQL is set up to "overparse", i.e., it might accept more syntax outside of the GQL specification
   than the openGQL grammar (once all features are commented in). This is intentional and benign. Implementations always
   need to restrict accepted syntax through additional verification steps during static analysis, as required by
   the International Standard.
*/
grammar MSFTGQL;

options { caseInsensitive = true; }

import GQL_PROGRAM;

gqlSource
    : gqlProgram WHITESPACE* EOF
    ;