

addi x1, x0, 2

fence 1, 1

add x1, x1, x1

ebreak 

add x1, x1, x1

ecall

addi x2, x0, 4

# FINAL VALUES
#	x1	---> 8
#	x2	---> 0