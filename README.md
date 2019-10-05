# reversed_brainfuck compiler

brainfuckマシンの配列を逆順にしたbrainfuckのコンパイラ

## using

- x64 asm (nasm)

## require

- nasm
- x64 linux

## build

``` build
git clone https://github.com/Lan-t/r-brainfuck-compiler
cd r-brainfuck-compiler-master
make
```

## usage

``` usage
./main < hoge.rbf > hoge.s
nasm -f elf64 -o hoge.o hoge.s
ld -o hoge hoge.o
```
