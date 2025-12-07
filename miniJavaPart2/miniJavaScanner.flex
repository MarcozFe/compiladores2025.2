/* miniJavaScanner.flex */
import java.io.IOException;

%%

%public
%class MiniJavaLexer
%implements Parser.Lexer
%unicode
%line
%column
%int

%{
    private Object semanticVal;

    @Override
    public Object getLVal() {
        return semanticVal;
    }

    @Override
    public void yyerror(String msg) {
        // Imprime a linha, a coluna, o texto onde parou e a mensagem do Parser
        System.err.println("ERRO SINTATICO [Linha " + (yyline+1) + ", Coluna " + (yycolumn+1) + "]");
        System.err.println("Ultimo token lido: '" + yytext() + "'");
        System.err.println("Mensagem do Parser: " + msg);
    }
    
    private int token(int type) {
        semanticVal = yytext();
        return type;
    }

    private int token(int type, Object value) {
        semanticVal = value;
        return type;
    }
%}

SPACE   = [ \t\r\n\f\u00A0]+

LETRA   = [a-zA-Z_]
DIGITO  = [0-9]
ID      = {LETRA}({LETRA}|{DIGITO})*
NUM_INT = {DIGITO}+

%state COMMENT

%%

<YYINITIAL> {
  {SPACE}             { /* Ignora espacos */ }

  "//".* { /* Ignora comentario de linha */ }
  "/*"                { yybegin(COMMENT); }

  /* Palavras Chave */
  "program"           { return token(Parser.PROGRAM); }
  "class"             { return token(Parser.CLASS); }
  "if"                { return token(Parser.IF); }
  "else"              { return token(Parser.ELSE); }
  "while"             { return token(Parser.WHILE); }
  "return"            { return token(Parser.RETURN); }
  "print"             { return token(Parser.PRINT); }
  "read"              { return token(Parser.READ); }
  "new"               { return token(Parser.NEW); }
  "int"               { return token(Parser.INT); }
  "void"              { return token(Parser.VOID); }
  "bool"              { return token(Parser.BOOL); }
  "string"            { return token(Parser.STRING_TYPE); }
  "const"             { return token(Parser.CONST); }
  "true"              { return token(Parser.TRUE); }
  "false"             { return token(Parser.FALSE); }

  /* Operadores */
  "("                 { return token(Parser.LPAREN); }
  ")"                 { return token(Parser.RPAREN); }
  "{"                 { return token(Parser.LBRACE); }
  "}"                 { return token(Parser.RBRACE); }
  ";"                 { return token(Parser.SEMICOLON); }
  ","                 { return token(Parser.COMMA); }
  "="                 { return token(Parser.ASSIGN); }
  "+"                 { return token(Parser.PLUS); }
  "-"                 { return token(Parser.MINUS); }
  "*"                 { return token(Parser.TIMES); }
  "/"                 { return token(Parser.DIV); }
  ">"                 { return token(Parser.GT); }
  "<"                 { return token(Parser.LT); }
  "=="                { return token(Parser.EQ); }
  "<="                { return token(Parser.LTE); }
  ">="                { return token(Parser.GTE); }
  "!="                { return token(Parser.NEQ); }
  "!"                 { return token(Parser.NOT); }
  "&&"                { return token(Parser.AND); }
  "||"                { return token(Parser.OR); }

  /* Identificadores e Numeros */
  {ID}                { return token(Parser.ID, yytext()); }
  {NUM_INT}           { return token(Parser.NUM_INT, Integer.parseInt(yytext())); }
  
  .                   { 
                        System.err.println("ERRO LEXICO CRITICO:");
                        System.err.println("Caractere: '" + yytext() + "'");
                        System.err.println("Linha: " + (yyline+1) + ", Coluna: " + (yycolumn+1));
                        throw new Error("Erro lexico encontrado. Veja o log acima.");
                      }
}

<COMMENT> {
  "*/"                { yybegin(YYINITIAL); }
  [^]                 { /* Ignora tudo */ }
}