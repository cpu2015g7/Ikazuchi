.text
main:
	sw	$ra, 0($sp)
	jal	min_caml_recv32
	move	$s0, $v0
	jal	min_caml_recv32
	add	$a0, $s0, $v0
	jal	min_caml_send32
end:
	lw	$ra, 0($sp)
	jr	$ra
