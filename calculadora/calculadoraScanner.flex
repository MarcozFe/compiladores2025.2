%%

%public
%class CalculadoraLexer
%unicode
%line
%column
%standalone

%{
    // Writer para escrever os tokens no arquivo de saída
    private java.io.BufferedWriter writer = null;

    // Inicializa writer
    private void initWriterIfNeeded() {
        if (writer == null) {
            try {
                writer = new java.io.BufferedWriter(new java.io.FileWriter("saida.txt"));
            } catch (java.io.IOException e) {
                System.err.println("Erro ao abrir o arquivo de saída: " + e.getMessage());
                System.exit(1);
            }
        }
    }

    // Fecha o writer 
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

DIGITO    = [0-9]
NUM_INT   = {DIGITO}+
NUM_FLOAT = {DIGITO}+ "." {DIGITO}+
ESPACO    = [ \t\r\n]+

%%

{ESPACO}      { /* ignora espaços */ }

"("           { initWriterIfNeeded(); writer.write("<" + yytext() + ", I_PAREN>\n"); }
")"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", F_PAREN>\n"); }

"**"          { initWriterIfNeeded(); writer.write("<" + yytext() + ", POW>\n"); }
"//"          { initWriterIfNeeded(); writer.write("<" + yytext() + ", INT_DIV>\n"); }

"+"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", PLUS>\n"); }
"-"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", MINUS>\n"); }
"*"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", MULT>\n"); }
"/"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", DIV>\n"); }

{NUM_FLOAT}   { initWriterIfNeeded(); writer.write("<" + yytext() + ", FLOAT>\n"); }
{NUM_INT}     { initWriterIfNeeded(); writer.write("<" + yytext() + ", INT>\n"); }

.             { throw new Error("Símbolo inválido: '" + yytext() + "' na linha " + (yyline + 1) + ", coluna " + (yycolumn + 1)); }



