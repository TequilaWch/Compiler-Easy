.PHONY: all clean main run test s
all: run
main.tab.cc: main.y
	bison -o main.tab.cc -v main.y
lex.yy.cc: main.l
	flex -o lex.yy.cc main.l
main:
	g++ $(shell ls *.cpp *.cc) -o main.out
run: lex.yy.cc main.tab.cc main

clean:
	rm -f *.output *.yy.* *.tab.* *.out test/*.s test/*.out
test:
	./main.out <test/test.c >test/test.s
	gcc test/test.s -m32 -o test/test.out
	qemu-i386 test/test.out
s:
	gcc test/test.s -m32 -o test/test.out
	qemu-i386 test/test.out
