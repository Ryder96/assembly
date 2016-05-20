.data
som: .asciiz "sum"
sot: .asciiz "sub"
multi: .asciiz "mol"
division: .asciiz "divisione"

.globl main
.text

main: addi $sp, $sp, -8
      jal readInteger
      sw $v0, 0($sp)
      jal readInteger
      sw $v0, 4($sp)

      jal moltiplicazione
      move $a0, $v0
      jal printInteger
      
      jr $ra
      li $v0, 10
      syscall


readInteger:
li $v0,5
syscall
jr $ra

printInteger:
li $v0,1
syscall
jr $ra

somma: 
lw $t1, 0($sp)				#pop primo operando
lw $t2, 4($sp)				#pop secondo operando
add $t3, $t1, $t2
addi $sp, $sp,-4
move $v0, $t3
sw $t3, 0($sp)				#push risultato
addi $sp, $sp, -1
la $t4, som 				#som è la stringa "s" che identifica una somma
sb $t4, 0($sp)
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
