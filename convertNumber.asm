.data
string: .space 10

.globl main
.text
main:
    addi $sp,$sp, -8
    jal readNumber
    sw $v0, 0($sp)
    jal convert
    sw $v0, 4($sp)
    jal printString
    jal printNumber

    addi $sp,$sp,8

    li $v0, 10
    syscall



readNumber:
    li $v0, 8       #8 is used to make a system call to read a string
    la $a0, string
    syscall
    move $v0, $a0
    jr $ra

convert:
    lw $s0, 0($sp)
    li $t0, 10

while:
    lb $t1, 0($s0)
    addi $t1,-48
    bgt $t1,9, done
    blt $t1,0, done
    mul $s1,$s1,$t0
    add $s1,$s1,$t1
    addi $s0,1
    j while
done:
    move $v0,$s1
    jr $ra

printString:
    li $v0,4
    lw $a0, 0($sp)
    syscall
    jr $ra

printNumber:
    li $v0,1
    lw $a0, 4($sp)
    syscall
    jr $ra




