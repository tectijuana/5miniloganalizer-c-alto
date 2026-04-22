.section .bss
buffer: .skip 1024

.section .data
count2: .word 0
count4: .word 0
count5: .word 0

msg2: .asciz "2xx: "
msg4: .asciz "4xx: "
msg5: .asciz "5xx: "
newline: .asciz "\n"

.section .text
.global _start

_start:

    // Leer stdin
    mov x0, #0
    ldr x1, =buffer
    mov x2, #1024
    mov x8, #63
    svc #0

    mov x19, x0
    ldr x1, =buffer

loop:
    cbz x19, imprimir

    ldrb w0, [x1], #1
    sub x19, x19, #1

    cmp w0, #'2'
    beq check_2

    cmp w0, #'4'
    beq check_4

    cmp w0, #'5'
    beq check_5

    b loop

check_2:
    ldrb w2, [x1]
    ldrb w3, [x1, #1]

    cmp w2, #'0'
    blt loop
    cmp w2, #'9'
    bgt loop

    cmp w3, #'0'
    blt loop
    cmp w3, #'9'
    bgt loop

    ldr x4, =count2
    ldr w5, [x4]
    add w5, w5, #1
    str w5, [x4]
    b loop

check_4:
    ldrb w2, [x1]
    ldrb w3, [x1, #1]

    cmp w2, #'0'
    blt loop
    cmp w2, #'9'
    bgt loop

    cmp w3, #'0'
    blt loop
    cmp w3, #'9'
    bgt loop

    ldr x4, =count4
    ldr w5, [x4]
    add w5, w5, #1
    str w5, [x4]
    b loop

check_5:
    ldrb w2, [x1]
    ldrb w3, [x1, #1]

    cmp w2, #'0'
    blt loop
    cmp w2, #'9'
    bgt loop

    cmp w3, #'0'
    blt loop
    cmp w3, #'9'
    bgt loop

    ldr x4, =count5
    ldr w5, [x4]
    add w5, w5, #1
    str w5, [x4]
    b loop

imprimir:

    // 2xx
    mov x0, #1
    ldr x1, =msg2
    mov x2, #5
    mov x8, #64
    svc #0

    ldr x1, =count2
    ldr w0, [x1]
    bl print_num

    // 4xx
    mov x0, #1
    ldr x1, =msg4
    mov x2, #5
    mov x8, #64
    svc #0

    ldr x1, =count4
    ldr w0, [x1]
    bl print_num

    // 5xx
    mov x0, #1
    ldr x1, =msg5
    mov x2, #5
    mov x8, #64
    svc #0

    ldr x1, =count5
    ldr w0, [x1]
    bl print_num

    // exit
    mov x8, #93
    mov x0, #0
    svc #0

print_num:
    add w0, w0, #'0'
    strb w0, [sp, #-1]!
    mov x0, #1
    mov x1, sp
    mov x2, #1
    mov x8, #64
    svc #0

    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    add sp, sp, #1
    ret
