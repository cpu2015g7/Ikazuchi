	addi $r5, $r0, 10
	addi $r4, $r0, 0
	addi $r1, $r0, 0
	addi $r2, $r0, 1
	nop
	beq $r4, $r5, 6
	addi $r4, $r4, 1
	nop
	add $r3, $r1, $r2
	nop
	beq $r0, $r0, -7
	addi $r1, $r2, 0
	addi $r2, $r3, 0
	rsb $r1
	beq $r0, $r0, -2
	nop
	nop
