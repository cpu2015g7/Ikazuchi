.data

.text
# IO

# ok (recv_send.s)
send32:
	srl	$s0, $a0, 24
	rsb	$s0
	srl	$s0, $a0, 16
	rsb	$s0
	srl	$s0, $a0, 8
	rsb	$s0
	rsb	$a0
	jr	$ra

# ok (recv_send.s)
recv32:
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	jr	$ra

# ok (print.s)
min_caml_print_char:
	rsb	$a0
	jr	$ra

# only work when 0 <= x <= 9 (print.s)
min_caml_print_int:
	addi	$a0, $a0, 0x30
	rsb	$a0
	jr	$ra
