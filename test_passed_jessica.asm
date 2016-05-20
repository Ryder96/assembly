.data
chiamate: .asciiz "/run/media/andres/Dati/Work/Uni/Assembly/Stringhe/operazione.txt"
string: .space 150
fnf: .asciiz "some error"
.text
main:
    addi $sp,$sp,-8
    jal open
    sw $v0,0($sp)
    move $a0,$v0
    jal read
    jal print
    jal close

    li $v0,10
    syscall

open:
	li	$v0, 13	        #system call to open file
	la	$a0,chiamate    #output file name
	li	$a1, 0		      #open to read file, 0 is for reading
	li	$a2, 1          #writing mode is ignored, 1 is for writing
	syscall             #open a file(the file descriptor is returned in v0)
	move	$t6, $v0	    #Save File Descriptor
	blt	$v0, 0, err	#error
  jr $ra

# Read Data
#$a0 = address of input buffer
#$a1 = maximum number of characters to read
#For specified length n, string can be no longer than n-1.
#If less than that, adds newline to end. In either case, then pads with null byte If n = 1, input is ignored and null byte placed at buffer address.
# If n < 1, input is ignored and nothing is written to the buffer.

read:
	li	$v0, 14		# Read File Syscall
	#move	$a0, $t6	# Load File Descriptor
    la $a1, string
	li	$a2, 150	#Size buffer chiamate
	syscall
    jr $ra
# Print Data

print:
	li	$v0, 4		# Print String Syscall
	la	$a0, string	# Load Contents String
	syscall
    jr $ra
# Close File

close:
	li	$v0, 16		# Close File Syscall
	move	$a0, $t6	# Load File Descriptor
	syscall
  jr $ra
# Error

err:
	li	$v0, 4		# Print String Syscall
	la	$a0, fnf	# Load Error String
	syscall
    jr $ra
