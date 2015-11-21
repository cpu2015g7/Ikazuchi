.data

.text
# IO

# not tested!!
send32:
	srl	$s0, $a0, 24
	rsb	$s0
	srl	$s0, $a0, 16
	rsb	$s0
	srl	$s0, $a0, 8
	rsb	$s0
	rsb	$a0
	jr	$ra

# not tested!!
recv32:
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	jr	$ra

min_caml_print_char:
	rsb	$a0
	jr	$ra
