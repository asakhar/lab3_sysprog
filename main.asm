  section	.text
  global	process
  global	initialize
  global	random_device
  global	rnd_state
process:
    push	rbp
    mov	rbp,	rsp

    mov	rbx,	rdi
    add	rbx,	rsi
    dec	rbx
    shr	rsi,	1
loop:
    cmp	rsi,	0
    jz	end
    
    mov	r11b,	[rbx]
    mov	r10b,	[rdi]
    mov	[rbx],	r10b
    mov	[rdi],	r11b
    dec	rbx
    dec	rsi
    inc	rdi
    jmp	loop
end:
    pop	rbp
    ret

initialize:
    push	rbp
    mov	rbp,	rsp
    push	r12
    push	r13
    mov	r12,	rdi
    mov	r13,	rsi
loop_start:
    cmp	r13,	0
    jz	loop_end
    call	rnd
    mov	rdi,	rax
    call	cvt2char
    mov	[r12],	al
    dec	r13
    inc	r12
    jmp	loop_start
loop_end:
    pop	r13
    pop	r12
    pop	rbp
    ret
    
    %define	NUM_SYMBS	90
cvt2char:
    push	rbp
    mov	rbp,	rsp
    mov	rax,	rdi
    xor	rdx,	rdx
    mov	r10,	NUM_SYMBS
    div	r10
    add	dl,	' '
    mov	al,	dl
    pop	rbp
    ret

    %define	A	7919
    %define	B	7907
    %define	MODULO	6217

rnd:
    push	rbp
    mov	rbp,	rsp
    mov	r8d,	A
    mov	r9d,	B
    mov	rax,	[rel rnd_state]
    mul	r8d
    shl	rdx,	32
    or	rax,	rdx
    add	rax,	r9
    xor	rdx,	rdx
    mov	r10,	MODULO
    div	r10
    mov	[rel rnd_state],	rdx
    mov	al,	dl
    pop	rbp
    ret

%define	SYSCALL_OPEN	0x02
%define	SYSCALL_READ	0x00
%define	SYSCALL_CLOSE	0x03
%define	O_RDONLY	0x00

random_device:
    push	rbp
    mov	rbp,	rsp
    push	rax
    mov	rax,	SYSCALL_OPEN
    lea	rdi,	[rel random_device_fn]
    mov	rsi,	0
    mov	rdx,	O_RDONLY
    syscall
    push	rax
    mov	rdi,	rax
    mov	rax,	SYSCALL_READ
    mov	rsi,	rbp
    sub	rsi,	8
    mov	rdx,	8
    syscall
    pop	rdi
    mov	rax,	SYSCALL_CLOSE
    syscall
    pop	rax
    pop	rbp
    ret
    
  section	.rodata
random_device_fn	db	"/dev/random",	0
  section	.data
rnd_state	dq	23