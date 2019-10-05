all: main


main: main.o lib.o
	ld -o main main.o lib.o

main.o:
	nasm -f elf64 -o main.o main.s

lib.o:
	nasm -f elf64 -o lib.o lib.s


test: main
	./main < test.rbf > test.s
	nasm -f elf64 -o test.o test.s
	ld -o test test.o
	./test


clean:
	-rm main.o lib.o test.s test.o test

clean_all:
	-rm main main.o lib.o test.s test.o test
