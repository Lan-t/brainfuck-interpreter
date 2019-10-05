section .data

error_mesage: db "error. exiting..."

_start_text: db \
"section .data", 10, \
"    buf: db 0", 10, \
"section .text", 10, \
"global _start", 10, \
"o_put:", 10, \
"    mov rsi, rdi", 10, \
"    xor rdx, rdx", 10, \
"    .loop:", 10, \
"        mov rdi, rsi", 10, \
"        add rdi, rdx", 10, \
"        cmp byte [rdi], 0", 10, \
"        je .end", 10, \
"        inc rdx", 10, \
"        jmp .loop", 10, \
"    .end:", 10, \
"        mov rdi, 1", 10, \
"        mov rax, 1", 10, \
"        syscall", 10, \
"    ret", 10, \
"o_read:", 10, \
"    mov rdi, 0", 10, \
"    mov rsi, buf", 10, \
"    mov rdx, 1", 10, \
"    mov rax, 0", 10, \
"    syscall", 10, \
"    mov al, [buf]", 10, \
"    ret", 10, \
"_start:", 10, \
"    push rbp", 10, \
"    mov rbp, rsp", 10, \
"    push qword 0", 10, \
"    push qword 0", 10, \
"    lea rdi, [rbp-9]", 10, 0

_end_text: db \
"    mov rax, 60", 10, \
"    mov rdi, 0", 10, \
"    syscall", 10, 0


o_add_text: db \
"    add byte [rdi], 1", 10, 0

o_sub_text: db \
"    sub byte [rdi], 1", 10, 0

o_padd_text: db \
"    add rdi, 1", 10, 0

o_psub_text: db \
"    sub rdi, 1", 10, 0

o_put_text: db \
"    push rdi", 10, \
"    call o_put", 10, \
"    pop rdi", 10, 0

o_read_text: db \
"    push rdi", 10, \
"    call o_read", 10, \
"    pop rdi", 10, \
"    mov byte [rdi], al", 10, 0

_o_loop_s_text_1: db ".loop_s", 0
_o_loop_s_text_2: db ":", 10, \
"    mov al, [rdi]", 10, \
"    cmp al, 0", 10, \
"    je .loop_e", 0
_o_loop_s_text_3: db 10, 0

_o_loop_e_text_1: db \
"    jmp .loop_s", 0
_o_loop_e_text_2: db 10, \
".loop_e", 0
_o_loop_e_text_3: db ":", 10, 0

o_push_0_text: db "push qword 0", 10, 0

section .text

extern read_one
extern print
extern put_register

compile:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rdi, _start_text
    call print

    mov rdi, 0 ; put label num
    mov rbx, 8
    mov rcx, 1

    .loop:
        push rdi
        push rcx
        call read_one

        cmp rax, 43 ; +
        je .o_add
        cmp rax, 45 ; -
        je .o_sub
        cmp rax, 62 ; >
        je .o_padd
        cmp rax, 60 ; <
        je .o_psub
        cmp rax, 46 ; .
        je .o_put
        cmp rax, 44 ; ,
        je .o_read
        cmp rax, 91 ; [
        je .o_loop_s
        cmp rax, 93 ; ]
        je .o_loop_e

        cmp rax, 0
        je .loop_end

        pop rcx
        pop rdi
        jmp .loop

        .o_add:
            mov rdi, o_add_text
            call print
            pop rcx
            pop rdi
            jmp .end
        
        .o_sub:
            mov rdi, o_sub_text
            call print
            pop rcx
            pop rdi
            jmp .end
        
        .o_padd:
            mov rdi, o_padd_text
            call print
            pop rcx
            pop rdi
            sub rcx, 1
            jmp .end
        
        .o_psub:
            mov rdi, o_psub_text
            call print
            pop rcx
            pop rdi
            add rcx, 1
            jmp .end

        .o_put:
            mov rdi, o_put_text
            call print
            pop rcx
            pop rdi
            jmp .end
        
        .o_read:
            mov rdi, o_read_text
            call print
            pop rcx
            pop rdi
            jmp .end
        
        .o_loop_s:
            mov rdi, _o_loop_s_text_1
            call print
            mov rdi, [rsp+8] ; [rsp] = rcx
            call put_register
            mov rdi, _o_loop_s_text_2
            call print
            mov rdi, [rsp+8]
            call put_register
            mov rdi, _o_loop_s_text_3
            call print
            mov rdi, [rsp+8]
            add rdi, 1
            pop rcx ; rdiはそのまま
            jmp .end
        
        .o_loop_e:
            pop rcx
            pop rax
            pop rdi
            push rax
            push rcx
            push rdi
            mov rdi, _o_loop_e_text_1
            call print
            mov rdi, [rsp]
            call put_register
            mov rdi, _o_loop_e_text_2
            call print
            pop rdi
            call put_register
            mov rdi, _o_loop_e_text_3
            call print
            pop rcx
            pop rdi
            jmp .end
        
        .end:
            cmp rcx, rbx
            je .push_0
            jmp .loop
            .push_0:
                push rdi
                push rcx
                mov rdi, o_push_0_text
                call print
                pop rcx
                pop rdi
                add rbx, 8
            jmp .loop
    
    .loop_end:
        mov rdi, _end_text
        call print

        mov rsp, rbp
        pop rbp
        ret


global _start
_start:
    call compile
    mov rax, 60
    mov rdi, 0
    syscall
        
