
#BLT instruction
addi 	x1, x0, 2		#x1 = 0010 => 2
addi 	x2, x0, 4		#x2 = 0100 => 4
blt	x1, x2, jump		#branch is taken		(forwarding)

add	x1, x1, x2			#x1 = 0110 => 6 	(flush instructions)
add	x2, x0, x1			#x2 = 0110 => 6			(forwarding)

jump:

sub x3, x2, x1			#x3 = 0000 => 2		(if branch taken)
				#   = 0010 => 0		(if branch not taken)
ecall
				
#FINAL VALUES
#	x1 	---> 2
#	x2	---> 4
#	x3	---> 2