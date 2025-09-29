import java.io.*;

public class TesteScanner {
    public static void main(String[] args) {
        try {
            FileReader reader = new FileReader("entrada.txt");
            CalculadoraLexer lexer = new CalculadoraLexer(reader);

            while (!lexer.yyatEOF()) {
                lexer.yylex(); // executa o scanner
            }

            lexer.closeWriter(); // fecha o arquivo de saída

            System.out.println("Tokens gravados em 'saida.txt' com sucesso!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}