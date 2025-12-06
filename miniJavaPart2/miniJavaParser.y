%language "Java"

%define parser_class_name "Parser"

%define stype "Object"

%code {
}

%{
  import java.io.*;
%}

%code {
  /* Método Main para rodar o Parser + Scanner */
  public static void main(String args[]) throws IOException {
      if (args.length < 1) {
          System.err.println("Uso: java Parser <arquivo_entrada>");
          return;
      }
      
      try {
          MiniJavaLexer lexer = new MiniJavaLexer(new FileReader(args[0]));
          Parser parser = new Parser(lexer);
          
          if (parser.parse()) {
              System.out.println("Sucesso: Arquivo compilado sem erros sintaticos.");
          } else {
              System.err.println("Falha: Erro de compilacao encontrado.");
          }
      } catch (Exception e) {
          e.printStackTrace();
      }
  }
}

/* Definição dos Tokens */
/* ... O RESTO DO ARQUIVO CONTINUA IGUAL ABAIXO DAQUI ... */

/* Definição dos Tokens */
%token PROGRAM CLASS EXTENDS NEW
%token IF ELSE WHILE RETURN PRINT READ
%token INT VOID BOOL STRING_TYPE
%token TRUE FALSE NULL CONST
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token SEMICOLON COMMA DOT COLON
%token ASSIGN PLUSPLUS MINUSMINUS
%token PLUS MINUS TIMES DIV MOD
%token NOT AND OR
%token EQ NEQ LT GT LTE GTE
%token <String> ID
%token <Integer> NUM_INT
%token <Double> REAL_NUM
%token <String> STRING_LIT
%token GT GTE LTE NEQ NOT

%left OR
%left AND
%left EQ NEQ
%left LT GT LTE GTE
%left PLUS MINUS
%left TIMES DIV MOD
%right NOT

%nonassoc IF_SEM_ELSE
%nonassoc ELSE

%%

/* Gramática Simplificada do MiniJava */

program:
      PROGRAM ID LBRACE decl_list RBRACE { System.out.println("Regra: Programa reconhecido."); }
    ;

decl_list:
      decl_list decl
    | /* vazio */
    ;

decl:
      var_decl
    | method_decl
    | class_decl
    ;

var_decl:
      type ID SEMICOLON
    | type ID ASSIGN expr SEMICOLON
    | CONST type ID ASSIGN expr SEMICOLON
    ;

class_decl:
      CLASS ID LBRACE decl_list RBRACE
    | CLASS ID EXTENDS ID LBRACE decl_list RBRACE
    ;

method_decl:
      type ID LPAREN param_list RPAREN block
    | VOID ID LPAREN param_list RPAREN block
    ;

param_list:
      param_list COMMA type ID
    | type ID
    | /* vazio */
    ;

block:
      LBRACE stmt_list RBRACE
    ;

stmt_list:
      stmt_list stmt
    | /* vazio */
    ;

stmt:
      IF LPAREN expr RPAREN stmt %prec IF_SEM_ELSE
    | IF LPAREN expr RPAREN stmt ELSE stmt
    | WHILE LPAREN expr RPAREN stmt
    | PRINT LPAREN expr RPAREN SEMICOLON
    | READ LPAREN ID RPAREN SEMICOLON
    | ID ASSIGN expr SEMICOLON
    | RETURN expr SEMICOLON
    | RETURN SEMICOLON
    | block
    | SEMICOLON
    | var_decl 
    ;

expr:
      expr PLUS expr
    | expr MINUS expr
    | expr TIMES expr
    | expr DIV expr
    | expr AND expr
    | expr OR expr
    | expr EQ expr
    | expr NEQ expr  
    | expr LT expr
    | expr GT expr    
    | expr LTE expr  
    | expr GTE expr   
    | NOT expr       
    | ID
    | NUM_INT
    | REAL_NUM
    | STRING_LIT
    | TRUE
    | FALSE
    | NULL
    | LPAREN expr RPAREN
    | ID LPAREN arg_list RPAREN
    ;

arg_list:
      arg_list COMMA expr
    | expr
    | /* vazio */
    ;

type:
      INT | BOOL | STRING_TYPE | ID
    ;

%%

/* Código Java injetado na classe Parser para reportar erros */
/* O Bison espera que o Lexer implemente esta interface abaixo */