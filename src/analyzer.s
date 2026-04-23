.section .data
msg2: .ascii "2xx: "
len2 = . - msg2

msg4: .ascii "4xx: "
len4 = . - msg4

msg5: .ascii "5xx: "
len5 = . - msg5

newline: .ascii "\n"

.section .bss
buffer: .skip 1024
outbuf: .skip 32

.section .text
.global _start

_start:
    mov x19, #0   // 2xx count
    mov x20, #0   // 4xx count
    mov x21, #0   // 5xx count

read:
    mov x0, #0              // stdin
    ldr x1, =buffer
    mov x2, #1024
    mov x8, #63             // sys_read
    svc #0

    cmp x0, #0
    ble print_results

    mov x3, #0
    mov x4, #0

parse:
    cmp x3, x0
    bge read

    ldrb w5, [x1, x3]

    cmp w5, #10
    beq process_number

    sub w5, w5, #'0'
    mov x6, #10
    mul x4, x4, x6
    add x4, x4, x5

    add x3, x3, #1
    b parse

process_number:
    // clasificar HTTP
    cmp x4, #200
    blt reset
    cmp x4, #299
    ble inc2

    cmp x4, #400
    blt check5
    cmp x4, #499
    ble inc4

check5:
    cmp x4, #500
    blt reset
    cmp x4, #599
    ble inc5

reset:
    mov x4, #0
    add x3, x3, #1
    b parse

inc2:
    add x19, x19, #1
    b reset

inc4:
    add x20, x20, #1
    b reset

inc5:
    add x21, x21, #1
    b reset

// =========================
// PRINT FUNCTION (WRITE)
// =========================

print_results:

    // print "2xx: "
    mov x0, #1
    ldr x1, =msg2
    mov x2, #5
    mov x8, #64
    svc #0

    // print number 2xx
    mov x0, x19
    bl print_num

    // newline
    bl print_nl

    // print "4xx"
    mov x0, #1
    ldr x1, =msg4
    mov x2, #5
    mov x8, #64
    svc #0

    mov x0, x20
    bl print_num
    bl print_nl

    // print "5xx"
    mov x0, #1
    ldr x1, =msg5
    mov x2, #5
    mov x8, #64
    svc #0

    mov x0, x21
    bl print_num
    bl print_nl

exit:
    mov x0, #0
    mov x8, #93
    svc #0

// =========================
// PRINT NUMBER (x0)
// =========================

print_num:
    mov x1, #10
    ldr x2, =outbuf
    add x2, x2, #31
    mov w3, #0

1:
    udiv x4, x0, x1
    msub x5, x4, x1, x0
    add x5, x5, #'0'
    strb w5, [x2], #-1
    mov x0, x4
    add w3, w3, #1
    cbnz x0, 1b

    add x2, x2, #1

    mov x0, #1
    mov x8, #64
    mov x1, x2
    mov x2, x3
    svc #0

    ret

print_nl:
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0
    ret
