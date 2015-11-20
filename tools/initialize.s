.text
	ori	$sp, $zero, 65535
	sll	$sp, $sp, 6
	jal _min_caml_start
___END_LOOP___:
	j ___END_LOOP___
