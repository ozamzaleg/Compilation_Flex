build:
	flex tennis.lex
	gcc -o tennis lex.yy.c 

clean:
	rm -rf *.c *.h tennis

run:
	./tennis input.txt