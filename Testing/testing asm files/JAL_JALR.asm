
#JAL isntruction

addi 	x1, x0, 4
jal 	x2, jump

add	x0, x0, x0
add	x1, x1, x1	

ecall 

add	x0, x0, x0

jump:

add 	x1, x1, x1
jalr 	x3, x2, 4

add	x0, x0, x0


# FINAL VALUES
#	x1	---> 16
#	x2	---> 12
#	x3	---> 36
