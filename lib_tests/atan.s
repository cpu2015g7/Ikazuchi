.text
main:
	addi	$sp, $sp, -10
	sw	$ra, 1($sp)
	li	$t0, -300
	li	$t1, 301
	li	$t2, 128
	i2f	$t2, $t2
	finv	$t3, $t2
loop:
	i2f	$a0, $t0
	fmul	$a0, $a0, $t3
	jal	min_caml_send32
	jal	min_caml_atan
	move	$a0, $v0
	jal	min_caml_send32
	addi	$t0, $t0, 1
	slt	$at, $t0, $t1
	bne	$at, $zero, loop
	nop
end:
	lw	$ra, 1($sp)
	addi	$sp, $sp, 10
	jr	$ra
