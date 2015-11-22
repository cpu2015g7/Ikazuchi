.data
TWO:
	.long 0x40000000
HALF:
	.long 0x3f000000
.text
main:
	addi	$sp, $sp, -1
	sw	$ra, 1($sp)
# kernel_sin_test1
# sin 0.5 is nearly equaly to 0x3ef57744
	llw	$a0, (HALF)
	jal	min_caml_kernel_sin
	move	$a0, $v0
	jal	min_caml_send32

# kernel_cos_test1
# cos 0.5 is nearly equal to 0x3f60a940
	llw	$a0, (HALF)
	jal	min_caml_kernel_cos
	move	$a0, $v0
	jal	min_caml_send32

# reduction_test1
# reduction 10.0 is nearly equal to 0x406de04a
	li	$a0, 0x41200000
	jal	min_caml_reduction
	jal	min_caml_send32

# sin_test1
# sin 2.0
# expect: 0x3f68c7b7
	llw	$a0, (TWO)
	jal	min_caml_sin
	move	$a0, $v0
	jal	min_caml_send32

# cos_test1
# cos 2.0
# expect: bed51133
	llw	$a0, (TWO)
	jal	min_caml_cos
	move	$a0, $v0
	jal	min_caml_send32
end:
	lw	$ra, 1($sp)
	addi	$sp, $sp, 1
	jr	$ra
