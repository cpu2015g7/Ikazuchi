.data
_HALF:	# 0.5
	.long	0x3f000000
_ONE:   # 1.0
	.long	0x3f800000
_TWO:	# 2.0
	.long	0x40000000

_qPI:	# PI/4
	.long	0x3f490fdb
_hPI:	# PI/2
	.long	0x3fc90fdb
_PI:	# PI
	.long	0x40490fdb
_dPI:	# 2*PI
	.long	0x40c90fdb

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

# unit -> unit
min_caml_print_newline:
	li	$at, 0x0a
	rsb	$at
	jr	$ra

# ok (print.s)
# char -> unit
min_caml_print_byte:
min_caml_print_char:
	rsb	$a0
	jr	$ra

# unit -> char
min_caml_read_byte:
min_caml_read_char:
	rrb	$v0
	jr	$ra

# only work when 0 <= x <= 9 (print.s)
# int -> unit
min_caml_print_int:
	addi	$a0, $a0, 0x30
	rsb	$a0
	jr	$ra

# ok (read-int.s)
# unit -> int
min_caml_read_int:
	li	$s0, 0
	li	$s1, 0x2d # '-'
	li	$s2, 0x30 # '0'
	li	$s3, 0x3a # '9'+1
_read_int_loop1:
	rrb	$s0
	bne	$s0, $s1, _read_int_not_negative_flag
	slt	$at, $s0, $s2
	li	$s7, 1
	li	$v0, 0
	j	_read_int_loop2
_read_int_not_negative_flag:
	bne	$at, $zero, _read_int_loop1
	slt	$at, $s0, $s3
	beq	$at, $zero, _read_int_loop1
	li	$s7, 0
	subi	$v0, $s0, 0x30
_read_int_loop2:
	rrb	$s0
	slt	$at, $s0, $s2
	bne	$at, $zero, _read_int_end
	slt	$at, $s0, $s3
	beq	$at, $zero, _read_int_end
	subi	$s0, $s0, 0x30
	sll	$at, $v0, 3
	sll	$v0, $v0, 1
	add	$v0, $v0, $at
	add	$v0, $v0, $s0
	j	_read_int_loop2
_read_int_end:
	beq	$s7, $zero, _read_int_positive
	nop
	sub	$v0, $zero, $v0
_read_int_positive:
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
min_caml_abs_float:
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

# not tested
# float -> float
min_caml_floor:
	flr	$v0, $a0
	jr	$ra


# array

# not tested!!
# int -> 'a -> 'a array
min_caml_create_float_array:
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


# trig

# ok (trig.s)
# $a0 must be equal to return value
# float -> float
min_caml_reduction:
	llw	$s0, (_PI)
	llw	$s1, (_dPI)
	llw	$s2, (_TWO)
	llw	$s3, (_HALF)
_reduction_loop_mul:
	fmul	$s0, $s0, $s2
	fslt	$at, $a0, $s0
	beq	$at, $zero, _reduction_loop_mul
_reduction_loop_sub:
	fslt	$at, $a0, $s0
	bne	$at, $zero, _reduction_endif
	fneg	$at, $s0
	fadd	$a0, $a0, $at
_reduction_endif:
	fmul	$s0, $s0, $s3
	fslt	$at, $a0, $s1
	beq	$at, $zero, _reduction_loop_sub
	move	$v0, $a0
	jr	$ra

# ok (sin.s)
# ok (trig.s) (1ulp error)
# float -> float
min_caml_sin:
	srl	$s7, $a0, 31
	sll	$a0, $a0, 1
	srl	$a0, $a0, 1
	sw	$ra, 0($sp)
	jal	min_caml_reduction
	lw	$ra, 0($sp)
	llw	$s1, (_PI)
	fslt	$at, $a0, $s1
	bne	$at, $zero, _sin_lt_pi
	fneg	$at, $s1
	fadd	$a0, $a0, $at
	li	$at, 1
	sub	$s7, $at, $s7
_sin_lt_pi:
	sll	$s7, $s7, 31
	llw	$s2, (_hPI)
	fslt	$at, $a0, $s2
	bne	$at, $zero, _sin_lt_hpi
	fneg	$at, $a0
	fadd	$a0, $at, $s1
_sin_lt_hpi:
	llw	$s3, (_qPI)
	fslt	$at, $s3, $a0
	beq	$at, $zero, min_caml_kernel_sin
	fneg	$at, $a0
	fadd	$a0, $at, $s2
# ok (trig.s)
# float -> int -> float
min_caml_kernel_cos:
	fmul	$at, $a0, $a0   #  $at = x^2
	li	$s0, 0xbab38106 # -1/6!
	fmul	$v0, $s0, $at
	li	$s0, 0x3d2aa789 #  1/4!
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	li	$s0, 0xbf000000 # -1/2!
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	llw	$s0, (_ONE)     #  1/0!
	fadd	$v0, $v0, $s0
	add	$v0, $v0, $s7   #  SIGN
	jr	$ra

# ok (cos.s)
# ok (trig.s) (2ulp error)
# float -> float
min_caml_cos:
	li	$s7, 0
	sll	$a0, $a0, 1
	srl	$a0, $a0, 1
	sw	$ra, 0($sp)
	jal	min_caml_reduction
	lw	$ra, 0($sp)
	llw	$s1, (_PI)
	fslt	$at, $a0, $s1
	bne	$at, $zero, _cos_lt_pi
	fneg	$at, $s1
	fadd	$a0, $a0, $at
	li	$s7, 1
_cos_lt_pi:
	llw	$s2, (_hPI)
	fslt	$at, $a0, $s2
	bne	$at, $zero, _cos_lt_hpi
	fneg	$at, $a0
	fadd	$a0, $at, $s1
	li	$at, 1
	sub	$s7, $at, $s7
_cos_lt_hpi:
	sll	$s7, $s7, 31
	llw	$s3, (_qPI)
	fslt	$at, $s3, $a0
	beq	$at, $zero, min_caml_kernel_cos
	fneg	$at, $a0
	fadd	$a0, $at, $s2
# ok (trig.s)
# float -> int -> float
min_caml_kernel_sin:
	fmul	$at, $a0, $a0   #  $at = x^2
	li	$s0, 0xb94d64b6 # -1/7!
	fmul	$v0, $s0, $at
	li	$s0, 0x3c088666 #  1/5!
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	li	$s0, 0xbe2aaaac # -1/3!
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	llw	$s0, (_ONE)     #  1/1!
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $a0
	add	$v0, $v0, $s7   #  SIGN
	jr	$ra

# ok (atan.s)
# float -> float
min_caml_kernel_atan:
	fmul	$at, $a0, $a0
	li	$s0, 0x3d75e7c5 #  1/13
	fmul	$v0, $s0, $at
	li	$s0, 0xbdb7d66e # -1/11
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	li	$s0, 0x3de38e38 #  1/9
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	li	$s0, 0xbe124925 # -1/7
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	li	$s0, 0x3e4ccccd #  1/5
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	li	$s0, 0xbeaaaaaa # -1/3
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $at
	llw	$s0, (_ONE)     #  1/1
	fadd	$v0, $v0, $s0
	fmul	$v0, $v0, $a0
	jr	$ra

# ok (atan.s)
# float -> float
min_caml_atan:
	sll	$s6, $a0, 1
	srl	$s6, $s6, 1
	li	$s0, 0x3ee00000 # 0.4375
	fslt	$at, $s6, $s0
	bne	$at, $zero, min_caml_kernel_atan
	srl	$s7, $a0, 31
	sw	$ra, 0($sp)
	li	$s1, 0x401c0000 # 2.4375
	fslt	$at, $s6, $s1
	beq	$at, $zero, _atan_ge_24375
	sll	$s7, $s7, 31
	llw	$s2, (_ONE)
	fadd	$s4, $s6, $s2
	finv	$s4, $s4
	fneg	$s2, $s2
	fadd	$a0, $s6, $s2
	fmul	$a0, $a0, $s4
	jal	min_caml_kernel_atan
	llw	$s0, (_qPI)
	j	_min_caml_atan_end
_atan_ge_24375:
	finv	$a0, $s6
	jal	min_caml_kernel_atan
	fneg	$v0, $v0
	llw	$s0, (_hPI)
_min_caml_atan_end:
	lw	$ra, 0($sp)
	fadd	$v0, $v0, $s0
	add	$v0, $v0, $s7
	jr	$ra


# util

# ok (divu10.s)
# unsigned int -> unsigned int
min_caml_divu10:
	srl	$v0, $a0, 1
	srl	$at, $v0, 1
	add	$v0, $v0, $at
	srl	$at, $v0, 4
	add	$v0, $v0, $at
	srl	$at, $v0, 8
	add	$v0, $v0, $at
	srl	$at, $v0, 16
	add	$v0, $v0, $at
	srl	$v0, $v0, 3
	sll	$at, $v0, 2
	add	$s0, $v0, $at
	sll	$s0, $s0, 1
	sub	$s0, $a0, $s0
	li	$at, 9
	slt	$at, $at, $s0
	add	$v0, $v0, $at
	jr	$ra
