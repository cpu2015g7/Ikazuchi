.text
main:
	sw	$ra, 0($sp)
	addi	$sp, $sp, -1
divu10_test1:
	li	$t0, 0
	li	$t1, 1000
divu10_test1_loop:
	beq	$t0, $t1, divu10_test1_end
	move	$a0, $t0
	jal	min_caml_divu10
	move	$a0, $v0
	jal	min_caml_send32
	addi	$t0, $t0, 1
	j	divu10_test1_loop
divu10_test1_end:
end:
	addi	$sp, $sp, 1
	lw	$ra, 0($sp)
	jr	$ra
