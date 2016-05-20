#Assembly program that read a string fromi a file and does the operations written on it

# The first part of the program was written by Jessica Elezi and read the string from a file
# Called operazione.txt

.data
file: .asciiz "D:\Work\Uni\Assembly\Stringhe\operazione.txt"
string: .space 150
error_message: .asciiz "Some error"
main_bytes: .byte 'm', 't' , 'l', 'v' #soMma, soTtrazione, moLtiplicazione, diVisione
jump_next: .word 6, 12, 16, 10
stack: .word 10000
sum_string: .ascii "somma: "
sub_string: .ascii "sottrazione: "
mul_string: .ascii "moltiplicazione: "
div_string: .ascii "divisione: "

.text

main:
    la $s0,stack
    li $s1,0
    sw $t1, ($s0)
    addi $s0,$s0,4
    addi $sp,$sp,-8
    sw $ra, 8($sp)
    jal readString
    move $a0,$zero
    jal getThirdChar
    sb $v0,0($sp)
    move $a0,$v0
    jal recognizeOperation
    move $a0,$v0
    jal nextNumber
    lb $t1, 0($sp)
    sb $t1,($s0)
    addi $s1,$s1,1
    jal endArray
    move $s0,$v0
    addi $s0,$s0,-4
    lb $t1, ($s0)
    addi $s0,$s0,-4
    lw $a0, ($s0)
    addi $s0,$s0,-4
    lw $a1, ($s0)
    la $t2, main_bytes
    lb $t3, 0($t2)
    beq $t1, $t3, somma
    li $v0, 10
    syscall



    li $v0, 10
    syscall

readString:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    jal open
    move $a0,$v0
    jal read
    jal print
    jal close
    lw $ra, 0($sp)
    addi $sp,$sp,4
    jr $ra

open:
    li $v0, 13          #system call to open file
    la $a0,file         #input file name
    li $a1, 0           #open to read file, 0 is for reading
    li $a2, 1           #writing mode is ignored, 1 is for writing
    syscall             #open a file(the file descriptor is returned in v0)
    blt $v0, 0, error   #error
    jr $ra


#Read Data
#$a0 = address of input buffer
#$a1 = maximum number of characters to read
#For specified length n, string can be no longer than n-1.
#If less than that, adds newline to end. In either case, then pads with null byte If n = 1, input is ignored and null byte placed at buffer address.
# If n < 1, input is ignored and nothing is written to the buffer.

read:
    li $v0, 14             # Read File Syscall
    #move  $a0, $t6        # Load File Descriptor
    la $a1, string
    li $a2, 150            #Size buffer chiamate
    syscall
    jr $ra

# Close File

close:
    li $v0, 16        # Close File Syscall
    move $a0, $zero   # Load File Descriptor
    syscall
    jr $ra

endArray:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    jal resetRegisters
    la $t0,stack
    li $t1,0
    move $t2,$s1
while_not_end:
    beq $t1,$t2,while_not_end_done
    addi $t1,$t1,1
    addi $t0,$t0,4
    j while_not_end
while_not_end_done:
    move $v0,$t0
    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra


getThirdChar:
    la $t0, string
    add $t0,$t0,$a0
    addi $t0, $t0, 2
    lb $v0, 0($t0)
    jr $ra

recognizeOperation:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    jal resetRegisters
    lw $ra,0($sp)
    addi $sp,$sp,4
    move $t0,$a0
    la $t1, main_bytes
    la $t2, jump_next
    lb $t3, 0($t1)
    lw $t4, 0($t2)
    beq $t0, $t3, sum
    lb $t3, 1($t1)
    lw $t4, 4($t2)
    beq $t0, $t3, substraction
    lb $t3, 2($t1)
    lw $t4, 8($t2)
    beq $t0, $t3, multiplication
    lb $t3, 3($t1)
    lw $t4, 12($t2)
    beq $t0, $t3, division
sum:
    add $v0, $v0, $t4
    lb $v1, 0($t1)
    j exit_ro
substraction:
    add $v0, $v0, $t4
    lb $v1, 1($t1)
    j exit_ro
multiplication:
    add $v0, $v0, $t4
    lb $v1, 2($t1)
    j exit_ro
division:
    add $v0, $v0, $t4
    lb $v1, 3($t1)
    j exit_ro
exit_ro:
    jr $ra


convert:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    jal resetRegisters
    lw $ra,0($sp)
    addi $sp,$sp,4
    la $t0, string
    add $t0,$t0,$a0
    li $t1, 10
    li $t4,0
    add $t3,$t3,$a0
    addi $t3,$t3,1
while:
    lb $t2, 0($t0)
    addi $t2,-48
    #beq $t1,-4,end_first
    bgt $t2,9, done
    blt $t2,0, done
    mul $t4,$t4,$t1
    add $t4,$t4,$t2
    addi $t0,$t0,1
    addi $t3,$t3,1
    j while
done:
    move $v0,$t4
    move $v1,$t3
    jr $ra
end_first:
    jr $ra

verifyNumber:
    addi $sp,$sp,-8
    sw $ra,0($sp)
    jal resetRegisters	  # called the function that reset the registers
    la $t0, string			  # $t0 has the address of the first character of the string read before
    la $t1, main_bytes    # $t1 points to the main_bytes head
    la $t5, jump_next     # $t5 points to the jump_next array head
    move $t2, $a0			    # $t2 has the position of the string to read later
    add $t0,$t0,$t2			  # $t0 now point to the position of the $t1 character
    lb $t3,0($t0)			    # $t1 has the character pointed by $t0
    addi $t3,$t3,-48
    bgt $t3,9, go_to_operations
    blt $t3,0, go_to_operations
done_verify:
    lw $ra,0($sp)
    addi $sp,$sp,4
    move $v0,$t3
    jr $ra
go_to_operations:
    move $a0,$t2
    jal getThirdChar
    sw $v0,4($sp)
    move $a0,$v0
    jal recognizeOperation
    move $a0,$v0
    jal nextNumber
    lb $t4,0($t1)
    lw $t6,0($t5)
    beq $t3,$t2,go_to_sum
    lb $t4,1($t1)
    lb $t6,4($t1)
    beq $t3,$t2,go_to_sub
    lb $t3, 2($t1)
    lw $t4, 8($t2)
    beq $t3,$t2,go_to_mul
    lb $t3, 3($t1)
    lw $t4, 12($t2)
    beq $t3,$t2,go_to_div

go_to_sum:

    jr $ra



#Next number is a function that
#It receive as Argument in $a0
nextNumber:
    addi $sp,$sp,-8
    sw $ra, 0($sp)
    jal resetRegisters
    jal verifyNumber
    jal convert
    sw $v0,($s0)
    addi $s0,$s0,4
    addi $s1,$s1,1
    sw $v1,4($sp)
    #sw $t0,8($sp)
    move $a0,$v0
    move $a0,$v1
    jal convert
    #lw $t0,8($sp)
    move $t0,$v0
    sw $t0,($s0)
    addi $s0,$s0,4
    addi $s1,$s1,1
    lw $ra, 0($sp)
    addi $sp,$sp,8
    #move $v0,$t0
    jr $ra

printChar:
    #lw $a0,4($sp)
    li $v0, 11
    syscall
    jr $ra

printNumber:
    li $v0,1
    syscall
    jr $ra
# Print Data

print:
    li $v0, 4      # Print String Syscall
    la $a0, string # Load Contents String
    syscall
    jr $ra

# Error

error:
    li  $v0, 4  # Print String Syscall
    la $a0, error_message  # Load Error String
    syscall
    jr $ra

resetRegisters:
    move $v0,$zero
    move $v1,$zero
    move $t0,$zero
    move $t1,$zero
    move $t2,$zero
    move $t3,$zero
    move $t4,$zero
    move $t5,$zero
    move $t6,$zero
    jr $ra


somma:
    addi $sp,$sp,-4
    sw $ra, 0($sp)
    add $t0, $a0, $a1
    move $v0,$t0
    move $a0,$t0
    jal printNumber
    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra

sottrazione:
    lw $t1, 0($sp)				#pop primo operando
    lw $t2, 4($sp)				#pop secondo operando
    sub $t3, $t1, $t2
    move $v0, $t3
    addi $sp, $sp,-4
    sw $t3, 0($sp)				#push risultato
    addi $sp, $sp,-1
    la $t4, sot 				#sot è la stringa "s" che identifica una sottrazione
    sb $t4, 0($sp)
    jr $ra

moltiplicazione:
    lw $t1, 0($sp)				#pop primo operando
    lw $t2, 4($sp)				#pop secondo operando
    mult $t1, $t2
    mflo $t3                    #mette in t3 il risultato della moltiplicazione contenuto nel registro H1
    addi $sp, $sp,-4
    move $v0, $t3
    sw $t3, 0($sp)				#push risultato
    addi $sp, $sp,-1
    la $t4, multi 				#mul è la stringa "s" che identifica una moltiplicazione
    sb $t4, 0($sp)
    jr $ra


divisione:
    lw $t1, 0($sp)				#pop primo operando
    lw $t2, 4($sp)				#pop secondo operando
    div $t1, $t2
    mflo $t3                    #mette in t3 il risultato della divisione contenuto nel registro Lo
    addi $sp, $sp,-4
    sw $t3, 0($sp)              #push risultato
    move $v0, $t3
    addi $sp, $sp,-1
    la $t4, division			#div è la stringa "s" che identifica una divisione
    sb $t4, 0($sp)#
    jr $ra
