all:
	as -o analyzer.o src/analyzer.s
	ld -o analyzer analyzer.o

run:
	cat data/logs_A.txt | ./analyzer

clean:
	rm -f analyzer analyzer.o
