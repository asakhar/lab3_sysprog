  section .text
  global process
  global initialize
  extern rnd_state
process:
    push rbp
    mov rbp, rsp

    mov rbx, rdi
    add rbx, rsi
    dec rbx
    shr rsi, 1
loop:
    cmp rsi, 0
    jz end
    
    mov r11b, [rbx]
    mov r10b, [rdi]
    mov [rbx], r10b
    mov [rdi], r11b
    dec rbx
    dec rsi
    inc rdi
    jmp loop
end:
    pop rbp
    ret

initialize:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi
    mov r13, rsi
loop_start:
    cmp r13, 0
    jz loop_end
    call rnd
    mov [r12], al
    dec r13
    inc r12
    jmp loop_start
loop_end:
    pop r13
    pop r12
    pop rbp
    ret

rnd:
    push rbp
    mov rbp, rsp
    mov r8d, 7919
    mov r9d, 7907
    mov rax, [rel rnd_state]
    mul r8d
    shl rdx, 32
    or rax, rdx
    add rax, r9
    xor rdx, rdx
    mov r10, 6217
    div r10
    mov al, dl
    mov [rel rnd_state], rdx
    xor rdx, rdx
    mov r10, 90
    div r10
    add dl, 32
    mov al, dl
    pop rbp
    ret
