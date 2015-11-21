.text
main:
	jal	recv32
	move	$s0, $v0
	jal	recv32
	add	$a0, $s0, $v0
	jal	send32
	jr	$ra
