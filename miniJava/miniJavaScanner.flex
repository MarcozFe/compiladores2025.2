%%

%public
%class MiniJavaLexer
%unicode
%line
%column
%standalone
%state COMMENT

%{
    private java.io.BufferedWriter writer = null;

    private void initWriterIfNeeded() {
        if (writer == null) {
            try {
                writer = new java.io.BufferedWriter(new java.io.FileWriter("saIDa.txt"));
            } catch (java.io.IOException e) {
                System.err.println("Erro ao abrir o arquivo de saída: " + e.getMessage());
                System.exit(1);
            }
        }
    }

    public void closeWriter() {
        if (writer != null) {
            try {
                writer.close();
            } catch (java.io.IOException e) {
                System.err.println("Erro ao fechar o arquivo de saída: " + e.getMessage());
            }
        }
    }
%}

LETRA           = [a-zA-Z]
DIGITO          = [0-9]
ID              = {LETRA}({LETRA}|{DIGITO}|"_")*
NUM_INT         = {DIGITO}{1,5}
unsigned_number = {DIGITO}{1,5}[uU]
real_number     = {DIGITO}+ "." {DIGITO}+
string_literal  = \"[^\"]*\"
char_literal    = \' . \'
space           = [ \t\r]+

%%

{space}                         { /* ignora espaços */ }
\n                              { /* ignora nova linha */ }

"//".*                          { /* ignora comentários de linha */ }

"/*"                            { yybegin(COMMENT); }
<COMMENT>[^*\n]+                { /* ignora conteúdo do comentário */ }
<COMMENT>"*"+[^*/\n]*           { /* ignora asteriscos */ }
<COMMENT>"*/"                   { yybegin(YYINITIAL); }
<COMMENT>\n                     { /* ignora nova linha */ }

("int"|"void"|"char"|"bool"|"string"|({LETRA}({LETRA}|{DIGITO}|"_")*))(" ")+({LETRA}({LETRA}|{DIGITO}|"_")*)"(" 
{ initWriterIfNeeded(); writer.write("<" + yytext() + ", _START_METHOD_DECL>\n"); }  
"string"                        { initWriterIfNeeded(); writer.write("<" + yytext() + ", TYPE>\n"); }
"bool"                          { initWriterIfNeeded(); writer.write("<" + yytext() + ", TYPE>\n"); }
"int"                           { initWriterIfNeeded(); writer.write("<" + yytext() + ", TYPE>\n"); }
"unsigned"                      { initWriterIfNeeded(); writer.write("<" + yytext() + ", TYPE>\n"); }
"char"                          { initWriterIfNeeded(); writer.write("<" + yytext() + ", TYPE>\n"); }
"eol"                           { initWriterIfNeeded(); writer.write("<" + yytext() + ", CHAR>\n"); }
"switch"                        { initWriterIfNeeded(); writer.write("<" + yytext() + ", SWITCH>\n"); }
"void"                          { initWriterIfNeeded(); writer.write("<" + yytext() + ", VOID>\n"); }
"while"                         { initWriterIfNeeded(); writer.write("<" + yytext() + ", WHILE>\n"); }
"break"                         { initWriterIfNeeded(); writer.write("<" + yytext() + ", BREAK>\n"); }
"null"                          { initWriterIfNeeded(); writer.write("<" + yytext() + ", NULL>\n"); }
"print"                         { initWriterIfNeeded(); writer.write("<" + yytext() + ", PRINTF>\n"); }
"program"                       { initWriterIfNeeded(); writer.write("<" + yytext() + ", PROGRAM>\n"); }
"class"                         { initWriterIfNeeded(); writer.write("<" + yytext() + ", CLASS>\n"); }
"const"                         { initWriterIfNeeded(); writer.write("<" + yytext() + ", CONST>\n"); }
"new"                           { initWriterIfNeeded(); writer.write("<" + yytext() + ", NEW>\n"); }
"read"                          { initWriterIfNeeded(); writer.write("<" + yytext() + ", READ>\n"); }
"extends"                       { initWriterIfNeeded(); writer.write("<" + yytext() + ", EXTENDS>\n"); }
"false"                         { initWriterIfNeeded(); writer.write("<" + yytext() + ", FALSE>\n"); }
"true"                          { initWriterIfNeeded(); writer.write("<" + yytext() + ", TRUE>\n"); }
"if"                            { initWriterIfNeeded(); writer.write("<" + yytext() + ", IF>\n"); }
"else"                          { initWriterIfNeeded(); writer.write("<" + yytext() + ", ELSE>\n"); }
"return"                        { initWriterIfNeeded(); writer.write("<" + yytext() + ", RETURN>\n"); }

"("                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", I_PAREN>\n"); }
")"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", F_PAREN>\n"); }
"["                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", LSQUARE_BRACKET>\n"); }
"]"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", RSQUARE_BRACKET>\n"); }
"{"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", LBRACKET>\n"); }
"}"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", RBRACKET>\n"); }
"."                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", DOT>\n"); }
","                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", COMMA>\n"); }
":"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", COLON>\n"); }
";"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", SEMICOLON>\n"); }
"="                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", ASSIGN>\n"); }
"++"                            { initWriterIfNeeded(); writer.write("<" + yytext() + ", PLUS_PLUS>\n"); }
"--"                            { initWriterIfNeeded(); writer.write("<" + yytext() + ", MINUS_MINUS>\n"); }
"+"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", PLUS>\n"); }
"-"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", MINUS>\n"); }
"*"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", TIMES>\n"); }
"/"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", DIV>\n"); }
"%"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", MOD>\n"); }
"~"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", NOTB>\n"); }
"!"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", NOT>\n"); }
"&&"                            { initWriterIfNeeded(); writer.write("<" + yytext() + ", AND>\n"); }
"||"                            { initWriterIfNeeded(); writer.write("<" + yytext() + ", OR>\n"); }
"&"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", APERSAND>\n"); }
"|"                             { initWriterIfNeeded(); writer.write("<" + yytext() + ", ORB>\n"); }

"<=" | ">=" | "==" | "!=" | "<" | ">" {
                                  initWriterIfNeeded(); writer.write("<" + yytext() + ", RELOP>\n");
                              }

{char_literal}                  { initWriterIfNeeded(); writer.write("<" + yytext() + ", CHAR>\n"); }
{string_literal}                { initWriterIfNeeded(); writer.write("<" + yytext() + ", STRING>\n"); }
{unsigned_number}               { initWriterIfNeeded(); writer.write("<" + yytext() + ", UNSIGNED_NUMBER>\n"); }
{NUM_INT}                       { initWriterIfNeeded(); writer.write("<" + yytext() + ", NUM_INT>\n"); }
{real_number}                   { initWriterIfNeeded(); writer.write("<" + yytext() + ", REAL>\n"); }
{ID}                            { initWriterIfNeeded(); writer.write("<" + yytext() + ", ID>\n"); }

.                               { throw new Error("Erro léxico: símbolo inválIDo '" + yytext() + "' na linha " + (yyline + 1) + ", coluna " + (yycolumn + 1)); }