.data
ZERO: # 0.0
	.long 0x00000000
NZERO: # -0.0
	.long 0x80000000
ONE: # 1.0
	.long 0x3f800000
NONE: # -1.0
	.long 0xbf800000
THREE: # 3.0
	.long 0x40400000
THREE_TWO: #1.5
	.long 0x3fc00000
NINE_FOUR: # 2.25
	.long 0x40100000
.text
main:
	sw	$ra, 0($sp)
# feq_test1
# 0.0 = 0.0
	llw	$a0, (ZERO)
	llw	$a1, (ZERO)
	jal	min_caml_fequal
	addi	$v0, $v0, 0x30
	rsb	$v0
# feq_test2
# 0.0 = -0.0
	llw	$a0, (ZERO)
	llw	$a1, (NZERO)
	jal	min_caml_fequal
	addi	$v0, $v0, 0x30
	rsb	$v0
# feq_test3
# 1.0 != -1.0
	llw	$a0, (ONE)
	llw	$a1, (NONE)
	jal	min_caml_fequal
	addi	$v0, $v0, 1
	addi	$v0, $v0, 0x30
	rsb	$v0
# feq_test4
# 1.0 = 1.0
	llw	$a0, (ONE)
	llw	$a1, (ONE)
	jal	min_caml_fequal
	addi	$v0, $v0, 0x30
	rsb	$v0
# feq_test5
# 1.0 != 1.5
	llw	$a0, (ONE)
	llw	$a1, (THREE_TWO)
	li	$a1, 0x3fc00000
	jal	min_caml_fequal
	addi	$v0, $v0, 1
	addi	$v0, $v0, 0x30
	rsb	$v0

# fle_test1
# -0.0 >= 0.0
	llw	$a0, (NZERO)
	llw	$a1, (ZERO)
	jal	min_caml_fless
	addi	$v0, $v0, 1
	addi	$v0, $v0, 0x30
	rsb	$v0
# fle_test2
# 1.0 < 1.5
	llw	$a0, (ONE)
	llw	$a1, (THREE_TWO)
	jal	min_caml_fless
	addi	$v0, $v0, 0x30
	rsb	$v0

# fp_test1
# 1.0 is positive
	llw	$a0, (ONE)
	jal	min_caml_fispos
	addi	$v0, $v0, 0x30
	rsb	$v0
# fp_test2
# 0.0 is NOT positive
	llw	$a0, (ZERO)
	jal	min_caml_fispos
	addi	$v0, $v0, 1
	addi	$v0, $v0, 0x30
	rsb	$v0
# fp_test3
# -1.0 is NOT positive
	llw	$a0, (NONE)
	jal	min_caml_fispos
	addi	$v0, $v0, 1
	addi	$v0, $v0, 0x30
	rsb	$v0

# fn_test1
# 1.0 is NOT negative
	llw	$a0, (ONE)
	jal	min_caml_fisneg
	addi	$v0, $v0, 1
	addi	$v0, $v0, 0x30
	rsb	$v0
# fn_test2
# 0.0 is NOT negative
	llw	$a0, (ZERO)
	jal	min_caml_fisneg
	addi	$v0, $v0, 1
	addi	$v0, $v0, 0x30
	rsb	$v0
# fn_test3
# -1.0 is negative
	llw	$a0, (NONE)
	jal	min_caml_fisneg
	addi	$v0, $v0, 0x30
	rsb	$v0

# fz_test1
# 0.0 is zero
	llw	$a0, (ZERO)
	jal	min_caml_fiszero
	addi	$v0, $v0, 0x30
	rsb	$v0
# fz_test2
# -0.0 is zero
	llw	$a0, (NZERO)
	jal	min_caml_fiszero
	addi	$v0, $v0, 0x30
	rsb	$v0
# fz_test3
# 1.0 is NOT zero
	llw	$a0, (ONE)
	jal	min_caml_fiszero
	addi	$v0, $v0, 1
	addi	$v0, $v0, 0x30
	rsb	$v0

# fhalf_test1
# 3.0 *. 0.5 = 1.5
	llw	$a0, (THREE)
	jal	min_caml_fhalf
	llw	$s0, (THREE_TWO)
	bne	$v0, $s0, FH_1_NG
	li	$v0, 0
	addi	$v0, $v0, 1
FH_1_NG:
	addi	$v0, $v0, 0x30
	rsb	$v0

# fsqr_test1
# 1.5 *. 1.5 = 2.25
	llw	$a0, (THREE_TWO)
	jal	min_caml_fsqr
	llw	$s0, (NINE_FOUR)
	bne	$v0, $s0, FS_1_NG
	li	$v0, 0
	addi	$v0, $v0, 1
FS_1_NG:
	addi	$v0, $v0, 0x30
	rsb	$v0

# fabs_test1
# fabs(1.0) = 1.0
	llw	$a0, (ONE)
	jal	min_caml_fabs
	llw	$s0, (ONE)
	bne	$v0, $s0, FA_1_NG
	li	$v0, 0
	addi	$v0, $v0, 1
FA_1_NG:
	addi	$v0, $v0, 0x30
	rsb	$v0
# fabs_test2
# fabs(-1.0) = 1.0
	llw	$a0, (NONE)
	jal	min_caml_fabs
	llw	$s0, (ONE)
	bne	$v0, $s0, FA_2_NG
	li	$v0, 0
	addi	$v0, $v0, 1
FA_2_NG:
	addi	$v0, $v0, 0x30
	rsb	$v0

# fneg_test1
# fneg(1.0) = -1.0
	llw	$a0, (ONE)
	jal	min_caml_fneg
	llw	$s0, (NONE)
	bne	$v0, $s0, FN_1_NG
	li	$v0, 0
	addi	$v0, $v0, 1
FN_1_NG:
	addi	$v0, $v0, 0x30
	rsb	$v0

# fsqrt_test1
# fsqrt(2.25) = 1.5
	llw	$a0, (NINE_FOUR)
	jal	min_caml_sqrt
	llw	$s0, (THREE_TWO)
	bne	$v0, $s0, FQ_1_NG
	li	$v0, 0
	addi	$v0, $v0, 1
FQ_1_NG:
	addi	$v0, $v0, 0x30
	rsb	$v0

# f2i_test1
# f2i(2.25) = 2
	llw	$a0, (NINE_FOUR)
	jal	min_caml_int_of_float
	li	$s0, 2
	bne	$v0, $s0, F2I_1_NG
	li	$v0, 0
	addi	$v0, $v0, 1
F2I_1_NG:
	addi	$v0, $v0, 0x30
	rsb	$v0

# i2f_test1
# i2f(1) = 1.0
	li	$a0, 1
	jal	min_caml_float_of_int
	llw	$s0, (ONE)
	bne	$v0, $s0, I2F_1_NG
	li	$v0, 0
	addi	$v0, $v0, 1
I2F_1_NG:
	addi	$v0, $v0, 0x30
	rsb	$v0

end:
	li	$v0, 0x0a
	rsb	$v0
	lw	$ra, 0($sp)
	jr	$ra
