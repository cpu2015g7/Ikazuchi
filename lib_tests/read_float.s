.text
main:
	sw	$ra, 0($sp)
	addi	$sp, $sp, -1
read_float_test1:
	li	$t1, 0
	li	$t2, 3
read_float_test1_start:
	beq	$t1, $t2, read_float_test1_end
	addi	$t1, $t1, 1
	jal	min_caml_read_float
	move	$a0, $v0
	jal	min_caml_send32
	j read_float_test1_start
read_float_test1_end:
end:
	addi	$sp, $sp, 1
	lw	$ra, 0($sp)
	jr	$ra
