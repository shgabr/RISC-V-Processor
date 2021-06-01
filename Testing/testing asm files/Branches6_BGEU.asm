
#BGEU instruction
addi 	x1, x0, -4		#x1 = 1100 => -4
addi 	x2, x0, 2		#x2 = 0010 => 2
addi	x3, x0, 0		#x3 = 0000 => 0
bgeu	x1, x2, jump		#branch is taken		(forwarding)

add	x1, x1, x2			#x1 = 1110 => -2 	(flush instructions)
add	x2, x0, x1			#x2 = 1110 => -2			(forwarding)

jump:

add 	x3, x1, x3		#x3 = 1100 => -4	(if branch taken)
				#   = 1110 => -2	(if branch not taken)
		
				#x3 = 1000 => -8	(if 2nd branch taken)
				
bgeu	x3, x1, jump		#branch taken if initial branch is taken			

add	x0, x0, x0

ecall
				
#FINAL VALUES
#	x1 	---> -4
#	x2	---> 2
#	x3	---> -8
