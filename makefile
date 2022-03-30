build:
	flex tennis.lex
	gcc -o tennis lex.yy.c 

clean:
	rm -rf *.c  tennis

run:
	./tennis input.txt
