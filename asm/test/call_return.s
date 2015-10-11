jal func
	nop
	nop
	nop
	beq $r0, $r0, -3
	nop
	nop
	nop
	beq $r0, $r0, 100
func:
	addi $r1, $r0, 1
	nop
	nop
	jr $r31
	beq $r0, $r0, 100
