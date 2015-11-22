.text
main:
	sw	$ra, 0($sp)
	li	$a0, 5
	jal	min_caml_print_int
	li	$a0, 0x0a # '/n'
	jal	min_caml_print_char
	li	$a0, 0x50 # 'P'
	jal	min_caml_print_char
	li	$a0, 0x61 # 'a'
	jal	min_caml_print_char
	li	$a0, 0x73 # 's'
	jal	min_caml_print_char
	li	$a0, 0x73 # 's'
	jal	min_caml_print_char
	li	$a0, 0x65 # 'e'
	jal	min_caml_print_char
	li	$a0, 0x64 # 'd'
	jal	min_caml_print_char
	li	$a0, 0x20 # ' '
	jal	min_caml_print_char
	li	$a0, 0x74 # 't'
	jal	min_caml_print_char
	li	$a0, 0x65 # 'e'
	jal	min_caml_print_char
	li	$a0, 0x73 # 's'
	jal	min_caml_print_char
	li	$a0, 0x74 # 't'
	jal	min_caml_print_char
	li	$a0, 0x0a # '\n'
	jal	min_caml_print_char
end:
	lw	$ra, 0($sp)
	jr	$ra
