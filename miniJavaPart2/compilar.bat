@echo off
cls
echo ==========================================
echo      COMPILADOR MINIJAVA - WINDOWS
echo ==========================================

REM --- 0. Limpeza ---
echo [0/4] Limpando arquivos antigos...
del /q Parser.java MiniJavaLexer.java ParserVal.java *.class 2>nul
if exist logs rmdir /s /q logs

REM --- 1. Gerar Parser ---
echo [1/4] Gerando Parser Java com Bison...
bison -o Parser.java miniJavaParser.y

REM --- 2. Gerar Scanner ---
echo [2/4] Gerando Scanner Java com JFlex...
call jflex miniJavaScanner.flex

REM --- 3. Compilar Java ---
echo [3/4] Compilando arquivos Java...

if not exist Parser.java (
    echo [ERRO FATAL] O Bison nao gerou o arquivo Parser.java.
    echo Verifique se o Bison esta instalado e no PATH.
    pause
    exit /b
)

REM Compila tudo o que for .java na pasta
javac *.java

if %errorlevel% neq 0 (
    echo.
    echo [ERRO DE COMPILACAO]
    echo Verifique as mensagens acima. Geralmente eh erro no .flex ou .y
    pause
    exit /b
)

REM --- 4. Executar Testes ---
echo [4/4] Executando testes...
echo.

if not exist logs mkdir logs

echo Teste 1: Ola Mundo
java Parser entradas\entrada1.txt > logs\saida1.txt 2>&1

echo Teste 2: Aritmetica
java Parser entradas\entrada2.txt > logs\saida2.txt 2>&1

echo Teste 3: Condicional
java Parser entradas\entrada3.txt > logs\saida3.txt 2>&1

echo Teste 4: Loops
java Parser entradas\entrada4.txt > logs\saida4.txt 2>&1

echo Teste 5: Complexo
java Parser entradas\entrada5.txt > logs\saida5.txt 2>&1

echo Teste 6: Erro Lexico (ESPERADO FALHAR)
java Parser entradas\entrada6.txt > logs\saida6.txt 2>&1

echo Teste 7: Erro Sintatico (ESPERADO FALHAR)
java Parser entradas\entrada7.txt > logs\saida7.txt 2>&1

echo.
echo ==========================================
echo SUCESSO! Verifique a pasta 'logs'.
echo ==========================================
pause