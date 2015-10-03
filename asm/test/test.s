START:
add $t0, $t1, $t2
addi $t0, $t1, 30
sw $t0, 4($t1)
lw $t0, -8($t1)
slt $t0, $t1, $t2
beq $t0, $t1, 3
sll $t0, $t1, 1
srl $t0, $t1, 2
jal START
rsb $t0