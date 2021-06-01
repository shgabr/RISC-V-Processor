
#BGE instruction
addi 	x1, x0, 2		#x1 = 0010 => 2
addi 	x2, x0, 4		#x2 = 0100 => 4
addi	x3, x0, 4		#x3 = 0100 => 4
bge	x2, x1, jump		#branch is taken		(forwarding)

add	x1, x1, x2			#x1 = 0110 => 6 	(flush instructions)
add	x2, x0, x1			#x2 = 0110 => 6			(forwarding)

jump:

sub 	x3, x3, x1		#x3 = 0010 => 2		(if branch taken)
				#   = 1110 => -2	(if branch not taken)
		
				#x3 = 0000 => 0		(if 2nd branch taken)
				
bge	x3, x1, jump		#branch taken if initial branch is taken			

add	x0, x0, x0

ecall
				
#FINAL VALUES
#	x1 	---> 2
#	x2	---> 4
#	x3	---> 0
