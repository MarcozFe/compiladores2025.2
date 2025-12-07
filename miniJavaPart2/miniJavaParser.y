%language "Java"
%define parser_class_name "Parser"
%define stype "Object"

%code {
  /* Variável para armazenar a raiz da árvore */
  public AST.Node root = null;
}

%{
  /* Imports usando a sintaxe clássica compatível com todas as versões */
  import java.io.*;
  import java.util.*;
%}

%code {
  /* Método Main */
  public static void main(String args[]) throws IOException {
      if (args.length < 1) {
          System.err.println("Uso: java Parser <arquivo_entrada>");
          return;
      }
      
      try {
          MiniJavaLexer lexer = new MiniJavaLexer(new FileReader(args[0]));
          Parser parser = new Parser(lexer);
          
          if (parser.parse()) {
              System.out.println("=== ARVORE SINTATICA GERADA COM SUCESSO ===");
              if (parser.root != null) {
                  // Imprime a árvore começando sem indentação
                  parser.root.print("");
              }
          } else {
              System.err.println("Falha: Erro de compilacao encontrado.");
          }
      } catch (Exception e) {
          e.printStackTrace();
      }
  }
}

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

/* Precedência */
%left OR
%left AND
%left EQ NEQ
%left LT GT LTE GTE
%left PLUS MINUS
%left TIMES DIV MOD
%right NOT

%nonassoc IF_SEM_ELSE
%nonassoc ELSE

/* DEFINIÇÃO DE TIPOS
   Nota: Usamos 'List' e 'AST.Node' sem generics aninhados 
   para evitar erros de sintaxe no Bison 
*/
%type <AST.Node> program decl var_decl class_decl method_decl stmt block expr
%type <List> decl_list stmt_list param_list arg_list
%type <String> type

%%

/* Gramática */

program:
      PROGRAM ID LBRACE decl_list RBRACE 
      { 
        /* $$ é Object, fazemos cast para AST.Program */
        $$ = new AST.Program($2, (List<AST.Node>)$4); 
        root = (AST.Node)$$; 
      }
    ;

decl_list:
      decl_list decl 
      { 
         List<AST.Node> l = (List<AST.Node>)$1;
         l.add((AST.Node)$2); 
         $$ = l; 
      }
    | /* vazio */    
      { $$ = new ArrayList<AST.Node>(); }
    ;

decl:
      var_decl    { $$ = $1; }
    | method_decl { $$ = $1; }
    | class_decl  { $$ = $1; }
    ;

var_decl:
      type ID SEMICOLON 
      { $$ = new AST.VarDecl($1, $2, null); }
    | type ID ASSIGN expr SEMICOLON 
      { $$ = new AST.VarDecl($1, $2, (AST.Node)$4); }
    | CONST type ID ASSIGN expr SEMICOLON 
      { $$ = new AST.VarDecl("const " + $2, $3, (AST.Node)$5); }
    ;

class_decl:
      CLASS ID LBRACE decl_list RBRACE 
      { $$ = new AST.ClassDecl($2, null, (List<AST.Node>)$4); }
    | CLASS ID EXTENDS ID LBRACE decl_list RBRACE 
      { $$ = new AST.ClassDecl($2, $4, (List<AST.Node>)$6); }
    ;

method_decl:
      type ID LPAREN param_list RPAREN block 
      { 
        $$ = new AST.MethodDecl($1, $2, (List<AST.Node>)$4, ((AST.BlockStmt)$6).stmts); 
      }
    | VOID ID LPAREN param_list RPAREN block 
      { 
        $$ = new AST.MethodDecl("void", $2, (List<AST.Node>)$4, ((AST.BlockStmt)$6).stmts); 
      }
    ;

param_list:
      param_list COMMA type ID 
      { 
        List<AST.Node> l = (List<AST.Node>)$1;
        l.add(new AST.VarDecl($3, $4, null)); 
        $$ = l; 
      }
    | type ID                  
      { 
        List<AST.Node> l = new ArrayList<>(); 
        l.add(new AST.VarDecl($1, $2, null)); 
        $$ = l; 
      }
    | /* vazio */              
      { $$ = new ArrayList<AST.Node>(); }
    ;

block:
      LBRACE stmt_list RBRACE 
      { $$ = new AST.BlockStmt((List<AST.Node>)$2); }
    ;

stmt_list:
      stmt_list stmt 
      { 
        List<AST.Node> l = (List<AST.Node>)$1;
        l.add((AST.Node)$2); 
        $$ = l; 
      }
    | /* vazio */    
      { $$ = new ArrayList<AST.Node>(); }
    ;

stmt:
      IF LPAREN expr RPAREN stmt %prec IF_SEM_ELSE 
      { $$ = new AST.IfStmt((AST.Node)$3, (AST.Node)$5, null); }
    | IF LPAREN expr RPAREN stmt ELSE stmt         
      { $$ = new AST.IfStmt((AST.Node)$3, (AST.Node)$5, (AST.Node)$7); }
    | WHILE LPAREN expr RPAREN stmt                
      { $$ = new AST.WhileStmt((AST.Node)$3, (AST.Node)$5); }
    | PRINT LPAREN expr RPAREN SEMICOLON           
      { $$ = new AST.PrintStmt((AST.Node)$3); }
    | READ LPAREN ID RPAREN SEMICOLON              
      { $$ = new AST.PrintStmt(new AST.Literal("READ", $3)); }
    | ID ASSIGN expr SEMICOLON                     
      { $$ = new AST.AssignStmt($1, (AST.Node)$3); }
    | RETURN expr SEMICOLON                        
      { $$ = new AST.UnaryOp("return", (AST.Node)$2); }
    | RETURN SEMICOLON                             
      { $$ = new AST.UnaryOp("return", null); }
    | block                                        
      { $$ = $1; }
    | SEMICOLON                                    
      { $$ = null; }
    | var_decl                                     
      { $$ = $1; }
    ;

expr:
      expr PLUS expr   { $$ = new AST.BinOp((AST.Node)$1, "+", (AST.Node)$3); }
    | expr MINUS expr  { $$ = new AST.BinOp((AST.Node)$1, "-", (AST.Node)$3); }
    | expr TIMES expr  { $$ = new AST.BinOp((AST.Node)$1, "*", (AST.Node)$3); }
    | expr DIV expr    { $$ = new AST.BinOp((AST.Node)$1, "/", (AST.Node)$3); }
    | expr AND expr    { $$ = new AST.BinOp((AST.Node)$1, "&&", (AST.Node)$3); }
    | expr OR expr     { $$ = new AST.BinOp((AST.Node)$1, "||", (AST.Node)$3); }
    | expr EQ expr     { $$ = new AST.BinOp((AST.Node)$1, "==", (AST.Node)$3); }
    | expr NEQ expr    { $$ = new AST.BinOp((AST.Node)$1, "!=", (AST.Node)$3); }
    | expr LT expr     { $$ = new AST.BinOp((AST.Node)$1, "<", (AST.Node)$3); }
    | expr GT expr     { $$ = new AST.BinOp((AST.Node)$1, ">", (AST.Node)$3); }
    | expr LTE expr    { $$ = new AST.BinOp((AST.Node)$1, "<=", (AST.Node)$3); }
    | expr GTE expr    { $$ = new AST.BinOp((AST.Node)$1, ">=", (AST.Node)$3); }
    | NOT expr         { $$ = new AST.UnaryOp("!", (AST.Node)$2); }
    | ID               { $$ = new AST.IdExpr($1); }
    | NUM_INT          { $$ = new AST.Literal("int", $1); }
    | REAL_NUM         { $$ = new AST.Literal("float", $1); }
    | STRING_LIT       { $$ = new AST.Literal("string", $1); }
    | TRUE             { $$ = new AST.Literal("bool", "true"); }
    | FALSE            { $$ = new AST.Literal("bool", "false"); }
    | NULL             { $$ = new AST.Literal("null", "null"); }
    | LPAREN expr RPAREN { $$ = $2; }
    | ID LPAREN arg_list RPAREN { $$ = new AST.UnaryOp("call " + $1, null); }
    ;

arg_list:
      arg_list COMMA expr 
      { 
         List<AST.Node> l = (List<AST.Node>)$1;
         l.add((AST.Node)$3); 
         $$ = l; 
      }
    | expr                
      { 
         List<AST.Node> l = new ArrayList<>(); 
         l.add((AST.Node)$1); 
         $$ = l; 
      }
    | /* vazio */         
      { $$ = new ArrayList<AST.Node>(); }
    ;

type:
      INT { $$ = "int"; }
    | BOOL { $$ = "bool"; } 
    | STRING_TYPE { $$ = "string"; }
    | ID { $$ = $1; }
    ;

%%