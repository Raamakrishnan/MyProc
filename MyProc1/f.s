LDI r0, 0	;load r0 with 0
ldi r1, 1
ldi r2, 1
ldi r3, 100
sd r1, r3, 0
addi r3, r3, 1
sd r2, r3, 0
addi r3, r3, 1
ldi r5, 7
L: add r4, r1, r2
sd r4, r3, 0
addi r3, r3, 1
mov r1, r2
mov r2, r4
addi r5, r5, -1
bgez r5, L
halt