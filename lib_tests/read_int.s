.text
main:
	sw	$ra, 0($sp)
	addi	$sp, $sp, -1
read_int_test1:
	jal	min_caml_read_int
	beq	$v0, $zero, end
	move	$a0, $v0
	jal	min_caml_send32
	j	read_int_test1
end:
	addi	$sp, $sp, 1
	lw	$ra, 0($sp)
	jr	$ra
