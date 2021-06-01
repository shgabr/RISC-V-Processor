
#BLTU instruction
addi 	x1, x0, -4		#x1 = 1100 => -4
addi 	x2, x0, 4		#x2 = 0100 => 4
bltu	x2, x1, jump		#branch is taken		(forwarding)

add	x1, x1, x2			#x1 = 0000 => 0 	(flush instructions)
add	x2, x0, x1			#x2 = 0000 => 0			(forwarding)

jump:

sub x3, x2, x1			#x3 = 1000 => 8		(if branch taken)
				#   = 0000 => 0		(if branch not taken)
ecall
				
#FINAL VALUES
#	x1 	---> -4
#	x2	---> 4
#	x3	---> 8