	addi $r2, $r0, 10
	addi $r1, $r1, 1
	nop
	nop
	nop
	beq $r1, $r2, 2
	nop
	nop
	beq $r0, $r0, -9
	nop
	nop
	nop
	addi $r1, $r1, 0
	nop
	beq $r0, $r0, -4
	nop
	nop
	nop
	beq $r0, $r0, -20 # not expected to be executed!!!
