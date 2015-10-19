	addi $r9, $r0, 512
	addi $r1, $r0, 10
	addi $r29, $r0, 1
	jal fib
	rsb $r1
	beq $r0, $r0, -1
	nop
	nop
fib:
	addi $r9, $r9, -24
	slt $r3, $r29, $r1
	sw $r31, 0($r9)
	sw $r1, 4($r9)
	beq $r3, $r0, 23
	nop
	addi $r1, $r1, -1
	nop
	nop
	nop
	nop
	jal fib
	nop
	sw $r1, 8($r9)
	lw $r1, 4($r9)
	nop
	nop
	nop
	nop
	addi $r1, $r1, -2
	jal fib
	lw $r2, 8($r9)
	lw $r31, 0($r9)
	nop
	nop
	nop
	add $r1, $r1, $r2
	nop
	nop
	nop
	nop
	addi $r9, $r9, 24
	jr $r31
