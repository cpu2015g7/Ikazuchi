.text
main:
	sw	$ra, 0($sp)
	jal	recv32
	move	$s0, $v0
	jal	recv32
	add	$a0, $s0, $v0
	jal	send32
end:
	lw	$ra, 0($sp)
	jr	$ra
