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

"("           { initWriterIfNeeded(); writer.write("<" + yytext() + ", l_paren>\n"); }
")"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", r_paren>\n"); }

"**"          { initWriterIfNeeded(); writer.write("<" + yytext() + ", pow>\n"); }
"//"          { initWriterIfNeeded(); writer.write("<" + yytext() + ", int_div>\n"); }

"+"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", plus>\n"); }
"-"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", minus>\n"); }
"*"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", mult>\n"); }
"/"           { initWriterIfNeeded(); writer.write("<" + yytext() + ", div>\n"); }

{NUM_FLOAT}   { initWriterIfNeeded(); writer.write("<" + yytext() + ", float>\n"); }
{NUM_INT}     { initWriterIfNeeded(); writer.write("<" + yytext() + ", int>\n"); }

<<EOF>>       { initWriterIfNeeded(); writer.write("<eof, eof>\n"); closeWriter(); return 0; }

.             { throw new Error("Símbolo inválido: '" + yytext() + "' na linha " + (yyline + 1) + ", coluna " + (yycolumn + 1)); }
