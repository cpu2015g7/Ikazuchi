.text
	li	$sp, 0x000fffff
	jal	main
	hlt
___END_LOOP___: # core
	j	___END_LOOP___
