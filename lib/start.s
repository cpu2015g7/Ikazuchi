.text
	ori	$sp, $zero, 65535
	sll	$sp, $sp, 6
	jal main
___END_LOOP___:
	j ___END_LOOP___
