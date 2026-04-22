all:
	as -o main.o main.s
	ld -o analyzer main.o
