.data
_HALF:	# 0.5
	.long	0x3f000000

.text
# IO

# ok (recv_send.s)
# 'a -> unit
min_caml_send32:
	srl	$s0, $a0, 24
	rsb	$s0
	srl	$s0, $a0, 16
	rsb	$s0
	srl	$s0, $a0, 8
	rsb	$s0
	rsb	$a0
	jr	$ra

# ok (recv_send.s)
# unit -> 'a
min_caml_recv32:
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	sll	$v0, $v0, 8
	rrb	$v0
	jr	$ra

# ok (print.s)
# char -> unit
min_caml_print_char:
	rsb	$a0
	jr	$ra

# only work when 0 <= x <= 9 (print.s)
# int -> unit
min_caml_print_int:
	addi	$a0, $a0, 0x30
	rsb	$a0
	jr	$ra


# float

# ok (float.s)
# float -> float -> bool
min_caml_fequal:
	fslt	$s0, $a0, $a1
	fslt	$s1, $a1, $a0
	add	$s0, $s0, $s1
	addi	$v0, $zero, 1
	sub	$v0, $v0, $s0
	jr	$ra

# ok (float.s)
# float -> float -> bool
min_caml_fless:
	fslt	$v0, $a0, $a1
	jr	$ra

# ok (float.s)
# float -> bool
min_caml_fispos:
	fslt	$v0, $zero, $a0
	jr	$ra

# ok (float.s)
# float -> bool
min_caml_fisneg:
	fslt	$v0, $a0, $zero
	jr	$ra

# ok (float.s)
# float -> bool
min_caml_fiszero:
	sll	$a0, $a0, 1
	beq	$a0, $zero, _fiszero_true
	move	$v0, $zero
	jr	$ra
_fiszero_true:
	addi	$v0, $zero, 1
	jr	$ra

# ok (float.s)
# float -> float
min_caml_fhalf:
	llw	$s0, (_HALF)
	fmul	$v0, $a0, $s0
	jr	$ra

# ok (float.s)
# float -> float
min_caml_fsqr:
	fmul	$v0, $a0, $a0
	jr	$ra

# ok (float.s)
# float -> float
min_caml_fabs:
	sll	$v0, $a0, 1
	srl	$v0, $v0, 1
	jr	$ra

# ok (float.s)
# float -> float
min_caml_fneg:
	fneg	$v0, $a0
	jr	$ra

# ok (float.s)
# float -> float
min_caml_sqrt:
	fsqrt	$v0, $a0
	jr	$ra

# ok (float.s)
# float -> int
min_caml_int_of_float:
	f2i	$v0, $a0
	jr	$ra

# ok (float.s)
# int -> float
min_caml_float_of_int:
	i2f	$v0, $a0
	jr	$ra

# not implemented
# float -> float
min_caml_floor:
#	flr	$v0, $a0
	jr	$ra


# array

# not tested!!
# int -> 'a -> 'a array
min_caml_create_array:
	move	$s0, $gp
	move	$v0, $gp
	add	$gp, $gp, $a0
_create_array_loop:
	beq	$s0, $gp, _create_array_end
	addi	$s0, $s0, 1
	sw	$a1, -1($s0)
	j	_create_array_loop
_create_array_end:
	jr	$ra
