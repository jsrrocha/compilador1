#
# UFRGS - Compiladores B - Marcelo Johann - 2009/2 - Etapa 1
#
# Makefile for single compiler call
# All source files must be included from code embedded in scanner.l
# In our case, you probably need #include "hash.c" at the beginning
# and #include "main.c" in the last part of the scanner.l
#

etapa3: main.o hash.o ast.o decompiler.o lex.yy.o y.tab.o
	gcc main.o hash.o ast.o decompiler.o lex.yy.o  y.tab.o -o etapa3

main.o: main.c
	gcc -c main.c

hash.o: hash.c
	gcc -c hash.c

ast.o: ast.c
	gcc -c ast.c
decompiler.o: decompiler.c
	gcc -c decompiler.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c: scanner.l
	lex --header-file=lex.yy.h scanner.l

y.tab.c: parser.y
	yacc -d parser.y

y.tab.o: y.tab.c
	gcc -c y.tab.c

clean:
	rm etapa3 lex.yy.c lex.yy.h *.o




