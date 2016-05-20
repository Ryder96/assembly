# MIPS program that recognize a char of a string
.data

stringa: .space 150
sum: .asciiz "m" #ascii code ->
sot: .asciiz "t"
molt: .asciiz "l"
division: .asciiz "v"
.globl main
.text
main:
    addi $sp,$sp,-4
    jal readString
    sw $v0,4($sp)
    lw $a0,4($sp)
    jal readChar
    sw $v0,0($sp)
    lw $a0,0($sp)
    jal printChar

    jal closeProgram

    jr $ra


readString:
    li $v0,8
    la $a0, stringa
    syscall
    li $v0,4
    la $a0,stringa
    syscall
    move $v0,$a0
    jr $ra

readChar:
    lb $v0,3($a0)
    jr $ra

printChar:
    li $v0, 11
    syscall
    jr $ra

closeProgram:
    li $v0,10
    syscall
