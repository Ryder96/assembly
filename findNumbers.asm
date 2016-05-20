#values of m,t,l,v
#l=108, m=109, t=116, v =118

.data
string_somma: .asciiz "somma(5,2)"
string_sott:  .asciiz "sottrazione(5,2)"
string_molt:  .asciiz "moltiplicazione(5,2)"
string_divi:  .asciiz "divisione(5,2)"


.text
main:
    addi $sp, $sp, -4
    jal getThirdChar
    jal printChar
    li $v0, 10
    syscall


getThirdChar:
    la $t0, string_sott
    lb $v0, 3($t0)
    jr $ra


printChar:
    lw $a0,4($sp)
    li $v0, 11
    syscall
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
