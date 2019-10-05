%macro sys_write 0
    mov rax, 1
    syscall
%endmacro

%macro sys_read 0
    mov rax, 0
    syscall
%endmacro


global put_register
global read_one
global print
global newline


section .rodata

    hex: db "0123456789abcdef"

section .data
    char_buf: db 0

section .text

print:
    mov rsi, rdi
    xor rdx, rdx
    .loop:
        mov rdi, rsi
        add rdi, rdx
        cmp byte [rdi], 0
        je .end
        inc rdx
        jmp .loop
    .end:
        mov rdi, 1
        sys_write
    ret

newline:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    mov byte [rbp-1], 10
    lea rsi, [rbp-1]
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall
    mov rsp, rbp
    pop rbp
    ret
    
put_register:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    xor rdx, rdx
.loop:
    mov rax, rdi
    and rax, 0x0f
    add rax, hex
    mov al, byte [rax]

    lea rcx, [rbp-1]
    sub rcx, rdx
    mov byte [rcx], al

    shr rdi, 4

    inc rdx
    cmp rdx, 16
    je .end
    jmp .loop
.end:
    mov rdi, 1
    lea rsi, [rbp-16]
    sys_write

    mov rsp, rbp
    pop rbp
    ret


read_one:
    mov rdi, 0
    mov rsi, char_buf
    mov rdx, 1
    sys_read

    cmp rax, 0
    jne .not_eof
        ret
    .not_eof:
    xor rax, rax
    mov al, [char_buf]
    
    ret
