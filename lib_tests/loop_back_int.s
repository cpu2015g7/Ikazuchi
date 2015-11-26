.text
main:
	sw	$ra, 0($sp)
	addi	$sp, $sp, -1
loop_back_int_test1:
	jal	min_caml_read_int
	beq	$v0, $zero, loop_back_int_test1_end
	move	$a0, $v0
	jal	min_caml_print_int
	jal	min_caml_print_newline
	j	loop_back_int_test1
loop_back_int_test1_end:
	j	end

end:
	addi	$sp, $sp, 1
	lw	$ra, 0($sp)
	jr	$ra
