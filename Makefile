#
# UFRGS - Compiladores B - Marcelo Johann - 2009/2 - Etapa 1
#
# Makefile for single compiler call
# All source files must be included from code embedded in scanner.l
# In our case, you probably need #include "hash.c" at the beginning
# and #include "main.c" in the last part of the scanner.l
#

etapa2: main.o hash.o lex.yy.o y.tab.o
	gcc main.o hash.o lex.yy.o  y.tab.o -o etapa2

main.o: main.c
	gcc -c main.c

hash.o: hash.c
	gcc -c hash.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c: scanner.l
	lex --header-file=lex.yy.h scanner.l

y.tab.c: parser.y
	yacc -d parser.y

y.tab.o: y.tab.c
	gcc -c y.tab.c

clean:
	rm etapa2 lex.yy.c lex.yy.h y.tab.c y.tab.h *.o




