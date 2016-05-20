Somma: 
lw $t1, 0($sp)				#pop primo operando
lw $t2, 4($sp)				#pop secondo operando
add $t3, $t1, $t2
addi $sp, $sp,-4			
sw $t3, 0($sp)				#push risultato
addi $sp, $sp, -1
la $t4, som 				#som è la stringa "s" che identifica una somma
sb $t4, 0($sp)
jr $ra

Sottrazione:
lw $t1, 0($sp)				#pop primo operando
lw $t2, 4($sp)				#pop secondo operando
sub $t3, $t1, $t2
addi $sp, $sp,-4			
sw $t3, 0($sp)				#push risultato
addi $sp, $sp,-1	
la $t4, sot 				#sot è la stringa "s" che identifica una sottrazione
sb $t4, 0($sp)
jr $ra

Moltiplicazione:
lw $t1, 0($sp)				#pop primo operando
lw $t2, 4($sp)				#pop secondo operando
mult $t1, $t2
mfhi $t3                    #mette in t3 il risultato della moltiplicazione contenuto nel registro H1
addi $sp, $sp,-4			
sw $t3, 0($sp)				#push risultato
addi $sp, $sp,-1	
la $t4, mul 				#mul è la stringa "s" che identifica una moltiplicazione
sb $t4, 0($sp)
jr $ra


Divisione:
lw $t1, 0($sp)				#pop primo operando
lw $t2, 4($sp)				#pop secondo operando
div $t1, $t2
mflo $t3                    #mette in t3 il risultato della divisione contenuto nel registro Lo
addi $sp, $sp,-4			
sw $t3, 0($sp)				#push risultato
addi $sp, $sp,-1	
la $t4, divisione			#div è la stringa "s" che identifica una divisione
sb $t4, 0($sp)
jr $ra
