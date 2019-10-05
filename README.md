# reversed_brainfuck compiler

brainfuckマシンの配列を逆順にしたr-brainfuckコンパイラ

左に伸びる配列でポインタは右端を指す

``` overview
                    ptr
                     v
| ... | |a|r|r|a|y| | |
-----------------------
<- 0x000       0xfff ->
```

文字列の印字は変わらず左から右の順になるので注意

右端より右にポインタが動いた際の動作は未定義

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
