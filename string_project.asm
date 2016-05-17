#Assembly program that read a string fromi a file and does the operations written on it

# The first part of the program was written by Jessica Elezi and read the string from a file
# Called operazione.txt

.data
file: .asciiz "/run/media/andres/Dati/Work/Uni/Assembly/Stringhe/operazione.txt"
string: .space 150
error_message: .asciiz "Some error"
main_bytes: .byte 'm', 't' , 'l', 'v' #soMma, soTtrazione, moLtiplicazione, diVisione
jump_next: .word 6, 12, 16, 10

.text

main:
    addi $sp,$sp,-8
    sw $ra, 8($sp)
    jal readString
    move $a0,$zero
    jal getThirdChar
    move $a0,$v0
    jal recognizeOperation
    sw $v1,0($sp)
    move $a0,$v0
    jal nextNumber
    #li $v0, 10
    #syscall
    lw $ra,8($sp)
    jr $ra

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
    #move  a0, $t6   # Load File Descriptor
    syscall
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
    li $v0,0
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
    la $s0, string
    add $s0,$s0,$a0
    li $t0, 10
    add $t2,$t2,$a0
    addi $t2,$t2,1
while:
    lb $t1, 0($s0)
    addi $t1,-48
    #beq $t1,-4,end_first
    bgt $t1,9, done
    blt $t1,0, done
    mul $s1,$s1,$t0
    add $s1,$s1,$t1
    addi $s0,$s0,1
    addi $t2,$t2,1
    j while
done:
    move $v0,$s1
    move $v1,$t2
    jr $ra
end_first:
    jr $ra

verifyNumber:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    jal resetRegisters
    lw $ra,0($sp)
    addi $sp,$sp,4
    

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

#Next number is a function that 
#It receive as Argument in $a0 
nextNumber:
    addi $sp,$sp,-4
    sw $ra, 0($sp)
    jal resetRegisters
    jal verifyNumber
    jal convert
    sw $v1,4($sp)
    move $a0,$v0
    jal printNumber
    jal convert
    move $a0,$v1
    jal printNumber
    lw $ra, 0($sp)
    addi $sp,$sp,4
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
